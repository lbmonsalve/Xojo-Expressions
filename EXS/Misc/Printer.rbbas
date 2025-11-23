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
		    sb.Append expr.Accept(Self) // Print(expr)
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
		Function VisitAssign(expr As EXS.Expressions.AssignExpression) As Variant
		  Return Parenthesize(expr.NodeType.ToStringSymbol, expr.Left, expr.Right)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBlock(expr As EXS.Expressions.BlockExpression) As Variant
		  Dim expressions() As EXS.Expressions.Expression= expr.Expressions
		  Dim sb() As String
		  
		  sb.Append "{"
		  For i As Integer= 0 To expressions.LastIdxEXS
		    sb.Append Print(expressions(i))
		    If i< expressions.LastIdxEXS Then sb.Append "; "
		  Next
		  sb.Append "}"
		  
		  Return Join(sb, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitConditional(expr As EXS.Expressions.ConditionalExpression) As Variant
		  Return Parenthesize(" iif ", expr.Test, expr.IfTrue, expr.IfFalse)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitConstant(expr As EXS.Expressions.ConstantExpression) As Variant
		  // Parte de la interfaz EXS.Expressions.IVisitor.
		  
		  Return expr.ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitInvocation(expr As EXS.Expressions.InvocationExpression) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitLambda(expr As EXS.Expressions.LambdaExpression) As Variant
		  Dim params() As EXS.Expressions.ParameterExpression= expr.Parameters
		  Dim sb() As String
		  
		  sb.Append "("
		  For i As Integer= 0 To params.LastIdxEXS
		    sb.Append params(i).ToString
		    If i< params.LastIdxEXS Then sb.Append ", "
		  Next
		  sb.Append ") => "
		  
		  sb.Append Print(expr.Body)
		  
		  Return Join(sb, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitMethodBinary(expr As EXS.Expressions.MethodBinaryExpression) As Variant
		  Return Parenthesize(expr.Method.Name, expr.Left, expr.Right)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitMethodCall(expr As EXS.Expressions.MethodCallExpression) As Variant
		  Return expr.ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitParameter(expr As EXS.Expressions.ParameterExpression) As Variant
		  Return expr.ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitReturn(expr As EXS.Expressions.ReturnExpression) As Variant
		  Return expr.ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSimpleBinary(expr As EXS.Expressions.SimpleBinaryExpression) As Variant
		  Return Parenthesize(expr.NodeType.ToStringSymbol, expr.Left, expr.Right)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitUnary(expr As EXS.Expressions.UnaryExpression) As Variant
		  Return expr.ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitWhile(expr As EXS.Expressions.WhileExpression) As Variant
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
