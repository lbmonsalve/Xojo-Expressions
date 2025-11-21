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

	#tag Method, Flags = &h21
		Private Sub ScopeBegin()
		  mScope= mScope+ 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ScopeEnd()
		  mScope= mScope- 1
		  
		  // pop locals vars
		  While mLocals.LastIdxEXS<> -1 And mLocals(mLocals.LastIdxEXS).Scope> mScope
		    mBinaryCode.EmitCode OpCodes.Pop
		    Call mLocals.Pop
		  Wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitAssign(expr As EXS.Expressions.AssignExpression) As Variant
		  Compile expr.Right
		  
		  Dim name As String
		  If expr.Left IsA ConstantExpression Then
		    name= ConstantExpression(expr.Left).Value.StringValue
		  ElseIf expr.Left IsA ParameterExpression Then
		    name= ParameterExpression(expr.Left).Name
		  End If
		  
		  'Compile expr.Left
		  
		  mBinaryCode.EmitCode OpCodes.Store
		  mBinaryCode.EmitValue mLocals.ReverseScopeLookupOrAppend(name, mScope)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBlock(expr As EXS.Expressions.BlockExpression) As Variant
		  ScopeBegin
		  
		  Dim exprs() As Expression= expr.Expressions
		  For i As Integer= 0 To exprs.LastIdxEXS
		    Compile exprs(i)
		  Next
		  
		  ScopeEnd
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitConditional(expr As EXS.Expressions.ConditionalExpression) As Variant
		  Compile expr.Test
		  
		  Dim thenJump As Integer= mBinaryCode.EmitJump(OpCodes.JumpFalse)
		  mBinaryCode.EmitCode OpCodes.Pop
		  
		  Compile expr.IfTrue
		  
		  If Not (expr.IfFalse Is Nil) Then
		    Dim elseJump As Integer= mBinaryCode.EmitJump(OpCodes.Jump)
		    mBinaryCode.PatchJump thenJump
		    mBinaryCode.EmitCode OpCodes.Pop
		    
		    Compile(expr.IfFalse)
		    
		    mBinaryCode.PatchJump elseJump
		  Else
		    mBinaryCode.PatchJump thenJump
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitConstant(expr As EXS.Expressions.ConstantExpression) As Variant
		  Dim idx As Integer= mLocals.ReverseScopeLookup(expr.Value.StringValue, mScope)
		  
		  If idx= -1 Then
		    mBinaryCode.EmitCode OpCodes.Load
		    mBinaryCode.EmitValue mBinaryCode.StoreSymbol(expr)
		  Else
		    mBinaryCode.EmitCode OpCodes.Local
		    mBinaryCode.EmitValue idx
		  End If
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
		  Dim idx As Integer= mLocals.ReverseScopeLookup(expr.Name, mScope)
		  
		  If idx= -1 Then
		    mBinaryCode.EmitCode OpCodes.Load
		    mBinaryCode.EmitValue mBinaryCode.StoreSymbol(expr)
		  Else
		    mBinaryCode.EmitCode OpCodes.Local
		    mBinaryCode.EmitValue idx
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSimpleBinary(expr As EXS.Expressions.SimpleBinaryExpression) As Variant
		  Compile expr.Left
		  
		  // short-circuit
		  Dim endJump As Integer
		  If expr.NodeType= ExpressionType.And_ Then
		    endJump= mBinaryCode.EmitJump(OpCodes.JumpFalse)
		  ElseIf expr.NodeType= ExpressionType.Or_ Then
		    Dim elseJump As Integer= mBinaryCode.EmitJump(OpCodes.JumpFalse)
		    endJump= mBinaryCode.EmitJump(OpCodes.Jump)
		    
		    mBinaryCode.PatchJump elseJump
		  End If
		  
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
		  
		  // short-circuit
		  If expr.NodeType= ExpressionType.And_ Or expr.NodeType= ExpressionType.Or_ Then
		    mBinaryCode.PatchJump endJump
		  End If
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
		Private mLocals() As Local
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mScope As Integer
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
