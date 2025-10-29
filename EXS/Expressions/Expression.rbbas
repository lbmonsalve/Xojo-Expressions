#tag Class
Protected Class Expression
	#tag Method, Flags = &h0
		Function Accept(visitor As EXS.Expressions.IVisitor) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Add(left As Expression, right As Expression) As BinaryExpression
		  Return Add(left, right, Nil)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Add(left As Expression, right As Expression, method As Introspection.MethodInfo) As BinaryExpression
		  If method Is Nil Then
		    If left.Type= right.Type Then
		      Return New SimpleBinaryExpression(ExpressionType.Add, left, right, left.Type)
		    ElseIf left.Type.IsNumber And right.Type.IsNumber Then
		      Return New SimpleBinaryExpression(ExpressionType.Add, left, right, GetType("Double"))
		    Else
		      Return New SimpleBinaryExpression(ExpressionType.Add, left, right, Nil) // tryAdd!
		    End If
		  End If
		  If Not method.ChkMethodParams(left.Type, right.Type) Then _
		  Raise GetRuntimeExc("Not method.ChkMethodParams(left.Type, right.Type)")
		  
		  Return New MethodBinaryExpression(ExpressionType.Add, left, right, method.ReturnType, method)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function And_(left As Expression, right As Expression) As BinaryExpression
		  Return And_(left, right, Nil)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function And_(left As Expression, right As Expression, method As Introspection.MethodInfo) As BinaryExpression
		  If method Is Nil Then
		    If left.Type= right.Type And left.Type.Name= "Boolean" Then
		      Return New SimpleBinaryExpression(ExpressionType.And_, left, right, left.Type)
		    ElseIf left.Type.IsInteger And right.Type.IsInteger Then
		      Return New SimpleBinaryExpression(ExpressionType.And_, left, right, GetType("UInt64"))
		    Else
		      Raise GetRuntimeExc("and ""&"" operator only with booleans or integers")
		    End If
		  End If
		  If Not method.ChkMethodParams(left.Type, right.Type) Then _
		  Raise GetRuntimeExc("Not method.ChkMethodParams(left.Type, right.Type)")
		  
		  Return New MethodBinaryExpression(ExpressionType.And_, left, right, method.ReturnType, method)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Assign(left As Expression, right As Expression) As BinaryExpression
		  'If Not (expr.Left IsA ParameterExpression) Then Raise GetRuntimeExc("Not (expr.Left IsA ParameterExpression)")
		  'If Not (expr.Right IsA ConstantExpression) Then Raise GetRuntimeExc("Not (expr.Right IsA ConstantExpression)")
		  If Not left.Type.IsAssignable(right.Type) Then Raise GetRuntimeExc("Not left.Type.IsAssignable(right.Type)")
		  
		  Return New AssignBinaryExpression(left, right)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Block(ParamArray expressions As Expression) As BlockExpression
		  Return New BlockExpression(expressions)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Block(variables() As ParameterExpression, ParamArray expressions As Expression) As BlockExpression
		  Return New ScopeExpression(variables, expressions)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function CallExpr(typeExpr As Introspection.TypeInfo, method As String, ParamArray params As Pair) As MethodCallExpression
		  Dim typeArguments() As Introspection.TypeInfo
		  Dim arguments() As Expression
		  
		  For i As Integer= 0 To params.LastIdxEXS
		    Dim item As Pair= params(i)
		    If item.Left.Type= 8 Then // string:
		      typeArguments.Append EXS.GetType(item.Left.StringValue)
		      arguments.Append Expression.Constant(item.Right)
		    End If
		  Next
		  
		  Return CallExpr(Nil, typeExpr, method, typeArguments, arguments)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function CallExpr(instance As Object, typeExpr As Introspection.TypeInfo, methodName As String, ParamArray arguments As Expression) As MethodCallExpression
		  Dim typeArguments() As Introspection.TypeInfo
		  
		  For i As Integer= 0 To arguments.LastIdx
		    Dim argument As Expression= arguments(i)
		    typeArguments.Append argument.Type
		  Next
		  
		  Return CallExpr(instance, typeExpr, methodName, typeArguments, arguments)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function CallExpr(instance As Object, typeExpr As Introspection.TypeInfo, methodName As String, typeArguments() As Introspection.TypeInfo, arguments() As Expression) As MethodCallExpression
		  Register typeExpr, typeExpr.FullName
		  
		  Return New MethodCallExpression(instance, typeExpr, methodName, typeArguments, arguments)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Condition(test As Expression, ifTrue As Expression, ifFalse As Expression) As ConditionalExpression
		  If test.Type<> GetType("Boolean") Then Raise GetRuntimeExc("test.Type<> GetType(""Boolean"")")
		  If Not ifTrue.Type.IsEquivalent(ifFalse.Type) Then Raise GetRuntimeExc("Not ifTrue.Type.IsEquivalent(ifFalse.Type)")
		  
		  Return ConditionalExpression.Make(test, ifTrue, ifFalse, ifTrue.Type)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Condition(test As Expression, ifTrue As Expression, ifFalse As Expression, typeExpr As Introspection.TypeInfo) As ConditionalExpression
		  If test.Type<> GetType("Boolean") Then Raise GetRuntimeExc("test.Type<> GetType(""Boolean"")")
		  If typeExpr<> GetType("Ptr") Then
		    If Not ifTrue.Type.IsReferenceAssignable(typeExpr) Or Not ifFalse.Type.IsReferenceAssignable(typeExpr) Then _
		    Raise GetRuntimeExc("Not ifTrue.Type.IsReferenceAssignable(typeExpr) Or Not isFalse.Type.IsReferenceAssignable(typeExpr)")
		  End If
		  
		  Return ConditionalExpression.Make(test, ifTrue, ifFalse, typeExpr)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Constant(value As Variant) As ConstantExpression
		  Return New ConstantExpression(value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Convert(expr As Expression, typeTo As Introspection.TypeInfo) As UnaryExpression
		  Return Convert(expr, typeTo, Nil)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Convert(expr As Expression, typeTo As Introspection.TypeInfo, method As Introspection.MethodInfo) As UnaryExpression
		  If method Is Nil Then
		    If Not expr.Type.IsConvertible(typeTo) Then Raise GetRuntimeExc("Not expr.Type.IsConvertible(typeTo)")
		    Return New UnaryExpression(ExpressionType.Convert, expr, typeTo, Nil)
		  Else
		    Break
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Divide(left As Expression, right As Expression) As BinaryExpression
		  Return Divide(left, right, Nil)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Divide(left As Expression, right As Expression, method As Introspection.MethodInfo) As BinaryExpression
		  If method Is Nil Then
		    If left.Type.IsNumber And right.Type.IsNumber Then
		      Return New SimpleBinaryExpression(ExpressionType.Divide, left, right, GetType("Double"))
		    Else
		      Return New SimpleBinaryExpression(ExpressionType.Divide, left, right, Nil) // tryAdd!
		    End If
		  End If
		  If Not method.ChkMethodParams(left.Type, right.Type) Then _
		  Raise GetRuntimeExc("Not method.ChkMethodParams(left.Type, right.Type)")
		  
		  Return New MethodBinaryExpression(ExpressionType.Divide, left, right, method.ReturnType, method)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Empty() As DefaultExpression
		  Return New DefaultExpression(GetType("Ptr"))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Equal(left As Expression, right As Expression) As BinaryExpression
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Lambda(body As Expression, ParamArray parameters As ParameterExpression) As LambdaExpression
		  Return New LambdaExpression(body, parameters)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function LeftShift(left As Expression, right As Expression) As BinaryExpression
		  Return LeftShift(left, right, Nil)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function LeftShift(left As Expression, right As Expression, method As Introspection.MethodInfo) As BinaryExpression
		  If method Is Nil Then
		    If left.Type.IsInteger And right.Type.IsInteger Then
		      Return New SimpleBinaryExpression(ExpressionType.LeftShift, left, right, GetType("UInt64"))
		    Else
		      Raise GetRuntimeExc("LeftShift ""<<"" operator only with integers")
		    End If
		  End If
		  If Not method.ChkMethodParams(left.Type, right.Type) Then _
		  Raise GetRuntimeExc("Not method.ChkMethodParams(left.Type, right.Type)")
		  
		  Return New MethodBinaryExpression(ExpressionType.LeftShift, left, right, method.ReturnType, method)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Modulo(left As Expression, right As Expression) As BinaryExpression
		  Return Modulo(left, right, Nil)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Modulo(left As Expression, right As Expression, method As Introspection.MethodInfo) As BinaryExpression
		  If method Is Nil Then
		    If left.Type.IsNumber And right.Type.IsNumber Then
		      Return New SimpleBinaryExpression(ExpressionType.Modulo, left, right, GetType("Double"))
		    Else
		      Return New SimpleBinaryExpression(ExpressionType.Modulo, left, right, Nil) // tryAdd!
		    End If
		  End If
		  If Not method.ChkMethodParams(left.Type, right.Type) Then _
		  Raise GetRuntimeExc("Not method.ChkMethodParams(left.Type, right.Type)")
		  
		  Return New MethodBinaryExpression(ExpressionType.Modulo, left, right, method.ReturnType, method)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Multiply(left As Expression, right As Expression) As BinaryExpression
		  Return Multiply(left, right, Nil)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Multiply(left As Expression, right As Expression, method As Introspection.MethodInfo) As BinaryExpression
		  If method Is Nil Then
		    If left.Type= right.Type Then
		      Return New SimpleBinaryExpression(ExpressionType.Multiply, left, right, left.Type)
		    ElseIf left.Type.IsNumber And right.Type.IsNumber Then
		      Return New SimpleBinaryExpression(ExpressionType.Multiply, left, right, GetType("Double"))
		    Else
		      Return New SimpleBinaryExpression(ExpressionType.Multiply, left, right, Nil) // tryAdd!
		    End If
		  End If
		  If Not method.ChkMethodParams(left.Type, right.Type) Then _
		  Raise GetRuntimeExc("Not method.ChkMethodParams(left.Type, right.Type)")
		  
		  Return New MethodBinaryExpression(ExpressionType.Multiply, left, right, method.ReturnType, method)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Or_(left As Expression, right As Expression) As BinaryExpression
		  Return Or_(left, right, Nil)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Or_(left As Expression, right As Expression, method As Introspection.MethodInfo) As BinaryExpression
		  If method Is Nil Then
		    If left.Type= right.Type And left.Type.Name= "Boolean" Then
		      Return New SimpleBinaryExpression(ExpressionType.Or_, left, right, left.Type)
		    ElseIf left.Type.IsInteger And right.Type.IsInteger Then
		      Return New SimpleBinaryExpression(ExpressionType.Or_, left, right, GetType("UInt64"))
		    Else
		      Raise GetRuntimeExc("or ""|"" operator only with booleans or integers")
		    End If
		  End If
		  If Not method.ChkMethodParams(left.Type, right.Type) Then _
		  Raise GetRuntimeExc("Not method.ChkMethodParams(left.Type, right.Type)")
		  
		  Return New MethodBinaryExpression(ExpressionType.Or_, left, right, method.ReturnType, method)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Parameter(typeParam As Introspection.ParameterInfo) As ParameterExpression
		  Return Parameter(typeParam, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Parameter(typeParam As Introspection.ParameterInfo, name As String) As ParameterExpression
		  Return ParameterExpression.Make(typeParam.ParameterType, name, typeParam.IsByRef)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Parameter(typeParam As Introspection.TypeInfo) As ParameterExpression
		  Return Parameter(typeParam, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Parameter(typeParam As Introspection.TypeInfo, name As String) As ParameterExpression
		  Return ParameterExpression.Make(typeParam, name, False)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Power(left As Expression, right As Expression) As BinaryExpression
		  Return Power(left, right, Nil)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Power(left As Expression, right As Expression, method As Introspection.MethodInfo) As BinaryExpression
		  If method Is Nil Then
		    If left.Type= right.Type Then
		      Return New SimpleBinaryExpression(ExpressionType.Power, left, right, left.Type)
		    ElseIf left.Type.IsNumber And right.Type.IsNumber Then
		      Return New SimpleBinaryExpression(ExpressionType.Power, left, right, GetType("Double"))
		    Else
		      Return New SimpleBinaryExpression(ExpressionType.Power, left, right, Nil) // tryAdd!
		    End If
		  End If
		  If Not method.ChkMethodParams(left.Type, right.Type) Then _
		  Raise GetRuntimeExc("Not method.ChkMethodParams(left.Type, right.Type)")
		  
		  Return New MethodBinaryExpression(ExpressionType.Power, left, right, method.ReturnType, method)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function RightShift(left As Expression, right As Expression) As BinaryExpression
		  Return RightShift(left, right, Nil)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function RightShift(left As Expression, right As Expression, method As Introspection.MethodInfo) As BinaryExpression
		  If method Is Nil Then
		    If left.Type.IsInteger And right.Type.IsInteger Then
		      Return New SimpleBinaryExpression(ExpressionType.RightShift, left, right, GetType("UInt64"))
		    Else
		      Raise GetRuntimeExc("RightShift "">>"" operator only with integers")
		    End If
		  End If
		  If Not method.ChkMethodParams(left.Type, right.Type) Then _
		  Raise GetRuntimeExc("Not method.ChkMethodParams(left.Type, right.Type)")
		  
		  Return New MethodBinaryExpression(ExpressionType.RightShift, left, right, method.ReturnType, method)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Subscript(left As Expression, right As Expression) As BinaryExpression
		  Return Subscript(left, right, Nil)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Subscript(left As Expression, right As Expression, method As Introspection.MethodInfo) As BinaryExpression
		  If method Is Nil Then
		    If Not (left.Type.IsArray And right.Type.IsInteger) Then
		      Raise GetRuntimeExc("Not (left.Type.IsArray And right.Type.IsInteger)")
		    End If
		    Return New SimpleBinaryExpression(ExpressionType.ArrayIndex, left, right, left.Type)
		  End If
		  If Not method.ChkMethodParams(left.Type, right.Type) Then _
		  Raise GetRuntimeExc("Not method.ChkMethodParams(left.Type, right.Type)")
		  
		  Return New MethodBinaryExpression(ExpressionType.ArrayIndex, left, right, method.ReturnType, method)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Subtract(left As Expression, right As Expression) As BinaryExpression
		  Return Subtract(left, right, Nil)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Subtract(left As Expression, right As Expression, method As Introspection.MethodInfo) As BinaryExpression
		  If method Is Nil Then
		    If left.Type= right.Type Then
		      Return New SimpleBinaryExpression(ExpressionType.Subtract, left, right, left.Type)
		    ElseIf left.Type.IsNumber And right.Type.IsNumber Then
		      Return New SimpleBinaryExpression(ExpressionType.Subtract, left, right, GetType("Double"))
		    Else
		      Return New SimpleBinaryExpression(ExpressionType.Subtract, left, right, Nil) // tryAdd!
		    End If
		  End If
		  If Not method.ChkMethodParams(left.Type, right.Type) Then _
		  Raise GetRuntimeExc("Not method.ChkMethodParams(left.Type, right.Type)")
		  
		  Return New MethodBinaryExpression(ExpressionType.Subtract, left, right, method.ReturnType, method)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Variable(typeParam As Introspection.TypeInfo) As ParameterExpression
		  Return Variable(typeParam, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Variable(typeParam As Introspection.TypeInfo, name As String) As ParameterExpression
		  Return ParameterExpression.Make(typeParam, name, False)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function XOr_(left As Expression, right As Expression) As BinaryExpression
		  Return XOr_(left, right, Nil)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function XOr_(left As Expression, right As Expression, method As Introspection.MethodInfo) As BinaryExpression
		  If method Is Nil Then
		    If  left.Type= right.Type And left.Type.Name= "Boolean" Then
		      Return New SimpleBinaryExpression(ExpressionType.ExclusiveOr, left, right, GetType("Boolean"))
		    ElseIf left.Type.IsInteger And right.Type.IsInteger Then
		      Return New SimpleBinaryExpression(ExpressionType.ExclusiveOr, left, right, GetType("UInt64"))
		    Else
		      Raise GetRuntimeExc("xor ""¿"" operator only with booleans or integers")
		    End If
		  End If
		  If Not method.ChkMethodParams(left.Type, right.Type) Then _
		  Raise GetRuntimeExc("Not method.ChkMethodParams(left.Type, right.Type)")
		  
		  Return New MethodBinaryExpression(ExpressionType.ExclusiveOr, left, right, method.ReturnType, method)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h1
		Protected mNodeType As ExpressionType
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mType As Introspection.TypeInfo
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mNodeType
			End Get
		#tag EndGetter
		NodeType As ExpressionType
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mType
			End Get
		#tag EndGetter
		Type As Introspection.TypeInfo
	#tag EndComputedProperty


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
