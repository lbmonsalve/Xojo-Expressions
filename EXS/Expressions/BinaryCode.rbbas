#tag Class
Protected Class BinaryCode
	#tag Method, Flags = &h0
		Sub Constructor()
		  // use bigEndian for vuint type
		  
		  mHeaderMB= New MemoryBlock(kStreamMinSize) // 12bytes
		  mHeaderMB.LittleEndian= False // bigEndian
		  mHeaderBS= New BinaryStream(mHeaderMB)
		  mHeaderBS.LittleEndian= False // bigEndian
		  
		  mHeaderBS.WriteUInt32 kStreamMagicHeader // 4bytes
		  mHeaderBS.Write GetVersion // 3bytes
		  mHeaderBS.Write GetVUInt64(GetFlags) // 1byte
		  mHeaderFirstInstruction= mHeaderBS.Position
		  mHeaderBS.WriteUInt16 mHeaderBS.Length // address first instruction 2bytes= 10bytes
		  
		  mInstructionsMB= New MemoryBlock(2) // twoBytes -> ret zero
		  mInstructionsMB.LittleEndian= False // bigEndian
		  mInstructionsBS= New BinaryStream(mInstructionsMB)
		  mInstructionsBS.LittleEndian= False // bigEndian
		  
		  Init
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(file As FolderItem, Optional loading As LoadingAction)
		  mLoading= loading
		  
		  If file Is Nil Then Raise GetRuntimeExc("file Is Nil")
		  
		  Dim bs As BinaryStream= BinaryStream.Open(file)
		  bs.LittleEndian= False
		  If bs.Length< kStreamMinSize Then Raise GetRuntimeExc("bs.Length< kStreamMinSize")
		  
		  Dim magic As UInt32= bs.ReadUInt32
		  If magic<> kStreamMagicHeader Then Raise GetRuntimeExc("magic<> 0xBEBECAFE")
		  
		  Dim versionMajor As UInt8= bs.ReadUInt8 // semver 2.0
		  If versionMajor> kVersionMayor Then Raise GetRuntimeExc("versionMajor> kVersionMayor")
		  Dim versionMinor As UInt16= bs.ReadUInt16
		  If versionMinor> kVersionMinor Then Raise GetRuntimeExc("versionMinor> kVersionMinor")
		  
		  Dim sizeByte As UInt8= GetVUInt64Size(bs.ReadUInt8)
		  bs.Position= bs.Position- 1
		  Dim flags As UInt64= GetVUInt64Value(bs.Read(sizeByte))
		  
		  Dim instructionsPosition As UInt16= bs.ReadUInt16
		  
		  If Not (mLoading Is Nil) Then // RaiseEvent Loading
		    If mLoading.Invoke(versionMajor, versionMinor, flags) Then Return
		  End If
		  
		  bs.Position= 0
		  mHeaderMB= bs.Read(instructionsPosition)
		  mHeaderMB.LittleEndian= False
		  mHeaderBS= New BinaryStream(mHeaderMB)
		  mHeaderBS.LittleEndian= False
		  
		  mInstructionsMB= bs.Read(bs.Length- instructionsPosition)
		  mInstructionsMB.LittleEndian= False
		  mInstructionsBS= New BinaryStream(mInstructionsMB)
		  mInstructionsBS.LittleEndian= False
		  
		  Init
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Disassemble() As String
		  Dim sb() As String
		  
		  Dim bs As BinaryStream= mHeaderBS
		  bs.Position= 0
		  
		  sb.Append "# Header"
		  sb.Append "+--------+------+---------------------+"
		  sb.Append "| offset | size | value               |"
		  sb.Append "+--------+------+---------------------+"
		  sb.Append "| 0      | 4    | magic  : 0x"+ Hex(bs.ReadUInt32)
		  sb.Append "| 4      | 1    | version: "+ Str(bs.ReadUInt8)
		  sb.Append "| 5      | 2    | minor  : "+ Str(bs.ReadUInt16)
		  
		  Dim sizeByte As UInt8= GetVUInt64Size(bs.ReadUInt8)
		  bs.Position= bs.Position- 1
		  Dim flags As UInt64= GetVUInt64Value(bs.Read(sizeByte))
		  
		  sb.Append "| 7      | "+ Str(sizeByte)+ "    | flags  : "+ Bin(flags)
		  sb.Append "| "+ Str(bs.Position)+ "      | 2    | ioffset: "+ Str(bs.ReadUInt16)
		  sb.Append "+--------+------+---------------------+"
		  
		  Dim idx As UInt32
		  
		  sb.Append "# Symbols"
		  
		  while Not bs.EndFileEXS
		    sb.Append DisassembleSymbol(bs, idx)
		    idx= idx+ 1
		  Wend
		  
		  bs= mInstructionsBS
		  bs.Position= 0
		  
		  sb.Append "# Instructions"
		  
		  while Not bs.EndFileEXS
		    sb.Append DisassembleInstruction(bs)
		  Wend
		  
		  Return Join(sb, EndOfLine.Windows)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DisassembleInstruction(bs As BinaryStream) As String
		  Dim offset As UInt64= bs.Position
		  Dim instruction As UInt8= bs.ReadUInt8
		  Dim opCode As OpCodes= instruction.ToOpCodes
		  
		  Select Case opCode
		  Case OpCodes.Nop
		    Return Str(offset, "00000")+ " "+ instruction.OpCodesToString
		  Case OpCodes.Ret
		    Dim sizeByte As UInt8= GetVUInt64Size(mInstructionsBS.ReadUInt8)
		    mInstructionsBS.Position= mInstructionsBS.Position- 1
		    
		    Dim idx As Integer= GetVUInt64Value(mInstructionsBS.Read(sizeByte))
		    
		    Return Str(offset, "00000")+ " "+ instruction.OpCodesToString+ _
		    " idx: "+ Str(idx)
		  Case OpCodes.Load
		    Dim sizeByte As UInt8= GetVUInt64Size(mInstructionsBS.ReadUInt8)
		    mInstructionsBS.Position= mInstructionsBS.Position- 1
		    
		    Dim idx As Integer= GetVUInt64Value(mInstructionsBS.Read(sizeByte))
		    
		    Return Str(offset, "00000")+ " "+ instruction.OpCodesToString+ _
		    " idx: "+ Str(idx)
		  Case OpCodes.Convert
		    Dim sizeByte As UInt8= GetVUInt64Size(mInstructionsBS.ReadUInt8)
		    mInstructionsBS.Position= mInstructionsBS.Position- 1
		    
		    Dim idxParam As Integer= GetVUInt64Value(mInstructionsBS.Read(sizeByte))
		    
		    sizeByte= GetVUInt64Size(mInstructionsBS.ReadUInt8)
		    mInstructionsBS.Position= mInstructionsBS.Position- 1
		    
		    Dim idxType As Integer= GetVUInt64Value(mInstructionsBS.Read(sizeByte))
		    
		    Return Str(offset, "00000")+ " "+ instruction.OpCodesToString+ _
		    " idx: "+ Str(idxParam)+ " idxType: "+ Str(idxType)
		    
		  Case Else
		    Return "Unknown opcode 0x"+ Hex(instruction)
		  End Select
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DisassembleSymbol(bs As BinaryStream, idx As UInt32) As String
		  Dim key As UInt8= bs.ReadUInt8
		  Dim lng As Integer= Bitwise.ShiftRight(key, 5)
		  Dim typ As Integer= &b00001111 And key
		  Dim offset As UInt64= bs.Position
		  
		  Select Case typ
		  Case 4 // Int32
		    Dim value As Int32= bs.ReadInt32
		    Return Str(offset, "00000")+ " i32("+ Str(typ)+ ") "+ Str(idx)+ " "+ Str(value)
		  Case 6 // Int64
		    Dim value As Int64= bs.ReadInt64
		    Return Str(offset, "00000")+ " i64("+ Str(typ)+ ") "+ Str(idx)+ " "+ Str(value)
		  Case 12 // Single
		    Dim value As Single= bs.ReadSingle
		    Return Str(offset, "00000")+ " f32("+ Str(typ)+ ") "+ Str(idx)+ " "+ Str(value)
		  Case 13 // Double
		    Dim value As Double= bs.ReadDouble
		    Return Str(offset, "00000")+ " f64("+ Str(typ)+ ") "+ Str(idx)+ " "+ Str(value)
		  Case 14 // Boolean
		    Dim value As Boolean= bs.ReadBoolean
		    Return Str(offset, "00000")+ " bol("+ Str(typ)+ ") "+ Str(idx)+ " "+ Str(value)
		  Case 15 // string
		    Dim value As String
		    If lng= 0 Then
		      Dim size As UInt8= bs.ReadUInt8
		      offset= bs.Position
		      value= bs.Read(size)
		    ElseIf lng= 1 Then
		      Dim size As UInt16= bs.ReadUInt16
		      offset= bs.Position
		      value= bs.Read(size)
		    Else
		      Raise GetRuntimeExc("length of string greater than 0xFFFF")
		    End If
		    Return Str(offset, "00000")+ " str("+ Str(typ)+ ") "+ Str(idx)+ " """+ value+ """"
		    
		  Case 0 // Int8
		    Dim value As Int8= bs.ReadInt8
		    Return Str(offset, "00000")+ " i8("+ Str(typ)+ ") "+ Str(idx)+ " "+ Str(value)
		  Case 1 // UInt8
		    Dim value As UInt8= bs.ReadUInt8
		    Return Str(offset, "00000")+ " u8("+ Str(typ)+ ") "+ Str(idx)+ " "+ Str(value)
		  Case 2 // Int16
		    Dim value As Int16= bs.ReadInt16
		    Return Str(offset, "00000")+ " i16("+ Str(typ)+ ") "+ Str(idx)+ " "+ Str(value)
		  Case 3 // UInt16
		    Dim value As UInt16= bs.ReadUInt16
		    Return Str(offset, "00000")+ " u16("+ Str(typ)+ ") "+ Str(idx)+ " "+ Str(value)
		  Case 5 // UInt32
		    Dim value As UInt32= bs.ReadUInt32
		    Return Str(offset, "00000")+ " u32("+ Str(typ)+ ") "+ Str(idx)+ " "+ Str(value)
		  Case 7 // UInt64
		    Dim value As UInt64= bs.ReadUInt64
		    Return Str(offset, "00000")+ " u64("+ Str(typ)+ ") "+ Str(idx)+ " "+ Str(value)
		    
		  Case Else
		    Raise GetRuntimeExc("Unknown type symbol"+ Str(typ))
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EmitCode(code As OpCodes)
		  mInstructionsBS.WriteUInt8 code.ToInteger
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EmitValue(value As UInt64)
		  mInstructionsBS.Write GetVUInt64(value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Init()
		  mSymbolCache= New Dictionary
		  
		End Sub
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Function LoadingAction(majorVersion As UInt8, minorVersion As UInt16, flags As UInt64) As Boolean
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h0
		Sub Save(file As FolderItem)
		  If file Is Nil Then Raise GetRuntimeExc("file Is Nil")
		  If mHeaderBS Is Nil Then Raise GetRuntimeExc("mHeaderBS Is Nil")
		  If mInstructionsBS Is Nil Then Raise GetRuntimeExc("mInstructionsBS Is Nil")
		  
		  Dim headerPosition As UInt64= mHeaderBS.Position
		  Dim instructionsPosition As UInt64= mInstructionsBS.Position
		  
		  mHeaderBS.Position= 0
		  mInstructionsBS.Position= 0
		  
		  Dim bs As BinaryStream= BinaryStream.Create(file, True)
		  bs.Write mHeaderBS.Read(mHeaderBS.Length)
		  bs.Write mInstructionsBS.Read(mInstructionsBS.Length)
		  bs.Close
		  
		  mHeaderBS.Position= headerPosition
		  mInstructionsBS.Position= instructionsPosition
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StoreSymbol(expr As ConstantExpression) As Integer
		  Dim value As Variant= expr.Value
		  If mSymbolCache.HasKey(value) Then Return mSymbolCache.Value(value).IntegerValue
		  
		  Dim valueType As Integer= value.Type
		  
		  Select Case valueType
		  Case 2 // integer Int32
		    mHeaderBS.WriteUInt8 4
		    mHeaderBS.WriteInt32 value.Int32Value
		  Case 3 // long Int64
		    mHeaderBS.WriteUInt8 6
		    mHeaderBS.WriteInt64 value.Int64Value
		  Case 4 // single
		    mHeaderBS.WriteUInt8 12
		    mHeaderBS.WriteSingle value.SingleValue
		  Case 5, 6 // double
		    mHeaderBS.WriteUInt8 13
		    mHeaderBS.WriteDouble value.DoubleValue
		  Case 7 // date as u64
		    mHeaderBS.WriteUInt8 13
		    mHeaderBS.WriteDouble value.DateValue.TotalSeconds
		  Case 8 // string
		    Return StoreSymbol(value.StringValue)
		  Case 9 // object
		    Break
		    'Dim mb As MemoryBlock= GetVUInt64(GetObjectID(expr))
		  Case 11 // boolean
		    mHeaderBS.WriteUInt8 14
		    mHeaderBS.WriteBoolean value.BooleanValue
		  Case Else
		    Raise GetRuntimeExc("variant type not implemented!")
		  End Select
		  mHeaderMB.UInt16Value(mHeaderFirstInstruction)= mHeaderBS.Length
		  
		  mSymbolCache.Value(value)= 0
		  
		  For i As Integer= 0 To mSymbolCache.Count- 1
		    If mSymbolCache.Key(i)= value Then
		      mSymbolCache.Value(value)= i
		      Return i
		    End If
		  Next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StoreSymbol(ti As Introspection.TypeInfo) As Integer
		  Return StoreSymbol(ti.FullName)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StoreSymbol(expr As ParameterExpression) As Integer
		  Return StoreSymbol(expr.Name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StoreSymbol(s As String) As Integer
		  If mSymbolCache.HasKey(s) Then Return mSymbolCache.Value(s).IntegerValue
		  
		  Dim lng As Integer= s.LenB
		  
		  If lng< &hFF Then
		    mHeaderBS.WriteUInt8 15
		    mHeaderBS.WriteUInt8 lng
		  ElseIf lng< &hFFFF Then
		    mHeaderBS.WriteUInt8 Bitwise.ShiftLeft(1, 5) Or 15
		    mHeaderBS.WriteUInt16 lng
		  Else
		    Raise GetRuntimeExc("length of string greater than 0xFFFF")
		  End If
		  
		  mHeaderBS.Write s
		  mHeaderMB.UInt16Value(mHeaderFirstInstruction)= mHeaderBS.Length
		  
		  mSymbolCache.Value(s)= 0
		  
		  For i As Integer= 0 To mSymbolCache.Count- 1
		    If mSymbolCache.Key(i)= s Then
		      mSymbolCache.Value(s)= i
		      Return i
		    End If
		  Next
		End Function
	#tag EndMethod


	#tag Note, Name = Spec
		
		# Introduction
		store in big-endian order  
		use vUInts to encode unsigned integers [VLQ](https://en.wikipedia.org/wiki/Variable-length_quantity)  
		
		# Binary format
		
		'''
		+--------------+
		| Header       |
		+--------------+
		| Symbols      |
		+--------------+
		| Instructions |
		+--------------+
		'''
		
		'''
		+--------+------+---------------------+
		| offset | size | description         |
		+--------+------+---------------------+
		| 0      | 4    | magic: &hBEBECAFE   |
		| 4      | 1    | mayor version       |
		| 5      | 2    | minor version       |
		| 7      | 1    | flags               |
		| 8      | 2    | instructions offset |
		| 10     | n    | symbols             |
		| 10+n   | m    | instructions        |
		+--------+------+---------------------+
		'''
		
		# Symbols
		The symbols are encoded in binary format as a key-value pairs:
		
		```
		+-----+-------------------------+-------+
		| key | value length (optional) | value | n pairs...
		+-----+-------------------------+-------+
		```
		
		The key, UInt8 number (most significant bit (MSB) first) has this info:  
		
		Length = First 3 bits (0-7), length+1 in bytes of the value length when type is string.  
		Type = Last 4 bits (0-15), type of symbol.  
		
		Example 1: Length= 1, Type= 11 are key= `2B` in hexadecimal.  
		Example 2: Length= 0, Type= 4 are key= `04` in hexadecimal.  
		Example 3: Length= 3, Type= 15 are key= `6F` in hexadecimal.  
		
		The type of field could be:
		
		0 = Int8
		1 = UInt8  
		2 = Int16
		3 = UInt16  
		4 = Int32
		5 = UInt32  
		6 = Int64
		7 = UInt64  
		8, 9, 10, 11 unused
		12 = Float  
		13 = Double  
		14 = Bool  
		15 = String  
		
		the type determine the length of value: i8, u8: 1byte; i16, u16: 2Bytes;...
		
		When the type are 15 the bytes of length has the next bytes for store the string.
		```
		+-----+---------------+--------+
		| key | string length | string |
		+-----+---------------+--------+
		```
		
		Code:
		```
		  Dim key, typ, lng As UInt8
		  
		  typ= 15
		  lng= 7
		  
		  key= Bitwise.ShiftLeft(lng, 5) Or typ
		  
		  lng= Bitwise.ShiftRight(key, 5)
		  typ= &b00001111 And key
		  
		  lng= 1
		  typ= 11
		  key= Bitwise.ShiftLeft(lng, 5) Or typ
		  Dim example1 As String= "0x"+ Hex(key)
		  
		  lng= 0
		  typ= 4
		  key= Bitwise.ShiftLeft(lng, 5) Or typ
		  Dim example2 As String= "0x"+ Hex(key)
		  
		  lng= 3
		  typ= 15
		  key= Bitwise.ShiftLeft(lng, 5) Or typ
		  Dim example3 As String= "0x"+ Hex(key)
		```
		
		# Instructions
		instructions are variable-length in size  
		instruction begin with 1byte as opCode follows by variable operands  
		operands are coded in vUint format  
		
		+---------+-------+---------------------+
		| offset  | size  | description         |
		+---------+-------+---------------------+
		| 0       | 1     | opCode              |
		+---------+-------+---------------------+
		| 1       | vUint | operands            |
		| ...     | vUint | operands            |
		+---------+-------+---------------------+
		
		## Opcode instructions
		
		Nop= &h00
		
		Load= &h01
		LoadParam= &h02
		
		Store= &h03
		StoreParam= &h04
		
		Call_= &h05
		CallVirt= &h06
		
		Ret= &h07
		RetParam= &h08
		
		Add= &h09
		Subtract= &h0A
		Multiply= &h0B
		Divide= &h0C
		Modulo= &h0D
		Power= &h0E
		
		And_= &h10
		Or_= &h11
		ExclusiveOr= &h12
		LeftShift= &h13
		RightShift= &h14
		
		Jump= &h15
		JumpTrue= &h16
		JumpFalse= &h17
		JumpEqual= &h18
		JumpGreater= &h19
		JumpGreaterOrEqual= &h1A
		JumpLess= &h1B
		JumpLessOrEqual= &h1C
		
		Convert= &h1D
	#tag EndNote


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mHeaderBS
			End Get
		#tag EndGetter
		HeaderBS As BinaryStream
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mHeaderMB
			End Get
		#tag EndGetter
		HeaderMB As MemoryBlock
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mInstructionsBS
			End Get
		#tag EndGetter
		InstructionsBS As BinaryStream
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mInstructionsMB
			End Get
		#tag EndGetter
		InstructionsMB As MemoryBlock
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mHeaderBS As BinaryStream
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHeaderFirstInstruction As UInt64
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHeaderMB As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInstructionsBS As BinaryStream
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInstructionsMB As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLoading As LoadingAction
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSymbolCache As Dictionary
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mSymbolCache
			End Get
		#tag EndGetter
		Symbols As Dictionary
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
