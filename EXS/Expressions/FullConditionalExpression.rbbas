#tag Class
Protected Class FullConditionalExpression
Inherits EXS.Expressions.ConditionalExpression
	#tag Method, Flags = &h1000
		Sub Constructor(test As Expression, ifTrue As Expression, ifFalse As Expression)
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor(test As Expression, ifTrue As Expression) -- From ConditionalExpression
		  // Constructor() -- From Expression
		  Super.Constructor(test, ifTrue)
		  
		  mFalse= ifFalse
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetFalse() As Expression
		  Return mFalse
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mFalse
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mFalse= value
			End Set
		#tag EndSetter
		IfFalse As Expression
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mFalse As Expression
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
