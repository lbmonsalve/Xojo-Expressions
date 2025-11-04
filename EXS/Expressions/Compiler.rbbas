#tag Class
Protected Class Compiler
Implements IVisitor
	#tag Method, Flags = &h0
		Sub Compile(expr As EXS.Expressions.Expression)
		  mBinaryCode= New BinaryCode
		  
		  Call expr.Accept(Self)
		End Sub
	#tag EndMethod

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

	#tag Method, Flags = &h21
		Private Sub ResolveBlock(expressions() As EXS.Expressions.Expression, newEnv As Env)
		  Dim previous As Env= mEnv
		  
		  Try
		    #pragma BreakOnExceptions Off
		    mEnv= newEnv
		    
		    For i As Integer= 0 To expressions.LastIdx
		      Compile(expressions(i))
		    Next
		    #pragma BreakOnExceptions Default
		  Finally
		    mEnv= previous
		  End Try
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
		  Break
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitLambda(expr As EXS.Expressions.LambdaExpression) As Variant
		  DefineParams expr.Parameters
		  Compile expr.Body
		  
		  Return Nil
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


	#tag Property, Flags = &h21
		Private mBinaryCode As BinaryCode
	#tag EndProperty

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
