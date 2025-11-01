#tag Class
Protected Class ConditionalExpression
Inherits EXS.Expressions.Expression
	#tag Method, Flags = &h0
		Function Accept(visitor As EXS.Expressions.IVisitor) As Variant
		  Return visitor.VisitConditional(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(test As Expression, ifTrue As Expression)
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  mNodeType= ExpressionType.Conditional
		  mTest= test
		  mTrue= ifTrue
		  mType= ifTrue.Type
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(test As Expression, ifTrue As Expression, ifFalse As Expression)
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor(test As Expression, ifTrue As Expression) -- From ConditionalExpression
		  // Constructor() -- From Expression
		  Constructor(test, ifTrue)
		  
		  mFalse= ifFalse
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(test As Expression, ifTrue As Expression, ifFalse As Expression, typeExpr As Introspection.TypeInfo)
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor(test As Expression, ifTrue As Expression, ifFalse As Expression) -- From FullConditionalExpression
		  // Constructor(test As Expression, ifTrue As Expression) -- From ConditionalExpression
		  // Constructor() -- From Expression
		  Constructor(test, ifTrue, ifFalse)
		  
		  mType= typeExpr
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Make(test As Expression, ifTrue As Expression, ifFalse As Expression, typeExpr As Introspection.TypeInfo) As ConditionalExpression
		  If ifTrue.Type<> typeExpr Or ifFalse.Type<> typeExpr Then
		    Return New ConditionalExpression(test, ifTrue, ifFalse, typeExpr)
		  ElseIf  ifFalse IsA DefaultExpression And ifFalse.Type= GetType("Ptr") Then
		    Return New ConditionalExpression(test, ifTrue)
		  Else
		    Return New ConditionalExpression(test, ifTrue, ifFalse)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  'Const kIIF= "IIF(#c, #t, #f)"
		  Const kIIF= "#c ? #t : #f"
		  
		  Return  kIIF.Replace("#c", mTest.ToString).Replace("#t", IfTrue.ToString).Replace("#f", IfFalse.ToString)
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

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mTrue
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mTrue= value
			End Set
		#tag EndSetter
		IfTrue As Expression
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mFalse As Expression
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTest As Expression
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTrue As Expression
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mTest
			End Get
		#tag EndGetter
		Test As Expression
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
