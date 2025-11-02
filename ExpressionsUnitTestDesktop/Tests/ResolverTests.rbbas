#tag Class
Protected Class ResolverTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub AssignTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("String"), "s1")
		  
		  Dim exprs() As EXS.Expressions.Expression
		  exprs.Append expr.CallExpr(Nil, GetTypeInfo(EXS.System), "DebugLog", paramExpr)
		  exprs.Append expr.Assign(paramExpr, expr.Constant("world"))
		  exprs.Append expr.CallExpr(Nil, GetTypeInfo(EXS.System), "DebugLog", paramExpr)
		  exprs.Append paramExpr
		  
		  expr= expr.Lambda(New EXS.Expressions.BlockExpression(exprs), paramExpr)
		  
		  Dim resolver As New EXS.Misc.Resolver("hello")
		  Dim result As Variant= resolver.Resolve(expr)
		  Assert.AreSame "world", result.StringValue, "AreSame ""world"", result.StringValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BlockTest()
		  Dim expr As EXS.Expressions.Expression
		  expr= expr.Block(_
		  expr.CallExpr(Nil, GetTypeInfo(EXS.System), "DebugLog", expr.Constant("1 + 2 * 3")),_
		  expr.Add(expr.Constant(1), expr.Multiply(expr.Constant(2), expr.Constant(3)))_
		  )
		  
		  Dim resolver As New EXS.Misc.Resolver
		  Dim result As Variant= resolver.Resolve(expr)
		  Assert.AreEqual 7, result.IntegerValue, "AreEqual 7, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConditionalTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim num As Integer= 100
		  expr= expr.Condition(_
		  expr.Constant(num> 10), _
		  expr.Constant("num > 10"), _
		  expr.Constant("num < 10") _
		  )
		  
		  Dim resolver As New EXS.Misc.Resolver
		  Dim result As Variant= resolver.Resolve(expr)
		  Assert.AreSame "num > 10", result.StringValue, "AreSame ""num > 10"", result.StringValue"
		  
		  num= 9
		  expr= expr.Condition(_
		  expr.Constant(num> 10), _
		  expr.Constant("num > 10"), _
		  expr.Constant("num < 10") _
		  )
		  
		  result= resolver.Resolve(expr)
		  Assert.AreSame "num < 10", result.StringValue, "AreSame ""num < 10"", result.StringValue"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LambdaTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  expr= expr.Lambda(expr.Add(paramExpr, expr.Constant(5)), paramExpr)
		  
		  Dim resolver As New EXS.Misc.Resolver(10)
		  Dim result As Variant= resolver.Resolve(expr)
		  Assert.AreEqual 15, result.IntegerValue, "AreEqual 15, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OperTest()
		  Dim expr As EXS.Expressions.Expression
		  expr= expr.Add(expr.Constant(1), expr.Multiply(expr.Constant(2), expr.Constant(2)))
		  
		  Dim resolver As New EXS.Misc.Resolver
		  Dim result As Variant= resolver.Resolve(expr)
		  Assert.AreEqual 5, result.IntegerValue, "AreEqual 5, result.IntegerValue"
		  
		  expr= expr.And_(expr.Constant(True), expr.Constant(True))
		  result= resolver.Resolve(expr)
		  Assert.IsTrue result.BooleanValue, "IsTrue result.BooleanValue"
		  
		  expr= expr.LeftShift(expr.Constant(&b00011111), expr.Constant(2))
		  result= resolver.Resolve(expr)
		  Assert.AreEqual 124, result.IntegerValue, "AreEqual 124, result.IntegerValue"
		  
		  Dim o1 As New ObjectWithBinaryExprMethod(10)
		  Dim o2 As New ObjectWithBinaryExprMethod(20)
		  Dim o3 As ObjectWithBinaryExprMethod= o1+ o2
		  Dim methodAdd As Introspection.MethodInfo= Introspection.GetType(o1).GetMethodInfo("Operator_Add")
		  expr= expr.Add(expr.Constant(o1), expr.Constant(o2), methodAdd)
		  result= resolver.Resolve(expr)
		  Assert.AreEqual o3.Value.IntegerValue, ObjectWithBinaryExprMethod(result).Value.IntegerValue, "AreEqual o3.Value.IntegerValue, ObjectWithBinaryExprMethod(result).Value.IntegerValue"
		  
		  expr= expr.Subtract(expr.Constant(o1), expr.Constant(o2), Introspection.GetType(o1).GetMethodInfo("Operator_Subtract"))
		  result= resolver.Resolve(expr)
		  Assert.AreEqual -10, ObjectWithBinaryExprMethod(result).Value.IntegerValue, "AreEqual -10, ObjectWithBinaryExprMethod(result).Value.IntegerValue"
		  
		  expr= expr.CallExpr(Nil, GetTypeInfo(EXS.System), "DebugLog", expr.Constant("hello world!"))
		  result= resolver.Resolve(expr)
		  Assert.IsNil result, "IsNil result"
		  
		  expr= expr.CallExpr(Nil, GetTypeInfo(EXS.System), "Random")
		  result= resolver.Resolve(expr)
		  Assert.IsTrue result IsA Random, "IsTrue result IsA Random"
		  
		  expr= expr.CallExpr(Nil, GetTypeInfo(EXS.System), "GetEnvironment", expr.Constant("HOMEPATH"))
		  result= resolver.Resolve(expr)
		  Assert.IsTrue result.StringValue.Len> 0, "IsTrue result.StringValue.Len> 0"
		  
		  expr= expr.Convert(expr.Constant(40), EXS.GetType("String"))
		  result= resolver.Resolve(expr)
		  Assert.AreSame "40", result.StringValue, "AreSame ""40"", result.StringValue"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WhileTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim paramI As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "i")
		  Dim paramN As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "n")
		  
		  Dim exprs() As EXS.Expressions.Expression
		  exprs.Append expr.CallExpr(Nil, GetTypeInfo(EXS.System), "DebugLog", paramI)
		  exprs.Append expr.Assign(paramI, expr.Add(paramI, expr.Constant(1)))
		  
		  expr= expr.Lambda(expr.Block(expr.While_(_
		  expr.LessThan(paramI, paramN), New EXS.Expressions.BlockExpression(exprs)), paramI)_
		  , paramI, paramN)
		  
		  Dim resolver As New EXS.Misc.Resolver(1, 10)
		  Dim result As Variant= resolver.Resolve(expr)
		  Assert.AreEqual 10, result.IntegerValue, "AreEqual 10, result.IntegerValue"
		  
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Group="Behavior"
			Type="Double"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsRunning"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="TestGroup"
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
			Name="NotImplementedCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StopTestOnFail"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TestCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
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
