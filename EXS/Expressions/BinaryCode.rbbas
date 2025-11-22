#tag Class
Protected Class BinaryCode
	#tag Method, Flags = &h0
		Sub Constructor(Optional actionFlags As FlagsAction)
		  // use bigEndian for vuint type
		  
		  mHeaderMB= New MemoryBlock(kStreamMinSize) // 10bytes
		  mHeaderMB.LittleEndian= False // bigEndian
		  mHeaderBS= New BinaryStream(mHeaderMB)
		  'mHeaderBS.LittleEndian= False // bigEndian
		  
		  mHeaderBS.WriteUInt32 kStreamMagicHeader // 4bytes
		  mHeaderBS.Write GetVersion // 3bytes
		  mHeaderBS.Write GetVUInt64(GetFlags) // 1byte
		  
		  If Not (actionFlags Is Nil) Then // RaiseEvent flagsAction
		    actionFlags.Invoke(GetFlags, mHeaderBS)
		  End If
		  
		  mHeaderFirstInstruction= mHeaderBS.Position
		  mHeaderBS.WriteUInt16 mHeaderBS.Length // address first instruction 2bytes= 10bytes
		  
		  mInstructionsMB= New MemoryBlock(2) // twoBytes -> Nop Nop
		  mInstructionsMB.LittleEndian= False // bigEndian
		  mInstructionsBS= New BinaryStream(mInstructionsMB)
		  'mInstructionsBS.LittleEndian= False // bigEndian
		  
		  Init
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(file As FolderItem, Optional loading As LoadingAction)
		  mLoaded= False
		  
		  If file Is Nil Then Raise GetRuntimeExc("file Is Nil")
		  
		  Dim bs As BinaryStream= BinaryStream.Open(file)
		  'bs.LittleEndian= False
		  If bs.Length< kStreamMinSize Then Raise GetRuntimeExc("bs.Length< kStreamMinSize")
		  
		  Dim magic As UInt32= bs.ReadUInt32
		  If magic<> kStreamMagicHeader Then Raise GetRuntimeExc("magic<> 0xBEBECAFE")
		  
		  Dim versionMajor As UInt8= bs.ReadUInt8 // semver 2.0
		  If versionMajor> kVersionMayor Then Raise GetRuntimeExc("versionMajor> kVersionMayor")
		  Dim versionMinor As UInt16= bs.ReadUInt16
		  'If versionMinor> kVersionMinor Then Raise GetRuntimeExc("versionMinor> kVersionMinor")
		  
		  Dim sizeByte As UInt8= GetVUInt64Size(bs.ReadUInt8)
		  bs.Position= bs.Position- 1
		  Dim flags As UInt64= GetVUInt64Value(bs.Read(sizeByte))
		  
		  If Not (loading Is Nil) Then // RaiseEvent Loading
		    If loading.Invoke(versionMajor, versionMinor, flags, bs) Then Return
		  End If
		  
		  Dim instructionsPosition As UInt16= bs.ReadUInt16
		  Dim symbolsPos As Integer= bs.Position
		  
		  bs.Position= 0
		  mHeaderMB= bs.Read(instructionsPosition)
		  mHeaderMB.LittleEndian= False
		  mHeaderBS= New BinaryStream(mHeaderMB)
		  'mHeaderBS.LittleEndian= False
		  
		  mInstructionsMB= bs.Read(bs.Length- instructionsPosition)
		  mInstructionsMB.LittleEndian= False
		  mInstructionsBS= New BinaryStream(mInstructionsMB)
		  'mInstructionsBS.LittleEndian= False
		  
		  bs.Close
		  
		  Init
		  
		  // load symbols
		  mHeaderBS.Position= symbolsPos
		  
		  While Not mHeaderBS.EndFileEXS
		    LoadSymbol mHeaderBS
		  Wend
		  
		  mLoaded= True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Disassemble(debugTrace As Writeable)
		  If debugTrace Is Nil Then Raise GetRuntimeExc("debugTrace Is Nil")
		  
		  Dim headerPosition As UInt64= mHeaderBS.Position
		  Dim instructionsPosition As UInt64= mInstructionsBS.Position
		  
		  Dim bs As BinaryStream= mHeaderBS
		  bs.Position= 0
		  
		  Const kL01= "# Header"
		  Const kL02= "offset size name    value"
		  Const kL03= "00000  4    magic   0x%"
		  Const kL04= "00004  1    version %"
		  Const kL05= "00005  2    minor   %"
		  Const kL06= "00007  %    flags   $"
		  Const kL07= "0000%  2    ioffset $"
		  
		  debugTrace.WriteLn kL01
		  debugTrace.WriteLn kL02
		  debugTrace.WriteLn kL03.Replace("%", Hex(bs.ReadUInt32))
		  debugTrace.WriteLn kL04.Replace("%", Str(bs.ReadUInt8))
		  debugTrace.WriteLn kL05.Replace("%", Str(bs.ReadUInt16))
		  
		  Dim sizeByte As UInt8= GetVUInt64Size(bs.ReadUInt8)
		  bs.Position= bs.Position- 1
		  Dim flags As UInt64= GetVUInt64Value(bs.Read(sizeByte))
		  
		  debugTrace.WriteLn kL06.Replace("%", Str(sizeByte)).Replace("$", Bin(flags))
		  debugTrace.WriteLn kL07.Replace("%", Str(bs.Position)).Replace("$", Str(bs.ReadUInt16))
		  
		  // symbols
		  Dim idx As UInt32
		  
		  debugTrace.WriteLn "# Symbols"
		  debugTrace.WriteLn "offset type    idx  value"
		  
		  While Not bs.EndFileEXS
		    debugTrace.WriteLn DisassembleSymbol(bs, idx)
		    idx= idx+ 1
		  Wend
		  
		  // instructions
		  bs= mInstructionsBS
		  bs.Position= 0
		  
		  debugTrace.WriteLn "# Instructions"
		  debugTrace.WriteLn "offset opcode"
		  
		  While Not bs.EndFileEXS
		    debugTrace.WriteLn DisassembleInstruction(bs)
		  Wend
		  
		  // HEX view
		  mHeaderBS.Position= 0
		  mInstructionsBS.Position= 0
		  
		  bs= BinaryStream.Create(GetTemporaryFolderItem, True)
		  'bs.LittleEndian= False
		  bs.Write mHeaderBS.Read(mHeaderBS.Length)
		  bs.Write mInstructionsBS.Read(mInstructionsBS.Length)
		  bs.Position= 0
		  
		  debugTrace.WriteLn "# HEX view "+ Str(bs.Length)+ " Bytes"
		  debugTrace.WriteLn "address  0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F dump"
		  
		  While Not bs.EndFileEXS
		    Dim pos As String= Hex(bs.Position)
		    debugTrace.Write Repeat(7- pos.Len, "0")+ pos+ " "
		    Dim dump As String= bs.Read(16)
		    Dim line As String= EncodeHex(dump, True)
		    debugTrace.WriteLn line+ Repeat(48- line.Len)+ dump.EncodePrintable
		  Wend
		  
		  bs.Close
		  
		  mHeaderBS.Position= headerPosition
		  mInstructionsBS.Position= instructionsPosition
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DisassembleInstruction(bs As BinaryStream) As String
		  Dim offset As UInt64= bs.Position
		  Dim instruction As UInt8= bs.ReadUInt8
		  Dim opCode As OpCodes= instruction.ToOpCodes
		  
		  Select Case opCode
		  Case OpCodes.Load, OpCodes.Store, OpCodes.Local, OpCodes.Call_, _
		    OpCodes.Convert
		    Dim idx As Integer= GetVUInt(bs)
		    
		    Return Str(offset, kFoff)+ "  "+ instruction.OpCodesToString+ _
		    " "+ Str(idx, kFidx)
		    
		  Case OpCodes.Nop, OpCodes.Not_, OpCodes.Pop, OpCodes.Ret
		    Return Str(offset, kFoff)+ "  "+ instruction.OpCodesToString
		    
		  Case OpCodes.Jump, OpCodes.JumpFalse
		    Dim pos As UInt16= bs.ReadUInt16
		    
		    Return Str(offset, kFoff)+ "  "+ instruction.OpCodesToString+ _
		    " "+ Str(pos, kFoff)
		    
		  Case OpCodes.And_, OpCodes.Or_, OpCodes.ExclusiveOr, OpCodes.LeftShift, _
		    OpCodes.RightShift, OpCodes.Equal, OpCodes.Greater, OpCodes.Less, _
		    OpCodes.Add, OpCodes.Subtract, OpCodes.Multiply, OpCodes.Divide, _
		    OpCodes.Modulo, OpCodes.Power
		    Return Str(offset, kFoff)+ "  "+ instruction.OpCodesToString
		    
		  Case Else
		    Return "Unknown opcode 0x"+ Hex(instruction)
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DisassembleSymbol(bs As BinaryStream, idx As UInt32) As String
		  Dim key As UInt8= bs.ReadUInt8
		  Dim lng As Integer= Bitwise.ShiftRight(key, 5)
		  Dim typ As Integer= kSTypeMask And key
		  Dim offset As UInt64= bs.Position
		  
		  Select Case typ.ToSymbolType
		  Case SymbolType.U8 // UInt8
		    Dim value As UInt8= bs.ReadUInt8
		    Return Str(offset, kFoff)+ "   u8"+ Str(typ, kFtyp)+ Str(idx, kFidx)+ Str(value)
		    
		  Case SymbolType.I8 // Int8
		    Dim value As Int8= bs.ReadInt8
		    Return Str(offset, kFoff)+ "   i8"+ Str(typ, kFtyp)+ Str(idx, kFidx)+ Str(value)
		    
		  Case SymbolType.U16 // UInt16
		    Dim value As UInt16= bs.ReadUInt16
		    Return Str(offset, kFoff)+ "  u16"+ Str(typ, kFtyp)+ Str(idx, kFidx)+ Str(value)
		    
		  Case SymbolType.I16 // Int16
		    Dim value As Int16= bs.ReadInt16
		    Return Str(offset, kFoff)+ "  i16"+ Str(typ, kFtyp)+ Str(idx, kFidx)+ Str(value)
		    
		  Case SymbolType.U32 // UInt32
		    Dim value As UInt32= bs.ReadUInt32
		    Return Str(offset, kFoff)+ "  u32"+ Str(typ, kFtyp)+ Str(idx, kFidx)+ Str(value)
		    
		  Case SymbolType.I32 // Int32
		    Dim value As Int32= bs.ReadInt32
		    Return Str(offset, kFoff)+ "  i32"+ Str(typ, kFtyp)+ Str(idx, kFidx)+ Str(value)
		    
		  Case SymbolType.U64 // UInt64
		    Dim value As UInt64= bs.ReadUInt64
		    Return Str(offset, kFoff)+ "  u64"+ Str(typ, kFtyp)+ Str(idx, kFidx)+ Str(value)
		    
		  Case SymbolType.I64 // Int64
		    Dim value As Int64= bs.ReadInt64
		    Return Str(offset, kFoff)+ "  i64"+ Str(typ, kFtyp)+ Str(idx, kFidx)+ Str(value)
		    
		  Case SymbolType.Float // Single
		    Dim value As Single= bs.ReadSingle
		    Return Str(offset, kFoff)+ "  f32"+ Str(typ, kFtyp)+ Str(idx, kFidx)+ Str(value)
		    
		  Case SymbolType.Double // Double
		    Dim value As Double= bs.ReadDouble
		    Return Str(offset, kFoff)+ "  f64"+ Str(typ, kFtyp)+ Str(idx, kFidx)+ Str(value)
		    
		  Case SymbolType.Bool // Boolean
		    Dim value As Boolean= bs.ReadBoolean
		    Return Str(offset, kFoff)+ "  bol"+ Str(typ, kFtyp)+ Str(idx, kFidx)+ Str(value)
		    
		  Case SymbolType.String // string
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
		    Return Str(offset, kFoff)+ "  str"+ Str(typ, kFtyp)+ Str(idx, kFidx)+ """"+ value+ """"
		    
		  Case SymbolType.Method
		    Dim idxName As Integer= GetVUInt(bs)
		    
		    Return Str(offset, kFoff)+ "  mtd"+ Str(typ, kFtyp)+ Str(idx, kFidx)+ _
		    Str(idxName, kFidx)
		    
		  Case SymbolType.Parameter
		    Dim idxName As Integer= GetVUInt(bs)
		    Dim idxType As Integer= GetVUInt(bs)
		    
		    Return Str(offset, kFoff)+ "  prm"+ Str(typ, kFtyp)+ Str(idx, kFidx)+ _
		    Str(idxName, kFidx)+ Str(idxType, kFidx)
		    
		  Case Else
		    Raise GetRuntimeExc("Unknown type symbol"+ Str(typ))
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EmitCode(code As OpCodes)
		  mInstructionsBS.WriteUInt8 Integer(code)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EmitJump(code As OpCodes, maxJump As UInt16 = &hFFFF) As UInt16
		  EmitCode code
		  
		  Dim pos As UInt16= mInstructionsBS.Position
		  mInstructionsBS.WriteUInt16 maxJump
		  
		  Return pos
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EmitValue(value As UInt64)
		  mInstructionsBS.Write GetVUInt64(value)
		End Sub
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub FlagsAction(flags As UInt64, bs As BinaryStream)
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h21
		Private Sub Init()
		  mSymbolCache= New Dictionary
		  ReDim mSymbols(-1)
		End Sub
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Function LoadingAction(majorVersion As UInt8, minorVersion As UInt16, flags As UInt64, bs As BinaryStream) As Boolean
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h21
		Private Sub LoadSymbol(bs As BinaryStream)
		  Dim key As UInt8= bs.ReadUInt8
		  Dim lng As Integer= Bitwise.ShiftRight(key, 5)
		  Dim typ As Integer= kSTypeMask And key
		  
		  Select Case typ.ToSymbolType
		  Case SymbolType.U8 // UInt8
		    Dim value As UInt8= bs.ReadUInt8
		    
		    mSymbols.Append value
		    mSymbolCache.Value(value)= mSymbols.LastIdxEXS
		    
		  Case SymbolType.I8 // Int8
		    Dim value As Int8= bs.ReadInt8
		    
		    mSymbols.Append value
		    mSymbolCache.Value(value)= mSymbols.LastIdxEXS
		    
		  Case SymbolType.U16 // UInt16
		    Dim value As UInt16= bs.ReadUInt16
		    
		    mSymbols.Append value
		    mSymbolCache.Value(value)= mSymbols.LastIdxEXS
		    
		  Case SymbolType.I16 // Int16
		    Dim value As Int16= bs.ReadInt16
		    
		    mSymbols.Append value
		    mSymbolCache.Value(value)= mSymbols.LastIdxEXS
		    
		  Case SymbolType.U32 // UInt32
		    Dim value As UInt32= bs.ReadUInt32
		    
		    mSymbols.Append value
		    mSymbolCache.Value(value)= mSymbols.LastIdxEXS
		    
		  Case SymbolType.I32 // Int32
		    Dim value As Int32= bs.ReadInt32
		    
		    mSymbols.Append value
		    mSymbolCache.Value(value)= mSymbols.LastIdxEXS
		    
		  Case SymbolType.U64 // UInt64
		    Dim value As UInt64= bs.ReadUInt64
		    
		    mSymbols.Append value
		    mSymbolCache.Value(value)= mSymbols.LastIdxEXS
		    
		  Case SymbolType.I64 // Int64
		    Dim value As Int64= bs.ReadInt64
		    
		    mSymbols.Append value
		    mSymbolCache.Value(value)= mSymbols.LastIdxEXS
		    
		  Case SymbolType.Float // Single
		    Dim value As Single= bs.ReadSingle
		    
		    mSymbols.Append value
		    mSymbolCache.Value(value)= mSymbols.LastIdxEXS
		    
		  Case SymbolType.Double // Double
		    Dim value As Double= bs.ReadDouble
		    
		    mSymbols.Append value
		    mSymbolCache.Value(value)= mSymbols.LastIdxEXS
		    
		  Case SymbolType.Bool // Boolean
		    Dim value As Boolean= bs.ReadBoolean
		    
		    mSymbols.Append value
		    mSymbolCache.Value(value)= mSymbols.LastIdxEXS
		    
		  Case SymbolType.String // string
		    Dim value As String
		    If lng= 0 Then
		      Dim size As UInt8= bs.ReadUInt8
		      value= bs.Read(size)
		    ElseIf lng= 1 Then
		      Dim size As UInt16= bs.ReadUInt16
		      value= bs.Read(size)
		    Else
		      Raise GetRuntimeExc("length of string greater than 0xFFFF")
		    End If
		    
		    mSymbols.Append value
		    mSymbolCache.Value(value)= mSymbols.LastIdxEXS
		    
		  Case SymbolType.Method
		    Dim idxName As Integer= GetVUInt(bs)
		    
		    Dim name As String= mSymbols(idxName)
		    Dim type As String= name.NthField("@", 1)
		    Dim meth As String= name.NthField("@", 2)
		    
		    Dim expr As EXS.Expressions.Expression
		    expr= expr.CallExpr(Nil, GetType(type), meth)
		    
		    mSymbols.Append expr
		    mSymbolCache.Value(name)= mSymbols.LastIdxEXS
		    
		  Case SymbolType.Parameter
		    Dim idxName As Integer= GetVUInt(bs)
		    Dim idxType As Integer= GetVUInt(bs)
		    
		    Dim name As String= mSymbols(idxName)
		    Dim type As String= mSymbols(idxType)
		    
		    Dim expr As EXS.Expressions.Expression
		    expr= expr.Parameter(GetType(type), name)
		    
		    mSymbols.Append expr
		    mSymbolCache.Value(expr)= mSymbols.LastIdxEXS
		    
		  Case Else
		    Raise GetRuntimeExc("Unknown type symbol"+ Str(typ))
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PatchJump(pos As UInt16, value As Integer = 0)
		  Dim currPos As UInt64= mInstructionsBS.Position
		  If value= 0 Then value= currPos//- pos+ 1 // 1= opcode
		  If value> &hFFFF Then Raise GetRuntimeExc("value> &hFFFF")
		  
		  mInstructionsBS.Position= pos
		  mInstructionsBS.WriteUInt16 value
		  
		  mInstructionsBS.Position= currPos
		End Sub
	#tag EndMethod

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
		  'bs.LittleEndian= False
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
		    Dim i64 As Int64= value.Int64Value
		    If i64>= 0 And i64<= &hFF Then // u8
		      mHeaderBS.WriteUInt8 Integer(SymbolType.U8)
		      mHeaderBS.WriteUInt8 i64
		    ElseIf i64> -128 And i64< 127 Then // i8
		      mHeaderBS.WriteUInt8 Integer(SymbolType.I8)
		      mHeaderBS.WriteInt8 i64
		    ElseIf i64>= 0 And i64<= &hFFFF Then // u16
		      mHeaderBS.WriteUInt8 Integer(SymbolType.U16)
		      mHeaderBS.WriteUInt16 i64
		    ElseIf i64> -32768  And i64< 32767  Then // i16
		      mHeaderBS.WriteUInt8 Integer(SymbolType.I16)
		      mHeaderBS.WriteInt16 i64
		    ElseIf i64> &h7FFFFFFF Then // u32
		      mHeaderBS.WriteUInt8 Integer(SymbolType.U32)
		      mHeaderBS.WriteUInt32 i64
		    Else // i32
		      mHeaderBS.WriteUInt8 Integer(SymbolType.I32)
		      mHeaderBS.WriteInt32 i64
		    End If
		    
		  Case 3 // long Int64
		    If value.DoubleValue> &h7FFFFFFFFFFFFFFF Then // u64
		      mHeaderBS.WriteUInt8 Integer(SymbolType.U64)
		      mHeaderBS.WriteUInt64 value.UInt64Value
		    Else // i64
		      mHeaderBS.WriteUInt8 Integer(SymbolType.I64)
		      mHeaderBS.WriteInt64 value.Int64Value
		    End If
		    
		  Case 4 // single
		    mHeaderBS.WriteUInt8 Integer(SymbolType.Float)
		    mHeaderBS.WriteSingle value.SingleValue
		    
		  Case 5, 6 // double
		    mHeaderBS.WriteUInt8 Integer(SymbolType.Double)
		    mHeaderBS.WriteDouble value.DoubleValue
		    
		  Case 7 // date as double
		    mHeaderBS.WriteUInt8 Integer(SymbolType.Double)
		    mHeaderBS.WriteDouble value.DateValue.TotalSeconds
		    
		  Case 8 // string
		    Return StoreSymbol(value.StringValue)
		    
		  Case 9 // object
		    Break
		    'Dim mb As MemoryBlock= GetVUInt64(GetObjectID(expr))
		    
		  Case 11 // boolean
		    mHeaderBS.WriteUInt8 Integer(SymbolType.Bool)
		    mHeaderBS.WriteBoolean value.BooleanValue
		    
		  Case Else
		    Raise GetRuntimeExc("variant type not implemented!")
		  End Select
		  mHeaderMB.UInt16Value(mHeaderFirstInstruction)= mHeaderBS.Length
		  
		  mSymbols.Append value
		  mSymbolCache.Value(value)= mSymbols.LastIdxEXS
		  
		  Return mSymbols.LastIdxEXS
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StoreSymbol(expr As MethodCallExpression) As Integer
		  Dim name As String= expr.Type.FullName+ "@"+ expr.Method.Name
		  If mSymbolCache.HasKey(name) Then Return mSymbolCache.Value(name).IntegerValue
		  
		  Dim idx As Integer= StoreSymbol(name)
		  
		  mHeaderBS.WriteUInt8 Integer(SymbolType.Method)
		  mHeaderBS.Write GetVUInt64(idx)
		  
		  mHeaderMB.UInt16Value(mHeaderFirstInstruction)= mHeaderBS.Length
		  
		  mSymbols.Append expr
		  mSymbolCache.Value(name)= mSymbols.LastIdxEXS
		  
		  Return mSymbols.LastIdxEXS
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StoreSymbol(expr As ParameterExpression) As Integer
		  If mSymbolCache.HasKey(expr) Then Return mSymbolCache.Value(expr).IntegerValue
		  
		  Dim name As Integer= StoreSymbol(expr.Name)
		  Dim typ As Integer= StoreSymbol(expr.Type.FullName)
		  
		  mHeaderBS.WriteUInt8 Integer(SymbolType.Parameter)
		  mHeaderBS.Write GetVUInt64(name)
		  mHeaderBS.Write GetVUInt64(typ)
		  
		  mHeaderMB.UInt16Value(mHeaderFirstInstruction)= mHeaderBS.Length
		  
		  mSymbols.Append expr
		  mSymbolCache.Value(expr)= mSymbols.LastIdxEXS
		  
		  Return mSymbols.LastIdxEXS
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StoreSymbol(s As String) As Integer
		  If mSymbolCache.HasKey(s) Then Return mSymbolCache.Value(s).IntegerValue
		  
		  Dim lng As Integer= s.LenB
		  
		  If lng< &hFF Then
		    mHeaderBS.WriteUInt8 Integer(SymbolType.String)
		    mHeaderBS.WriteUInt8 lng
		  ElseIf lng< &hFFFF Then
		    mHeaderBS.WriteUInt8 Bitwise.ShiftLeft(1, 5) Or Integer(SymbolType.String)
		    mHeaderBS.WriteUInt16 lng
		  Else
		    Raise GetRuntimeExc("length of string greater than 0xFFFF")
		  End If
		  
		  mHeaderBS.Write s
		  mHeaderMB.UInt16Value(mHeaderFirstInstruction)= mHeaderBS.Length
		  
		  mSymbols.Append s
		  mSymbolCache.Value(s)= mSymbols.LastIdxEXS
		  
		  Return mSymbols.LastIdxEXS
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Symbols() As Variant()
		  Return mSymbols
		End Function
	#tag EndMethod


	#tag Note, Name = Spec
		
		# Introduction
		store in big-endian order  
		use vUInts to encode unsigned integers [VLQ](https://en.wikipedia.org/wiki/Variable-length_quantity)  
		
		# Binary format
		```
		+--------------+
		| Header       |
		+--------------+
		| Symbols      |
		+--------------+
		| Instructions |
		+--------------+
		```
		
		## Header
		```
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
		```
		
		## Symbols
		The symbols are encoded in binary format as a key-value pairs:
		
		```
		+-----+-------------------------+-------+
		| key | value length (optional) | value | n pairs...
		+-----+-------------------------+-------+
		```
		
		The key, UInt8 number (most significant bit (MSB) first) has this info:  
		
		Length = First 3 bits (0-7), length+1 in bytes of the value length when type is string.  
		Type = Last 5 bits (0-32), type of symbol.  
		
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
		8, 9 unused  
		10 = Float  
		11 = Double  
		12 = Bool  
		13 = String  
		14 = Method  
		15 = Parameter  
		
		the type determine the length of value: i8, u8: 1byte; i16, u16: 2Bytes;...
		
		When the type are 13 the bytes of length has the next bytes for store the string.
		```
		+-----+---------------+--------+
		| key | string length | string |
		+-----+---------------+--------+
		```
		
		When the type are 14 idx name is vuint of method full name.
		```
		+-----+----------+
		| key | idx name |
		+-----+----------+
		```
		
		When the type are 15 idx name is vuint of param name, idx type is type name.
		```
		+-----+----------+----------+
		| key | idx name | idx type |
		+-----+----------+----------+
		```
		
		Code:
		```
		  Dim key, typ, lng As UInt8
		  
		  typ= 15
		  lng= 7
		  
		  key= Bitwise.ShiftLeft(lng, 5) Or typ
		  
		  lng= Bitwise.ShiftRight(key, 5)
		  typ= &b00011111 And key
		  
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
		
		## Instructions
		instructions are variable-length in size  
		instruction begin with 1byte as opCode follows by variable operands  
		operands are coded in vUint format  
		
		```
		+---------+-------+---------------------+
		| offset  | size  | description         |
		+---------+-------+---------------------+
		| 0       | 1     | opCode              |
		+---------+-------+---------------------+
		| 1       | vUint | operands            |
		| ...     | vUint | operands            |
		+---------+-------+---------------------+
		```
		
		### Opcode instructions
		
		Nop= &h00
		
		Load= &h01  
		Store= &h02  
		Local= &h03  
		Call_= &h04  
		Pop= &h05  
		
		Not_= &h06  
		Equal= &h07  
		Greater= &h08  
		Less= &h09  
		
		And_= &h0A  
		Or_= &h0B  
		ExclusiveOr= &h0C  
		
		Add= &h0D  
		Subtract= &h0E  
		Multiply= &h0F  
		Divide= &h10  
		Modulo= &h11  
		Power= &h12  
		
		LeftShift= &h13  
		RightShift= &h14  
		
		Convert= &h15  
		
		Jump= &h16  
		JumpFalse= &h17  
		
		Ret= &h18
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

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mLoaded
			End Get
		#tag EndGetter
		Loaded As Boolean
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
		Private mLoaded As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSymbolCache As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSymbols() As Variant
	#tag EndProperty


	#tag Constant, Name = kSTypeMask, Type = Double, Dynamic = False, Default = \"&b00011111", Scope = Private
	#tag EndConstant


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
			Name="Loaded"
			Group="Behavior"
			Type="Boolean"
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
