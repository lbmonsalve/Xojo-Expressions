#tag Interface
Private Interface ILambdaCompilerFriend
	#tag Method, Flags = &h0
		Function DefineLabel() As LabelMark
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EmitCode(code As UInt8)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EmitExpr(expr As Expression, begin As LabelMark, after As LabelMark)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EmitLabel(address As Int16) As UInt64
		  
		End Function
	#tag EndMethod


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
End Interface
#tag EndInterface
