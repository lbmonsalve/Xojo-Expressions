#tag Class
Protected Class Resolver
Implements EXS.Expressions.IVisitor
	#tag Method, Flags = &h0
		Sub Constructor(ParamArray paramValues As Variant)
		  mParamValues= paramValues
		  mEnv= New Env
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DefineParams(paramsExpr() As EXS.Expressions.ParameterExpression)
		  If Not paramsExpr.MatchTypeWith(mParamValues) Then _
		  Raise GetRuntimeExc("Not paramsExpr.MatchTypeWith(mParamValues)")
		  
		  For i As Integer= 0 To paramsExpr.LastIdx
		    Dim paramExpr As EXS.Expressions.ParameterExpression= paramsExpr(i)
		    mEnv.Define paramExpr.Name, mParamValues(i)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Resolve(expr As EXS.Expressions.Expression) As Variant
		  Return expr.Accept(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ResolveBlock(expressions() As EXS.Expressions.Expression, newEnv As Env) As Variant
		  Dim mRetValue As Variant
		  Dim previous As Env= mEnv
		  
		  Try
		    #pragma BreakOnExceptions Off
		    mEnv= newEnv
		    
		    For i As Integer= 0 To expressions.LastIdx
		      mRetValue= Resolve(expressions(i))
		    Next
		    #pragma BreakOnExceptions Default
		  Finally
		    mEnv= previous
		  End Try
		  
		  Return mRetValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitAssign(expr As EXS.Expressions.AssignExpression) As Variant
		  Dim name As String= EXS.Expressions.ParameterExpression(expr.Left).Name
		  Dim value As Variant= Resolve(expr.Right)
		  
		  mEnv.Assign name, value
		  
		  Return value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBlock(expr As EXS.Expressions.BlockExpression) As Variant
		  Return ResolveBlock(expr.Expressions, New Env(mEnv))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitConditional(expr As EXS.Expressions.ConditionalExpression) As Variant
		  If Resolve(expr.Test) Then
		    Return Resolve(expr.IfTrue)
		  ElseIf Not (expr.IfFalse Is Nil) Then
		    Return Resolve(expr.IfFalse)
		  End If
		  
		  Return Nil
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
		Function VisitLambda(expr As EXS.Expressions.LambdaExpression) As Variant
		  DefineParams expr.Parameters
		  
		  Return Resolve(expr.Body)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitMethodBinary(expr As EXS.Expressions.MethodBinaryExpression) As Variant
		  Dim left As Variant= Resolve(expr.Left)
		  Dim right As Variant= Resolve(expr.Right)
		  
		  Dim params() As Variant
		  params.Append right
		  
		  Dim result As Variant= expr.Method.Invoke(left, params)
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitMethodCall(expr As EXS.Expressions.MethodCallExpression) As Variant
		  Dim methodParams() As Variant
		  Dim args() As EXS.Expressions.Expression= expr.Arguments
		  
		  For i As Integer= 0 To args.LastIdx
		    Dim arg As Variant= Resolve(args(i))
		    methodParams.Append arg
		  Next
		  
		  Dim methodInfo As Introspection.MethodInfo= expr.Method
		  Dim mRetValue As Variant
		  
		  If methodInfo.ReturnType Is Nil Then
		    methodInfo.Invoke Nil, methodParams
		  Else
		    mRetValue= methodInfo.Invoke(Nil, methodParams)
		  End If
		  
		  Return mRetValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitParameter(expr As EXS.Expressions.ParameterExpression) As Variant
		  Return mEnv.Get(expr.Name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSimpleBinary(expr As EXS.Expressions.SimpleBinaryExpression) As Variant
		  Dim left, right As Variant
		  left= Resolve(expr.Left)
		  
		  If left.Type= 11 Then // TypeBoolean
		    Select Case expr.NodeType // short-circuit
		    Case EXS.ExpressionType.And_
		      If Not left Then Return left
		      
		      right= Resolve(expr.Right)
		      Return left And right
		      
		    Case EXS.ExpressionType.Or_
		      If left Then Return left
		      
		      right= Resolve(expr.Right)
		      Return left Or right
		      
		    End Select
		  End If
		  
		  right= Resolve(expr.Right)
		  
		  Select Case expr.NodeType
		  Case EXS.ExpressionType.And_
		    Return left And right
		    
		  Case EXS.ExpressionType.Or_
		    Return left Or right
		    
		  Case EXS.ExpressionType.ExclusiveOr
		    Return left XOr right
		    
		  Case EXS.ExpressionType.LeftShift
		    Return Bitwise.ShiftLeft(left, right)
		    
		  Case EXS.ExpressionType.RightShift
		    Return Bitwise.ShiftRight(left, right)
		    
		  Case EXS.ExpressionType.GreaterThan
		    Return left> right
		    
		  Case EXS.ExpressionType.GreaterThanOrEqual
		    Return left>= right
		    
		  Case EXS.ExpressionType.LessThan
		    Return left< right
		    
		  Case EXS.ExpressionType.LessThanOrEqual
		    Return left<= right
		    
		  Case EXS.ExpressionType.NotEqual
		    Return left<> right
		    
		  Case EXS.ExpressionType.Equal
		    Return left.Equals(right)
		    
		  Case EXS.ExpressionType.Add
		    Return left+ right
		    
		  Case EXS.ExpressionType.Subtract
		    Return left- right
		    
		  Case EXS.ExpressionType.Multiply
		    Return left* right
		    
		  Case EXS.ExpressionType.Divide
		    Return left/ right
		    
		  End Select
		  
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitUnary(expr As EXS.Expressions.UnaryExpression) As Variant
		  Dim from As Variant= Resolve(expr.Operand)
		  
		  Return Convert(from, expr.Type.Name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitWhile(expr As EXS.Expressions.WhileExpression) As Variant
		  While Resolve(expr.Left)
		    Call Resolve(expr.Right)
		  Wend
		  
		  Return Nil
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mEnv As Env
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mParamValues() As Variant
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
