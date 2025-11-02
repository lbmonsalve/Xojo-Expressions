#tag Class
Protected Class WhileExpression
Inherits EXS.Expressions.BinaryExpression
	#tag Method, Flags = &h0
		Function Accept(visitor As EXS.Expressions.IVisitor) As Variant
		  Return visitor.VisitWhile(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(condition As Expression, body As Expression)
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor(left As Expression, right As Expression) -- From BinaryExpression
		  // Constructor() -- From Expression
		  Super.Constructor condition, body
		  
		  mNodeType= ExpressionType.While_
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  If Left Is Nil Or Right Is Nil Then Raise GetRuntimeExc("Left Is Nil Or Right Is Nil")
		  
		  Return mNodeType.ToStringSymbol+ "("+ Left.ToString+ ") "+ Right.ToString
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
