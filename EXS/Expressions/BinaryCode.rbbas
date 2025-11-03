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
		  
		  Dim instructionsPosition As UInt32= bs.ReadUInt16
		  
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
		
		# Instructions
		instructions are variable-length in size  
		instruction begin with 1byte as opCode folows by variable operands  
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
