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
		  mInvokes= New Dictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(expr As Expression)
		  Constructor
		  Compile expr
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ReverseLookup(search As String) As Integer
		  Dim last As Integer= mLocals.LastIdxEXS
		  
		  For i As Integer= last To 0 Step -1
		    If mLocals(i).Name= search Then Return i
		  Next
		  
		  Return -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ReverseScopeLookupOrAppend(search As String, scope As Integer) As Integer
		  Dim last As Integer= mLocals.LastIdxEXS
		  
		  For i As Integer= last To 0 Step -1
		    If scope> mLocals(i).Scope Then Exit
		    If mLocals(i).Name= search And mLocals(i).Scope= scope Then Return i
		  Next
		  
		  mLocals.Append New EXS.Expressions.Local(search, scope)
		  
		  Return mLocals.LastIdxEXS
		End Function
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
		  'Compile expr.Left
		  
		  Dim name As String
		  If expr.Left IsA ConstantExpression Then
		    name= ConstantExpression(expr.Left).Value.StringValue
		  ElseIf expr.Left IsA ParameterExpression Then
		    name= ParameterExpression(expr.Left).Name
		  Else
		    Break
		  End If
		  
		  If expr.Right IsA EXS.Expressions.LambdaExpression Then
		    Dim funJump As Integer= mBinaryCode.EmitJump(OpCodes.Jump)
		    
		    Dim funIni As Integer= mBinaryCode.InstructionsBS.Position
		    Dim fun As New Pair(expr.Right, mBinaryCode.StoreSymbol(New ConstantExpression(funIni)))
		    mInvokes.Value(name)= fun
		    
		    // CallFrame ini
		    Dim currIdx As Integer= mLocals.LastIdxEXS
		    // Callframe ini
		    
		    Compile EXS.Expressions.LambdaExpression(expr.Right).Body
		    
		    // CallFrame end
		    ReDim mLocals(currIdx)
		    // CallFrame end
		    
		    mBinaryCode.EmitCode OpCodes.Ret
		    
		    mBinaryCode.PatchJump funJump
		  Else
		    Dim idxLocal As Integer= ReverseLookup(name)
		    If idxLocal= -1 Then idxLocal= ReverseScopeLookupOrAppend(name, mScope)
		    
		    Compile expr.Right
		    
		    mBinaryCode.EmitCode OpCodes.Store
		    mBinaryCode.EmitValue idxLocal
		  End If
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
		  
		  If (expr.IfFalse Is Nil) Or (expr.IfFalse IsA DefaultExpression) Then
		    mBinaryCode.PatchJump thenJump
		    mBinaryCode.EmitCode OpCodes.Pop
		  Else
		    Dim elseJump As Integer= mBinaryCode.EmitJump(OpCodes.Jump)
		    mBinaryCode.PatchJump thenJump
		    mBinaryCode.EmitCode OpCodes.Pop
		    
		    Compile(expr.IfFalse)
		    
		    mBinaryCode.PatchJump elseJump
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitConstant(expr As EXS.Expressions.ConstantExpression) As Variant
		  Dim idx As Integer= ReverseLookup(expr.Value.StringValue)
		  
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
		Function VisitInvocation(expr As EXS.Expressions.InvocationExpression) As Variant
		  If expr.Expr IsA ParameterExpression Then
		    Dim param As ParameterExpression= ParameterExpression(expr.Expr)
		    
		    Dim fun As Pair= mInvokes.Value(param.Name)
		    Dim lambda As LambdaExpression= LambdaExpression(fun.Left)
		    Dim params() As ParameterExpression= lambda.Parameters
		    Dim idxLambda As Integer= fun.Right.IntegerValue
		    
		    Dim args() As Expression= expr.Arguments
		    
		    For i As Integer= 0 To args.LastIdxEXS
		      Compile args(i) // emit load
		      
		      mBinaryCode.EmitCode OpCodes.Store
		      mBinaryCode.EmitValue ReverseScopeLookupOrAppend(params(i).Name, mScope)
		    Next // args are in stack
		    
		    mBinaryCode.EmitCode OpCodes.Invoke
		    mBinaryCode.EmitValue idxLambda
		    
		    For i As Integer= 0 To args.LastIdxEXS
		      Call mLocals.Pop
		    Next // remove params
		    
		  Else
		    Break
		    'Raise GetRuntimeExc("Not (expr.Expr IsA EXS.Expressions.ParameterExpression)")
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitLambda(expr As EXS.Expressions.LambdaExpression) As Variant
		  Dim params() As ParameterExpression= expr.Parameters
		  
		  For i As Integer= 0 To params.LastIdxEXS
		    Dim param As ParameterExpression= params(i)
		    
		    mBinaryCode.EmitCode OpCodes.Load
		    mBinaryCode.EmitValue mBinaryCode.StoreSymbol(param)
		    
		    mBinaryCode.EmitCode OpCodes.Store
		    mBinaryCode.EmitValue ReverseScopeLookupOrAppend(param.Name, mScope)
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
		  Dim idx As Integer= ReverseLookup(expr.Name)
		  
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
		Function VisitReturn(expr As EXS.Expressions.ReturnExpression) As Variant
		  Compile expr.Expr
		  
		  mBinaryCode.EmitCode OpCodes.Ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSimpleBinary(expr As EXS.Expressions.SimpleBinaryExpression) As Variant
		  Compile expr.Left
		  
		  // short-circuit number And/Or number ??
		  Const kShortCircuit= False
		  #if kShortCircuit
		    Dim endJump As Integer
		    If expr.NodeType= ExpressionType.And_ Then
		      endJump= mBinaryCode.EmitJump(OpCodes.JumpFalse)
		    ElseIf expr.NodeType= ExpressionType.Or_ Then
		      Dim elseJump As Integer= mBinaryCode.EmitJump(OpCodes.JumpFalse)
		      endJump= mBinaryCode.EmitJump(OpCodes.Jump)
		      
		      mBinaryCode.PatchJump elseJump
		    End If
		  #endif
		  
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
		  #if kShortCircuit
		    If expr.NodeType= ExpressionType.And_ Or expr.NodeType= ExpressionType.Or_ Then
		      mBinaryCode.PatchJump endJump
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitUnary(expr As EXS.Expressions.UnaryExpression) As Variant
		  Compile expr.Operand
		  
		  If expr.NodeType= ExpressionType.Not_ Then
		    mBinaryCode.EmitCode OpCodes.Not_
		  ElseIf expr.NodeType= ExpressionType.Convert Then
		    mBinaryCode.Emitcode OpCodes.Convert
		    mBinaryCode.EmitValue mBinaryCode.StoreSymbol(expr.Type.FullName)
		  Else
		    Break
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitWhile(expr As EXS.Expressions.WhileExpression) As Variant
		  Dim pos As UInt64= mBinaryCode.InstructionsBS.Position
		  
		  Compile expr.Condition
		  
		  Dim exitJump As Integer= mBinaryCode.EmitJump(OpCodes.JumpFalse)
		  mBinaryCode.EmitCode OpCodes.Pop
		  
		  ScopeBegin
		  Compile expr.Body
		  ScopeEnd
		  
		  Call mBinaryCode.EmitJump OpCodes.Jump, pos
		  
		  mBinaryCode.PatchJump exitJump
		  mBinaryCode.EmitCode OpCodes.Pop
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
		Private mInvokes As Dictionary
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
