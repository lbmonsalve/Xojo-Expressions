#tag Class
Protected Class Resolver
Implements EXS.Expressions.IVisitor
	#tag Method, Flags = &h0
		Function Resolve(expr As EXS.Expressions.Expression) As Variant
		  Return expr.Accept(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitConstant(expr As EXS.Expressions.ConstantExpression) As Variant
		  // Parte de la interfaz EXS.Expressions.IVisitor.
		  
		  Return expr.Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitDefault(expr As EXS.Expressions.DefaultExpression) As Variant
		  // Parte de la interfaz EXS.Expressions.IVisitor.
		  
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSimpleBinary(expr As EXS.Expressions.SimpleBinaryExpression) As Variant
		  Dim left As Variant= Resolve(expr.Left)
		  Dim right As Variant= Resolve(expr.Right)
		  Dim result As Variant
		  
		  Select Case expr.NodeType
		  Case EXS.ExpressionType.Add
		    result= left+ right
		    
		  Case EXS.ExpressionType.Subtract
		    result= left- right
		    
		  Case EXS.ExpressionType.Multiply
		    result= left* right
		    
		  Case EXS.ExpressionType.Divide
		    result= left/ right
		    
		  End Select
		  
		  Return result
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
End Class
#tag EndClass
