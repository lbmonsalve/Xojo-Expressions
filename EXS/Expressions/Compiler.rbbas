#tag Class
Protected Class Compiler
Implements IVisitor
	#tag Method, Flags = &h0
		Sub Compile(expr As Expression)
		  Call expr.Accept(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  mBinaryCode= New BinaryCode
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(expr As Expression)
		  Constructor
		  Compile expr
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitAssign(expr As EXS.Expressions.AssignExpression) As Variant
		  Compile expr.Right
		  Compile expr.Left
		  
		  Dim name As String
		  
		  If expr.Left IsA ConstantExpression Then
		    name= ConstantExpression(expr.Left).Value.StringValue
		  ElseIf expr.Left IsA ParameterExpression Then
		    name= ParameterExpression(expr.Left).Name
		  End If
		  
		  mBinaryCode.EmitCode OpCodes.Store
		  mBinaryCode.EmitValue mLocal.IndexOrAppend(name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBlock(expr As EXS.Expressions.BlockExpression) As Variant
		  Dim before As Integer= mLocal.LastIdxEXS
		  Dim exprs() As Expression= expr.Expressions
		  
		  For i As Integer= 0 To exprs.LastIdxEXS
		    Compile exprs(i)
		  Next
		  
		  While mLocal.LastIdxEXS> before // pop locals vars
		    mBinaryCode.EmitCode OpCodes.Pop
		    Call mLocal.Pop
		  Wend
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitConditional(expr As EXS.Expressions.ConditionalExpression) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitConstant(expr As EXS.Expressions.ConstantExpression) As Variant
		  mBinaryCode.EmitCode OpCodes.Load
		  mBinaryCode.EmitValue mBinaryCode.StoreSymbol(expr)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitLambda(expr As EXS.Expressions.LambdaExpression) As Variant
		  Dim params() As ParameterExpression= expr.Parameters
		  
		  For i As Integer= 0 To params.LastIdxEXS
		    Call mBinaryCode.StoreSymbol params(i)
		  Next
		  
		  Compile expr.Body
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitMethodBinary(expr As EXS.Expressions.MethodBinaryExpression) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitMethodCall(expr As EXS.Expressions.MethodCallExpression) As Variant
		  Dim args() As Expression= expr.Arguments
		  
		  For i As Integer= 0 To args.LastIdxEXS
		    Compile args(i)
		  Next
		  
		  mBinaryCode.EmitCode OpCodes.Call_
		  mBinaryCode.EmitValue mBinaryCode.StoreSymbol(expr)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitParameter(expr As EXS.Expressions.ParameterExpression) As Variant
		  mBinaryCode.EmitCode OpCodes.Load
		  mBinaryCode.EmitValue mBinaryCode.StoreSymbol(expr)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSimpleBinary(expr As EXS.Expressions.SimpleBinaryExpression) As Variant
		  Compile expr.Left
		  
		  // TODO: short-circuit
		  
		  Compile expr.Right
		  
		  Select Case expr.NodeType
		  Case ExpressionType.NotEqual
		    mBinaryCode.EmitCode OpCodes.Equal
		    mBinaryCode.EmitCode OpCodes.Not_
		    
		  Case ExpressionType.GreaterThanOrEqual
		    mBinaryCode.EmitCode OpCodes.Less
		    mBinaryCode.EmitCode OpCodes.Not_
		    
		  Case ExpressionType.LessThanOrEqual
		    mBinaryCode.EmitCode OpCodes.Greater
		    mBinaryCode.EmitCode OpCodes.Not_
		    
		  Case Else
		    mBinaryCode.EmitCode expr.NodeType.ToOpCode
		    
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitUnary(expr As EXS.Expressions.UnaryExpression) As Variant
		  Compile expr.Operand
		  
		  If expr.NodeType= ExpressionType.Not_ Then
		    mBinaryCode.EmitCode OpCodes.Not_
		    Return Nil
		  End If
		  
		  // TODO: convert
		  Break
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitWhile(expr As EXS.Expressions.WhileExpression) As Variant
		  
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mBinaryCode
			End Get
		#tag EndGetter
		BinaryCode As BinaryCode
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mBinaryCode As BinaryCode
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLocal() As String
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
