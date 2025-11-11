#tag Class
Protected Class DefaultTypes
	#tag Property, Flags = &h0
		abol() As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		acol() As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		acur() As Currency
	#tag EndProperty

	#tag Property, Flags = &h0
		adat() As Date
	#tag EndProperty

	#tag Property, Flags = &h0
		af32() As Single
	#tag EndProperty

	#tag Property, Flags = &h0
		af64() As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		ai16() As Int16
	#tag EndProperty

	#tag Property, Flags = &h0
		ai32() As Int32
	#tag EndProperty

	#tag Property, Flags = &h0
		ai64() As Int64
	#tag EndProperty

	#tag Property, Flags = &h0
		ai8() As Int8
	#tag EndProperty

	#tag Property, Flags = &h0
		aobj() As Object
	#tag EndProperty

	#tag Property, Flags = &h0
		apoi() As Ptr
	#tag EndProperty

	#tag Property, Flags = &h0
		astrg() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		au16() As UInt16
	#tag EndProperty

	#tag Property, Flags = &h0
		au32() As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		au64() As UInt64
	#tag EndProperty

	#tag Property, Flags = &h0
		au8() As UInt8
	#tag EndProperty

	#tag Property, Flags = &h0
		avart() As Variant
	#tag EndProperty

	#tag Property, Flags = &h0
		bol As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		col As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		cur As Currency
	#tag EndProperty

	#tag Property, Flags = &h0
		dat As Date
	#tag EndProperty

	#tag Property, Flags = &h0
		f32 As Single
	#tag EndProperty

	#tag Property, Flags = &h0
		f64 As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		i16 As Int16
	#tag EndProperty

	#tag Property, Flags = &h0
		i32 As Int32
	#tag EndProperty

	#tag Property, Flags = &h0
		i64 As Int64
	#tag EndProperty

	#tag Property, Flags = &h0
		i8 As Int8
	#tag EndProperty

	#tag Property, Flags = &h0
		obj As Object
	#tag EndProperty

	#tag Property, Flags = &h0
		poi As Ptr
	#tag EndProperty

	#tag Property, Flags = &h0
		strg As String
	#tag EndProperty

	#tag Property, Flags = &h0
		u16 As UInt16
	#tag EndProperty

	#tag Property, Flags = &h0
		u32 As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		u64 As UInt64
	#tag EndProperty

	#tag Property, Flags = &h0
		u8 As UInt8
	#tag EndProperty

	#tag Property, Flags = &h0
		vart As Variant
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="bol"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="col"
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="f32"
			Group="Behavior"
			Type="Single"
		#tag EndViewProperty
		#tag ViewProperty
			Name="f64"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
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
			Name="strg"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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
