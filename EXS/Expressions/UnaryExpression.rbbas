#tag Class
Protected Class UnaryExpression
Inherits EXS.Expressions.Expression
	#tag Method, Flags = &h1000
		Sub Constructor(nodeType As ExpressionType, operand As Expression, typeTo As Introspection.TypeInfo, method As Introspection.MethodInfo)
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  mNodeType= nodeType
		  mOperand= operand
		  mType= typeTo
		  mMethod= method
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Select Case mNodeType
		  Case ExpressionType.Convert
		    Return "("+ mOperand.ToString+ mNodeType.ToStringsymbol+ mType.Name+ ")"
		    'Return mType.Name+ "("+ mOperand.ToString+ ")"
		    'Return "CType("+ mOperand.ToString+ ", "+ mType.Name+ ")"
		  End Select
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mMethod
			End Get
		#tag EndGetter
		Method As Introspection.MethodInfo
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mMethod As Introspection.MethodInfo
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOperand As Expression
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mOperand
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mOperand= value
			End Set
		#tag EndSetter
		Operand As Expression
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
