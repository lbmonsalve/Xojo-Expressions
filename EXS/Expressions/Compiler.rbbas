#tag Class
Protected Class Compiler
Implements IVisitor
	#tag Method, Flags = &h0
		Sub Compile(expr As EXS.Expressions.Expression)
		  Call expr.Accept(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitAssign(expr As EXS.Expressions.AssignExpression) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBlock(expr As EXS.Expressions.BlockExpression) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitConditional(expr As EXS.Expressions.ConditionalExpression) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitConstant(expr As EXS.Expressions.ConstantExpression) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitLambda(expr As EXS.Expressions.LambdaExpression) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitMethodBinary(expr As EXS.Expressions.MethodBinaryExpression) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitMethodCall(expr As EXS.Expressions.MethodCallExpression) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitParameter(expr As EXS.Expressions.ParameterExpression) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSimpleBinary(expr As EXS.Expressions.SimpleBinaryExpression) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitUnary(expr As EXS.Expressions.UnaryExpression) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitWhile(expr As EXS.Expressions.WhileExpression) As Variant
		  
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
