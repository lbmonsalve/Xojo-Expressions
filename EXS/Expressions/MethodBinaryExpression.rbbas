#tag Class
Protected Class MethodBinaryExpression
Inherits EXS.Expressions.SimpleBinaryExpression
	#tag Method, Flags = &h0
		Function Accept(visitor As EXS.Expressions.IVisitor) As Variant
		  Return visitor.VisitMethodBinary(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(nodeType As ExpressionType, left As Expression, right As Expression, retType As Introspection.TypeInfo, method As Introspection.MethodInfo)
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor(nodeType As ExpressionType, left As Expression, right As Expression, retType As Introspection.TypeInfo) -- From SimpleBinaryExpression
		  // Constructor(left As Expression, right As Expression) -- From BinaryExpression
		  // Constructor() -- From Expression
		  Super.Constructor(nodeType, left, right, retType)
		  
		  mMethod= method
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mMethod
			End Get
		#tag EndGetter
		Method As Introspection.MethodInfo
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected mMethod As Introspection.MethodInfo
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
