#tag Class
Protected Class SimpleBinaryExpression
Inherits EXS.Expressions.BinaryExpression
	#tag Method, Flags = &h0
		Function Accept(visitor As EXS.Expressions.IVisitor) As Variant
		  Return visitor.VisitSimpleBinary(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(nodeType As ExpressionType, left As Expression, right As Expression, retType As Introspection.TypeInfo)
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor(left As Expression, right As Expression) -- From BinaryExpression
		  // Constructor() -- From Expression
		  Super.Constructor(left, right)
		  
		  mNodeType= nodeType
		  mType= retType
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
