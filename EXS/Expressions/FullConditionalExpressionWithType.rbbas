#tag Class
Protected Class FullConditionalExpressionWithType
Inherits EXS.Expressions.FullConditionalExpression
	#tag Method, Flags = &h1000
		Sub Constructor(test As Expression, ifTrue As Expression, ifFalse As Expression, typeExpr As Introspection.TypeInfo)
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor(test As Expression, ifTrue As Expression, ifFalse As Expression) -- From FullConditionalExpression
		  // Constructor(test As Expression, ifTrue As Expression) -- From ConditionalExpression
		  // Constructor() -- From Expression
		  Super.Constructor(test, ifTrue, ifFalse)
		  
		  mType= typeExpr
		End Sub
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
End Class
#tag EndClass
