#tag Class
Protected Class PrinterTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub AssignTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("String"), "s1")
		  
		  Dim exprs() As EXS.Expressions.Expression
		  exprs.Append expr.CallExpr(Nil, GetTypeInfo(EXS.System), "DebugLog", paramExpr)
		  exprs.Append expr.Assign(paramExpr, expr.Constant("world"))
		  exprs.Append expr.CallExpr(Nil, GetTypeInfo(EXS.System), "DebugLog", paramExpr)
		  
		  expr= expr.Lambda(New EXS.Expressions.BlockExpression(exprs), paramExpr)
		  
		  Dim printer As New EXS.Misc.Printer
		  Dim actual As String= printer.Print(expr)
		  Assert.AreSame kAssign, actual, "AreSame kAssign, actual"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BlockTest()
		  Dim expr As EXS.Expressions.Expression
		  expr= expr.Block(_
		  expr.CallExpr(Nil, GetTypeInfo(EXS.System), "DebugLog", expr.Constant("1 + 2 * 3")),_
		  expr.Add(expr.Constant(1), expr.Multiply(expr.Constant(2), expr.Constant(3)))_
		  )
		  
		  Dim printer As New EXS.Misc.Printer
		  Dim actual As String= printer.Print(expr)
		  Assert.AreSame "{System.DebugLog(""1 + 2 * 3""); ( + ,1,( * ,2,3))}", _
		  actual, "AreSame ""{System.DebugLog(""1 + 2 * 3""); ( + ,1,( * ,2,3))}"", actual"
		  
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
		  
		  Dim printer As New EXS.Misc.Printer
		  Dim actual As String= printer.Print(expr)
		  Assert.AreSame "( iif ,True,""num > 10"",""num < 10"")", _
		  actual, "AreSame ""( iif ,True,""num > 10"",""num < 10"")"", actual"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LambdaTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  expr= expr.Lambda(expr.Add(paramExpr, expr.Constant(5)), paramExpr)
		  
		  Dim printer As New EXS.Misc.Printer
		  Dim actual As String= printer.Print(expr)
		  Assert.AreSame "(a) => ( + ,a,5)", actual, "AreSame ""(a) => ( + ,a,5)"", actual"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OperTest()
		  Dim expr As EXS.Expressions.Expression
		  expr= expr.Add(expr.Constant(1), expr.Multiply(expr.Constant(2), expr.Constant(2)))
		  
		  Dim printer As New EXS.Misc.Printer
		  Dim actual As String= printer.Print(expr)
		  Assert.AreSame "( + ,1,( * ,2,2))", actual, "AreSame ""( + ,1,( * ,2,2))"", actual"
		  
		  expr= expr.And_(expr.Constant(True), expr.Constant(True))
		  actual= printer.Print(expr)
		  Assert.AreSame "( & ,True,True)", actual, "AreSame ""( & ,True,True)"", actual"
		  
		  expr= expr.LeftShift(expr.Constant(&b00011111), expr.Constant(2))
		  actual= printer.Print(expr)
		  Assert.AreSame "( << ,31,2)", actual, "AreSame ""( << ,31,2)"", actual"
		  
		  Dim o1 As New ObjectWithBinaryExprMethod(10)
		  Dim o2 As New ObjectWithBinaryExprMethod(20)
		  'Dim o3 As ObjectWithBinaryExprMethod= o1+ o2
		  Dim methodAdd As Introspection.MethodInfo= Introspection.GetType(o1).GetMethodInfo("Operator_Add")
		  expr= expr.Add(expr.Constant(o1), expr.Constant(o2), methodAdd)
		  actual= printer.Print(expr)
		  Assert.AreSame "(Operator_Add,10,20)", actual, "AreSame ""(Operator_Add,10,20)"", actual"
		  
		  expr= expr.Subtract(expr.Constant(o1), expr.Constant(o2), Introspection.GetType(o1).GetMethodInfo("Operator_Subtract"))
		  actual= printer.Print(expr)
		  Assert.AreSame "(Operator_Subtract,10,20)", actual, "AreSame ""(Operator_Subtract,10,20)"", actual"
		  
		  expr= expr.CallExpr(Nil, GetTypeInfo(EXS.System), "DebugLog", expr.Constant("hello world!"))
		  actual= printer.Print(expr)
		  Assert.AreSame "System.DebugLog(""hello world!"")", actual, "AreSame ""System.DebugLog(""hello world!"")"", actual"
		  
		  expr= expr.CallExpr(Nil, GetTypeInfo(EXS.System), "Random")
		  actual= printer.Print(expr)
		  Assert.AreSame "System.Random", actual, "AreSame ""System.Random"", actual"
		  
		  expr= expr.CallExpr(Nil, GetTypeInfo(EXS.System), "GetEnvironment", expr.Constant("HOMEPATH"))
		  actual= printer.Print(expr)
		  Assert.AreSame "System.GetEnvironment(""HOMEPATH"")", actual, "AreSame ""System.GetEnvironment(""HOMEPATH"")"", actual"
		  
		  expr= expr.Convert(expr.Constant(40), EXS.GetType("String"))
		  actual= printer.Print(expr)
		  Assert.AreSame "(40 -> String)", actual, "AreSame ""(40 -> String)"", actual"
		  
		  expr= expr.Parameter(EXS.GetType("Integer"), "a")
		  actual= printer.Print(expr)
		  Assert.AreSame "a", actual, "AreSame ""a"", actual"
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  expr= expr.Lambda(expr.Add(paramExpr, expr.Constant(5)), paramExpr)
		  actual= printer.Print(expr)
		  Assert.AreSame "(a) => ( + ,a,5)", actual, "AreSame ""(a) => ( + ,a,5)"", actual"
		  
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
		  expr.LessThan(paramI, paramN), New EXS.Expressions.BlockExpression(exprs)), expr.Constant(42))_
		  , paramI, paramN)
		  
		  Dim printer As New EXS.Misc.Printer
		  Dim actual As String= printer.Print(expr)
		  Assert.AreSame kWhile, actual, "AreSame kWhile, actual"
		  
		End Sub
	#tag EndMethod


	#tag Constant, Name = kAssign, Type = String, Dynamic = False, Default = \"(s1) \x3D> {System.DebugLog(s1); ( \x3D \x2Cs1\x2C\"world\"); System.DebugLog(s1)}", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kWhile, Type = String, Dynamic = False, Default = \"(i\x2C n) \x3D> {( while \x2C( < \x2Ci\x2Cn)\x2C{System.DebugLog(i); ( \x3D \x2Ci\x2C( + \x2Ci\x2C1))}); 42}", Scope = Private
	#tag EndConstant


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
