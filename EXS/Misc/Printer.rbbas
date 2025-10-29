#tag Class
Protected Class Printer
Implements EXS.Expressions.IVisitor
	#tag Method, Flags = &h21
		Private Function Parenthesize(name As String, ParamArray exprs As EXS.Expressions.Expression) As String
		  Dim sb() As String
		  
		  sb.Append "("
		  sb.Append name
		  
		  For Each expr As EXS.Expressions.Expression In exprs
		    sb.Append ","
		    sb.Append expr.Accept(Self)
		  Next
		  
		  sb.Append ")"
		  
		  Return Join(sb, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Print(expr As EXS.Expressions.Expression) As String
		  Return expr.Accept(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitConstant(expr As EXS.Expressions.ConstantExpression) As Variant
		  // Parte de la interfaz EXS.Expressions.IVisitor.
		  
		  Return expr.ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitDefault(expr As EXS.Expressions.DefaultExpression) As Variant
		  // Parte de la interfaz EXS.Expressions.IVisitor.
		  
		  Return expr.ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSimpleBinary(expr As EXS.Expressions.SimpleBinaryExpression) As Variant
		  Return Parenthesize(expr.NodeType.ToStringSymbol, expr.Left, expr.Right)
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
