#tag Class
Protected Class ExpressionsTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub AddTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim addExpr As EXS.Expressions.BinaryExpression= expr.Add(expr.Constant(1), expr.Constant(2))
		  Assert.IsNotNil addExpr, "IsNotNil addExpr"
		  Assert.IsTrue (addExpr.NodeType= EXS.ExpressionType.Add), _
		  "IsTrue (addExpr.NodeType= EXS.ExpressionType.Add)"
		  
		  Dim actual As Variant= EXS.Expressions.ConstantExpression(addExpr.Left).Value
		  Assert.AreEqual 1, actual.IntegerValue, "AreEqual 1, actual.IntegerValue"
		  
		  actual= EXS.Expressions.ConstantExpression(addExpr.Right).Value
		  Assert.AreEqual 2, actual.IntegerValue, "AreEqual 2, actual.IntegerValue"
		  Assert.AreSame "1 + 2", addExpr.ToString, "AreSame ""1 + 2"", addExpr.ToString"
		  
		  Dim o1 As New ObjectWithBinaryExprMethod(10)
		  Dim o2 As New ObjectWithBinaryExprMethod(20)
		  Dim o3 As ObjectWithBinaryExprMethod= o1+ o2
		  Dim methodAdd As Introspection.MethodInfo= Introspection.GetType(o1).GetMethodInfo("Operator_Add")
		  
		  addExpr= expr.Add(expr.Constant(o1), expr.Constant(o2), methodAdd)
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(addExpr.Left).Value Is o1), _
		  "IsTrue (EXS.Expressions.ConstantExpression(addExpr.Left).Value Is o1)"
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(addExpr.Right).Value Is o2), _
		  "IsTrue (EXS.Expressions.ConstantExpression(addExpr.Right).Value Is o2)"
		  
		  Dim testExprT As EXS.Expressions.MethodBinaryExpression= EXS.Expressions.MethodBinaryExpression(addExpr)
		  Assert.IsTrue (testExprT.Method Is methodAdd), "IsTrue (testExprT.Method Is methodAdd)"
		  Assert.AreSame "10 + 20", addExpr.ToString, "AreSame ""10 + 20"", addExpr.ToString"
		  
		  Dim params() As Variant
		  params.Append o2
		  Dim o4 As ObjectWithBinaryExprMethod= methodAdd.Invoke(o1, params)
		  Assert.AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue, _
		  "AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Add_CompileTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.Add(paramExpr, expr.Constant(1)), _
		  paramExpr)
		  Dim str1 As String= lambdaExpr.ToString
		  Assert.AreSame "a => a + 1", str1, "AreSame ""a => a + 1"", str1"
		  
		  Dim params() As Variant
		  params.Append 1
		  Dim result As Variant= lambdaExpr.Compile.Invoke(params)
		  Assert.AreEqual 2, result.IntegerValue, "AreEqual 2, result.IntegerValue"
		  
		  paramExpr= expr.Parameter(EXS.GetType("String"), "a")
		  lambdaExpr= expr.Lambda(_
		  expr.Add(paramExpr, expr.Constant(" world")), _
		  paramExpr)
		  
		  str1= lambdaExpr.ToString
		  Assert.AreSame "a => a + "" world""", str1, "AreSame ""a => a + "" world"""", str1"
		  
		  ReDim params(-1)
		  params.Append "Hello"
		  result= lambdaExpr.Compile.Invoke(params)
		  Assert.AreEqual "Hello world", result.StringValue, "AreEqual ""Hello world"", result.StringValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AndTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim testExpr As EXS.Expressions.BinaryExpression= expr.And_(expr.Constant(True), expr.Constant(True))
		  Assert.IsNotNil testExpr, "IsNotNil testExpr"
		  Assert.IsTrue (testExpr.NodeType= EXS.ExpressionType.And_), _
		  "IsTrue (testExpr.NodeType= EXS.ExpressionType.And_)"
		  
		  Dim actual As Variant= EXS.Expressions.ConstantExpression(testExpr.Left).Value
		  Assert.IsTrue actual.BooleanValue, "IsTrue actual.BooleanValue"
		  
		  actual= EXS.Expressions.ConstantExpression(testExpr.Right).Value
		  Assert.IsTrue actual.BooleanValue, "IsTrue actual.BooleanValue"
		  Assert.AreSame "True & True", testExpr.ToString, "AreSame ""True & True"", testExpr.ToString"
		  
		  Dim o1 As New ObjectWithBinaryExprMethod(True)
		  Dim o2 As New ObjectWithBinaryExprMethod(False)
		  Dim o3 As ObjectWithBinaryExprMethod= o1 And o2
		  Dim method As Introspection.MethodInfo= Introspection.GetType(o1).GetMethodInfo("Operator_And")
		  
		  testExpr= expr.And_(expr.Constant(o1), expr.Constant(o2), method)
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(testExpr.Left).Value Is o1), _
		  "IsTrue (EXS.Expressions.ConstantExpression(testExpr.Left).Value Is o1)"
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(testExpr.Right).Value Is o2), _
		  "IsTrue (EXS.Expressions.ConstantExpression(testExpr.Right).Value Is o2)"
		  
		  Dim testExprT As EXS.Expressions.MethodBinaryExpression= EXS.Expressions.MethodBinaryExpression(testExpr)
		  Assert.IsTrue (testExprT.Method Is method), "IsTrue (testExprT.Method Is method)"
		  Assert.AreSame "True & False", testExpr.ToString, "AreSame ""True & False"", testExpr.ToString"
		  
		  Dim params() As Variant
		  params.Append o2
		  Dim o4 As ObjectWithBinaryExprMethod= method.Invoke(o1, params)
		  Assert.AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue, _
		  "AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue"
		  
		  o1= New ObjectWithBinaryExprMethod(85)
		  o2= New ObjectWithBinaryExprMethod(170)
		  o3= o1 And o2
		  
		  method= Introspection.GetType(o1).GetMethodInfo("Operator_And")
		  
		  testExpr= expr.And_(expr.Constant(o1), expr.Constant(o2), method)
		  o4= method.Invoke(o1, params)
		  Assert.AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue, _
		  "AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub And_CompileTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Boolean"), "a")
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.And_(paramExpr, expr.Constant(True)), _
		  paramExpr)
		  Dim str1 As String= lambdaExpr.ToString
		  Assert.AreSame "a => a & True", str1, "AreSame ""a => a & True"", str1"
		  
		  Dim params() As Variant
		  params.Append True
		  Dim result As Variant= lambdaExpr.Compile.Invoke(params)
		  Assert.IsTrue result.BooleanValue, "IsTrue result.BooleanValue"
		  
		  params(0)= False
		  result= lambdaExpr.Compile.Invoke(params)
		  Assert.IsFalse result.BooleanValue, "IsFalse result.BooleanValue"
		  
		  paramExpr= expr.Parameter(EXS.GetType("Integer"), "a")
		  lambdaExpr= expr.Lambda(_
		  expr.And_(paramExpr, expr.Constant(85)), _
		  paramExpr)
		  str1= lambdaExpr.ToString
		  Assert.AreSame "a => a & 85", str1, "AreSame ""a => a & 85"", str1"
		  
		  params(0)= 170
		  result= lambdaExpr.Compile.Invoke(params)
		  Assert.AreEqual 0, result.IntegerValue, "AreEqual 0, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AssignTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim testParam As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("String"), "s1")
		  
		  Dim testExpr As EXS.Expressions.BinaryExpression= expr.Assign(testParam, expr.Constant("Hello"))
		  Assert.IsNotNil testExpr, "IsNotNil testExpr"
		  Assert.IsTrue (testExpr.NodeType= EXS.ExpressionType.Assign), _
		  "IsTrue (testExpr.NodeType= EXS.ExpressionType.Assign)"
		  Assert.IsTrue testExpr.Left Is testParam, "IsTrue testExpr.Left Is testParam"
		  
		  Dim actual As Variant= EXS.Expressions.ConstantExpression(testExpr.Right).Value
		  Assert.AreSame "Hello", actual.StringValue, "AreSame ""Hello"", actual.StringValue"
		  Assert.AreSame "s1 = ""Hello""", testExpr.ToString, "AreSame ""s1 = ""Hello"""", testExpr.ToString"
		  
		  testParam= expr.Parameter(EXS.GetType("Integer"), "i32")
		  testExpr= expr.Assign(testParam, expr.Constant(10))
		  
		  Assert.IsTrue testExpr.Left Is testParam, "IsTrue testExpr.Left Is testParam"
		  actual= EXS.Expressions.ConstantExpression(testExpr.Right).Value
		  Assert.AreEqual 10, actual.IntegerValue, "AreSame 10, actual.IntegerValue"
		  Assert.AreSame "i32 = 10", testExpr.ToString, "AreSame ""i32 = 10"", testExpr.ToString"
		  
		  Try
		    #pragma BreakOnExceptions Off
		    testExpr= expr.Assign(testParam, expr.Constant("wrong"))
		    #pragma BreakOnExceptions Default
		  Catch exc As RuntimeException
		    Assert.Pass "exc handled: "+ exc.Message
		    Return
		  End Try
		  Assert.Fail "we should never get here!"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Assign_CompileTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim p1 As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("String"), "s1")
		  Dim assignExpr1 As EXS.Expressions.BinaryExpression= expr.Assign(p1, expr.Constant("hello"))
		  
		  Dim blockExpr As EXS.Expressions.Expression= expr.Block(assignExpr1, p1)
		  Dim result As Variant= expr.Lambda(blockExpr).Compile.Invoke(Nil)
		  
		  Assert.AreSame "hello", result.StringValue, "AreSame ""hello"", result.StringValue"
		  
		  Dim p2 As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("String"), "s2")
		  Dim assignExpr2 As EXS.Expressions.BinaryExpression= expr.Assign(p2, p1)
		  
		  blockExpr= expr.Block(assignExpr1, assignExpr2, p2)
		  result= expr.Lambda(blockExpr).Compile.Invoke(Nil)
		  
		  Assert.AreSame "hello", result.StringValue, "AreSame ""hello"", result.StringValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BlockTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim blockExpr As EXS.Expressions.BlockExpression= expr.Block(_
		  expr.Add(expr.Constant(4), expr.Constant(2)), _
		  expr.Constant(42))
		  Dim str1 As String= "{4 + 2"+ EndOfLine.UNIX+ "42}"
		  Dim str2 As String= ReplaceLineEndings(blockExpr.ToString, EndOfLine.UNIX)
		  Assert.AreSame str1, str2, "AreSame str1, str2"
		  
		  blockExpr= expr.Block(_
		  expr.CallExpr(Nil, GetTypeInfo(EXS.System), "DebugLog", expr.Constant("hello")), _
		  expr.CallExpr(Nil, GetTypeInfo(EXS.System), "DebugLog", expr.Constant("World!")), _
		  expr.Constant(42))
		  Assert.IsNotNil blockExpr, "IsNotNil blockExpr"
		  
		  Dim ti As Introspection.TypeInfo= blockExpr.Type
		  Assert.AreEqual "Int32", ti.Name, "AreEqual ""Int32"", ti.Name"
		  
		  Dim exprs() As EXS.Expressions.Expression= blockExpr.Expressions
		  Assert.AreEqual 2, exprs.LastIdx, "AreEqual 2, exprs.LastIdx"
		  
		  str1= "{System.DebugLog(""hello"")"+ EndOfLine.Unix+ "System.DebugLog(""World!"")"+ _
		  EndOfLine.Unix+ "42}"
		  str2= ReplaceLineEndings(blockExpr.ToString, EndOfLine.UNIX)
		  Assert.AreSame str1, str2, "AreSame str1, str2"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CompileLoading(majorVersion As UInt8, minorVersion As UInt16, flags As UInt64) As Boolean
		  Assert.Message "Return True do not load the bin file, .Loaded is False"
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CompileSaveLoadTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim blockExpr As EXS.Expressions.BlockExpression= expr.Block(_
		  expr.CallExpr(Nil, GetTypeInfo(EXS.System), "DebugLog", expr.Constant("hello")), _
		  expr.CallExpr(Nil, GetTypeInfo(EXS.System), "DebugLog", expr.Constant("World!")), _
		  expr.Constant(42))
		  Dim result As Variant= expr.Lambda(blockExpr).Compile.Invoke(Nil)
		  Assert.AreEqual 42, result.IntegerValue, "AreEqual 42, result.IntegerValue"
		  
		  Dim binfile As FolderItem= GetTemporaryFolderItem //SpecialFolder.Documents.Child("Expressions.bin")
		  Dim lambdaCompiler As New EXS.Expressions.LambdaCompiler(expr.Lambda(blockExpr))
		  lambdaCompiler.EmitLambdaBody
		  lambdaCompiler.Save binfile
		  Assert.IsTrue binfile.Exists, "IsTrue binfile.Exists"
		  
		  result= Nil
		  lambdaCompiler= New EXS.Expressions.LambdaCompiler(binfile)
		  result= lambdaCompiler.Run(Nil)
		  Assert.AreEqual 42, result.IntegerValue, "AreEqual 42, result.IntegerValue"
		  
		  lambdaCompiler= New EXS.Expressions.LambdaCompiler(binfile, WeakAddressOf CompileLoading)
		  Assert.IsFalse lambdaCompiler.Loaded, "IsFalse lambdaCompiler.Loaded"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConditionalTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim num As Integer= 100
		  
		  Dim conditionExpr As EXS.Expressions.ConditionalExpression= expr.Condition(_
		  expr.Constant(num> 10), _
		  expr.Constant("num > 10"), _
		  expr.Constant("num < 10") _
		  )
		  Assert.IsNotNil conditionExpr, "IsNotNil conditionExpr"
		  
		  Dim ti As Introspection.TypeInfo= conditionExpr.Type
		  Assert.IsTrue ti= EXS.GetType("String"), "IsTrue ti= EXS.GetType(""String"")"
		  
		  ti= conditionExpr.Test.Type
		  Assert.IsTrue ti= EXS.GetType("Boolean"), "IsTrue ti= EXS.GetType(""Boolean"")"
		  
		  ti= conditionExpr.IfTrue.Type
		  Assert.IsTrue ti= EXS.GetType("String"), "IsTrue ti= EXS.GetType(""String"")"
		  
		  ti= conditionExpr.IfFalse.Type
		  Assert.IsTrue ti= EXS.GetType("String"), "IsTrue ti= EXS.GetType(""String"")"
		  
		  Dim value As Variant= EXS.Expressions.ConstantExpression(conditionExpr.Test).Value
		  Assert.IsTrue value.BooleanValue, "IsTrue value.BooleanValue"
		  
		  value= EXS.Expressions.ConstantExpression(conditionExpr.IfTrue).Value
		  Assert.AreSame "num > 10", value.StringValue, "AreSame ""num > 10"", value.StringValue"
		  
		  value= EXS.Expressions.ConstantExpression(conditionExpr.IfFalse).Value
		  Assert.AreSame "num < 10", value.StringValue, "AreSame ""num < 10"", value.StringValue"
		  
		  Dim actual As String= conditionExpr.ToString
		  'Assert.AreSame "IF(True, ""num > 10"", ""num < 10"")", actual, _
		  '"AreSame ""IIF(True, ""num > 10"", ""num < 10"")"", actual"
		  Assert.AreSame "True ? ""num > 10"" : ""num < 10""", actual, _
		  "AreSame ""True ? ""num > 10"" : ""num < 10"""", actual"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Conditional_CompileTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Boolean"), "a")
		  Dim conditionExpr As EXS.Expressions.ConditionalExpression= expr.Condition(_
		  paramExpr, _
		  expr.Constant("true"), _
		  expr.Constant("false") _
		  )
		  Dim str1 As String= conditionExpr.ToString
		  Assert.AreSame "a ? ""true"" : ""false""", str1, "AreSame ""a ? ""true"" : ""false"""", str1"
		  
		  Dim params() As Variant
		  params.Append False
		  Dim result As Variant= expr.Lambda(conditionExpr, paramExpr).Compile.Invoke(params)
		  Assert.AreSame "false", result.StringValue, "AreSame ""false"", result.StringValue"
		  
		  params(0)= True
		  result= expr.Lambda(conditionExpr, paramExpr).Compile.Invoke(params)
		  Assert.AreSame "true", result.StringValue, "AreSame ""true"", result.StringValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConstantTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim constExpr As EXS.Expressions.ConstantExpression= expr.Constant(1)
		  Assert.IsNotNil constExpr, "IsNotNil constExpr"
		  
		  Dim ti As Introspection.TypeInfo= constExpr.Type
		  Assert.AreEqual "Int32", ti.Name, "AreEqual ""Int32"", ti.Name"
		  
		  Dim value As Variant= constExpr.Value
		  Assert.AreEqual 1, value.IntegerValue, "AreEqual 1, value.IntegerValue"
		  Assert.AreSame "1", constExpr.ToString, "AreSame ""1"", constExpr.ToString"
		  
		  constExpr= expr.Constant(1.1)
		  ti= constExpr.Type
		  Assert.AreEqual "Double", ti.Name, "AreEqual ""Double"", ti.Name"
		  
		  value= constExpr.Value
		  Assert.AreEqual 1.1, value.DoubleValue, "AreEqual 1.1, value.DoubleValue"
		  Assert.AreSame "1.1", constExpr.ToString, "AreSame ""1.1"", constExpr.ToString"
		  
		  constExpr= expr.Constant("hallo")
		  ti= constExpr.Type
		  Assert.AreEqual "String", ti.Name, "AreEqual ""String"", ti.Name"
		  
		  value= constExpr.Value
		  Assert.AreEqual "hallo", value.StringValue, "AreEqual ""hallo"", value.StringValue"
		  Assert.AreSame """hallo""", constExpr.ToString, "AreSame """"hallo"""", constExpr.ToString"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constant_CompileTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim blockExpr As EXS.Expressions.BlockExpression= expr.Block(_
		  expr.Constant(42))
		  Dim str1 As String= blockExpr.ToString
		  Assert.AreSame "{42}", str1, "AreSame ""{42}"", str1"
		  
		  Dim result As Variant= expr.Lambda(blockExpr).Compile.Invoke(Nil)
		  Assert.AreEqual 42, result.IntegerValue, "AreEqual 42, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConvertTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim typeAsExpr As EXS.Expressions.UnaryExpression= expr.Convert(_
		  expr.Constant("10"), _
		  EXS.GetType("Integer"))
		  Assert.IsNotNil typeAsExpr, "IsNotNil typeAsExpr"
		  Assert.IsTrue (typeAsExpr.NodeType= EXS.ExpressionType.Convert), _
		  "IsTrue (typeAsExpr.NodeType= EXS.ExpressionType.Convert)"
		  
		  Dim ti As Introspection.TypeInfo= typeAsExpr.Type
		  Assert.AreEqual "Int32", ti.Name, "AreEqual ""Int32"", ti.Name"
		  
		  Dim value As Variant= EXS.Expressions.ConstantExpression(typeAsExpr.Operand).Value
		  Assert.AreEqual "10", value.StringValue, "AreEqual ""10"", value.StringValue"
		  
		  Assert.AreSame "(""10"" -> Int32)", typeAsExpr.ToString, "AreSame ""(""10"" -> Int32)"", typeAsExpr.ToString"
		  
		  typeAsExpr= expr.Convert(_
		  expr.Constant(10), _
		  EXS.GetType("String"))
		  ti= typeAsExpr.Type
		  Assert.AreEqual "String", ti.Name, "AreEqual ""String"", ti.Name"
		  Assert.AreSame "(10 -> String)", typeAsExpr.ToString, "AreSame ""(10 -> String)"", typeAsExpr.ToString"
		  
		  typeAsExpr= expr.Convert(_
		  expr.Constant("10"), _
		  EXS.GetType("String"))
		  ti= typeAsExpr.Type
		  Assert.AreEqual "String", ti.Name, "AreEqual ""String"", ti.Name"
		  Assert.AreSame "(""10"" -> String)", typeAsExpr.ToString, "AreSame ""(""10"" -> String)"", typeAsExpr.ToString"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Convert_CompileTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim blockExpr As EXS.Expressions.BlockExpression= expr.Block(_
		  expr.Convert(expr.Constant(10), EXS.GetType("String")))
		  Dim str1 As String= blockExpr.ToString
		  Assert.AreSame "{(10 -> String)}", str1, "AreSame ""{(10 -> String)}"", str1"
		  
		  Dim result As Variant= expr.Lambda(blockExpr).Compile.Invoke(Nil)
		  'Assert.AreEqual Variant.TypeString, result.Type, "AreEqual Variant.TypeString, result.Type"
		  Assert.AreEqual "10", result.StringValue, "AreEqual ""10"", result.StringValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DivideTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim testExpr As EXS.Expressions.BinaryExpression= expr.Divide(expr.Constant(2), expr.Constant(2))
		  Assert.IsNotNil testExpr, "IsNotNil testExpr"
		  Assert.IsTrue (testExpr.NodeType= EXS.ExpressionType.Divide), _
		  "IsTrue (testExpr.NodeType= EXS.ExpressionType.Divide)"
		  
		  Dim actual As Variant= EXS.Expressions.ConstantExpression(testExpr.Left).Value
		  Assert.AreEqual 2, actual.IntegerValue, "AreEqual 2, actual.IntegerValue"
		  
		  actual= EXS.Expressions.ConstantExpression(testExpr.Right).Value
		  Assert.AreEqual 2, actual.IntegerValue, "AreEqual 2, actual.IntegerValue"
		  Assert.AreSame "2 / 2", testExpr.ToString, "AreSame ""2 / 2"", addExpr.ToString"
		  
		  Dim o1 As New ObjectWithBinaryExprMethod(10)
		  Dim o2 As New ObjectWithBinaryExprMethod(2)
		  Dim o3 As ObjectWithBinaryExprMethod= o1/ o2
		  Dim method As Introspection.MethodInfo= Introspection.GetType(o1).GetMethodInfo("Operator_Divide")
		  
		  testExpr= expr.Divide(expr.Constant(o1), expr.Constant(o2), method)
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(testExpr.Left).Value Is o1), _
		  "IsTrue (EXS.Expressions.ConstantExpression(testExpr.Left).Value Is o1)"
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(testExpr.Right).Value Is o2), _
		  "IsTrue (EXS.Expressions.ConstantExpression(testExpr.Right).Value Is o2)"
		  
		  Dim testExprT As EXS.Expressions.MethodBinaryExpression= EXS.Expressions.MethodBinaryExpression(testExpr)
		  Assert.IsTrue (testExprT.Method Is method), "IsTrue (testExprT.Method Is method)"
		  Assert.AreSame "10 / 2", testExpr.ToString, "AreSame ""10 / 2"", testExpr.ToString"
		  
		  Dim params() As Variant
		  params.Append o2
		  Dim o4 As ObjectWithBinaryExprMethod= method.Invoke(o1, params)
		  Assert.AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue, _
		  "AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Divide_CompileTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.Divide(paramExpr, expr.Constant(2)), _
		  paramExpr)
		  Dim str1 As String= lambdaExpr.ToString
		  Assert.AreSame "a => a / 2", str1, "AreSame ""a => a / 2"", str1"
		  
		  Dim params() As Variant
		  params.Append 2
		  Dim result As Variant= lambdaExpr.Compile.Invoke(params)
		  Assert.AreEqual 1, result.IntegerValue, "AreEqual 1, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LambdaTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "arg")
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.Add(paramExpr, expr.Constant(1)), _
		  paramExpr)
		  Assert.IsNotNil lambdaExpr, "IsNotNil lambdaExpr"
		  
		  Dim actual As String= lambdaExpr.ToString
		  Assert.AreSame "arg => arg + 1", actual, "AreSame ""arg => arg + 1"", actual"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LeftShiftTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim testExpr As EXS.Expressions.BinaryExpression= expr.LeftShift(expr.Constant(15), expr.Constant(1))
		  Assert.IsNotNil testExpr, "IsNotNil testExpr"
		  Assert.IsTrue (testExpr.NodeType= EXS.ExpressionType.LeftShift), _
		  "IsTrue (testExpr.NodeType= EXS.ExpressionType.LeftShift)"
		  
		  Dim actual As Variant= EXS.Expressions.ConstantExpression(testExpr.Left).Value
		  Assert.AreEqual 15, actual.IntegerValue, "AreEqual 15, actual.IntegerValue"
		  
		  actual= EXS.Expressions.ConstantExpression(testExpr.Right).Value
		  Assert.AreEqual 1, actual.IntegerValue, "AreEqual 1, actual.IntegerValue"
		  Assert.AreSame "15 << 1", testExpr.ToString, "AreSame ""15 << 1"", testExpr.ToString"
		  
		  Dim o1 As New ObjectWithBinaryExprMethod(15)
		  Dim o2 As Integer= 2
		  Dim o3 As ObjectWithBinaryExprMethod= o1.LeftShift(o2)
		  Dim method As Introspection.MethodInfo= Introspection.GetType(o1).GetMethodInfo("LeftShift")
		  
		  testExpr= expr.LeftShift(expr.Constant(o1), expr.Constant(o2), method)
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(testExpr.Left).Value Is o1), _
		  "IsTrue (EXS.Expressions.ConstantExpression(testExpr.Left).Value Is o1)"
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(testExpr.Right).Value= o2), _
		  "IsTrue (EXS.Expressions.ConstantExpression(testExpr.Right).Value= o2)"
		  
		  Dim testExprT As EXS.Expressions.MethodBinaryExpression= EXS.Expressions.MethodBinaryExpression(testExpr)
		  Assert.IsTrue (testExprT.Method Is method), "IsTrue (testExprT.Method Is method)"
		  Assert.AreSame "15 << 2", testExpr.ToString, "AreSame ""15 << 2"", testExpr.ToString"
		  
		  Dim params() As Variant
		  params.Append o2
		  Dim o4 As ObjectWithBinaryExprMethod= method.Invoke(o1, params)
		  Assert.AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue, _
		  "AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LeftShift_CompileTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.LeftShift(paramExpr, expr.Constant(2)), _
		  paramExpr)
		  Dim str1 As String= lambdaExpr.ToString
		  Assert.AreSame "a => a << 2", str1, "AreSame ""a => a << 2"", str1"
		  
		  Dim params() As Variant
		  params.Append &b00011111
		  Dim result As Variant= lambdaExpr.Compile.Invoke(params)
		  Assert.AreEqual 124, result.IntegerValue, "AreEqual 124, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MethodCallTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim mc As EXS.Expressions.MethodCallExpression= expr.CallExpr(GetTypeInfo(EXS.System), "Log", "Integer": 1, "String": "Hello")
		  Assert.IsNotNil mc, "IsNotNil mc"
		  
		  Dim ti As Introspection.TypeInfo= mc.Type
		  Assert.AreEqual "System", ti.Name, "AreEqual ""System"", ti.Name"
		  
		  Dim methodInfo As Introspection.MethodInfo= mc.Method
		  Assert.AreEqual "Log", methodInfo.Name, "AreEqual ""Log"", methodInfo.Name"
		  
		  Dim args() As EXS.Expressions.Expression= mc.Arguments
		  Assert.AreEqual 1, args.LastIdx, "AreEqual 1, args.LastIdx"
		  
		  Dim expect As String= "System.Log(1,""Hello"")"
		  Dim actual As String= mc.ToString
		  Assert.AreSame expect, actual, "AreSame expect, actual"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MethodCall_CompileTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim blockExpr As EXS.Expressions.BlockExpression= expr.Block(_
		  expr.CallExpr(Nil, GetTypeInfo(EXS.System), "DebugLog", expr.Constant("hello world!")), _
		  expr.Constant(42))
		  Dim str1 As String= "{System.DebugLog(""hello world!"")"+ EndOfLine.UNIX+ "42}"
		  Dim str2 As String= ReplaceLineEndings(blockExpr.ToString, EndOfLine.UNIX)
		  Assert.AreSame str1, str2, "AreSame str1, str2"
		  
		  Dim result As Variant= expr.Lambda(blockExpr).Compile.Invoke(Nil)
		  Assert.AreEqual 42, result.IntegerValue, "AreEqual 42, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ModuloTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim testExpr As EXS.Expressions.BinaryExpression= expr.Modulo(expr.Constant(12), expr.Constant(5))
		  Assert.IsNotNil testExpr, "IsNotNil testExpr"
		  Assert.IsTrue (testExpr.NodeType= EXS.ExpressionType.Modulo), _
		  "IsTrue (testExpr.NodeType= EXS.ExpressionType.Modulo)"
		  
		  Dim actual As Variant= EXS.Expressions.ConstantExpression(testExpr.Left).Value
		  Assert.AreEqual 12, actual.IntegerValue, "AreEqual 12, actual.IntegerValue"
		  
		  actual= EXS.Expressions.ConstantExpression(testExpr.Right).Value
		  Assert.AreEqual 5, actual.IntegerValue, "AreEqual 5, actual.IntegerValue"
		  Assert.AreSame "12 % 5", testExpr.ToString, "AreSame ""12 % 5"", addExpr.ToString"
		  
		  Dim o1 As New ObjectWithBinaryExprMethod(100)
		  Dim o2 As New ObjectWithBinaryExprMethod(15)
		  Dim o3 As ObjectWithBinaryExprMethod= o1 Mod o2
		  Dim method As Introspection.MethodInfo= Introspection.GetType(o1).GetMethodInfo("Operator_Modulo")
		  
		  testExpr= expr.Modulo(expr.Constant(o1), expr.Constant(o2), method)
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(testExpr.Left).Value Is o1), _
		  "IsTrue (EXS.Expressions.ConstantExpression(testExpr.Left).Value Is o1)"
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(testExpr.Right).Value Is o2), _
		  "IsTrue (EXS.Expressions.ConstantExpression(testExpr.Right).Value Is o2)"
		  
		  Dim testExprT As EXS.Expressions.MethodBinaryExpression= EXS.Expressions.MethodBinaryExpression(testExpr)
		  Assert.IsTrue (testExprT.Method Is method), "IsTrue (testExprT.Method Is method)"
		  Assert.AreSame "100 % 15", testExpr.ToString, "AreSame ""100 % 15"", testExpr.ToString"
		  
		  Dim params() As Variant
		  params.Append o2
		  Dim o4 As ObjectWithBinaryExprMethod= method.Invoke(o1, params)
		  Assert.AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue, _
		  "AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Modulo_CompileTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.Modulo(paramExpr, expr.Constant(2)), _
		  paramExpr)
		  Dim str1 As String= lambdaExpr.ToString
		  Assert.AreSame "a => a % 2", str1, "AreSame ""a => a % 2"", str1"
		  
		  Dim params() As Variant
		  params.Append 5
		  Dim result As Variant= lambdaExpr.Compile.Invoke(params)
		  Assert.AreEqual 1, result.IntegerValue, "AreEqual 1, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MultiplyTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim testExpr As EXS.Expressions.BinaryExpression= expr.Multiply(expr.Constant(2), expr.Constant(2))
		  Assert.IsNotNil testExpr, "IsNotNil testExpr"
		  Assert.IsTrue (testExpr.NodeType= EXS.ExpressionType.Multiply), _
		  "IsTrue (testExpr.NodeType= EXS.ExpressionType.Multiply)"
		  
		  Dim actual As Variant= EXS.Expressions.ConstantExpression(testExpr.Left).Value
		  Assert.AreEqual 2, actual.IntegerValue, "AreEqual 2, actual.IntegerValue"
		  
		  actual= EXS.Expressions.ConstantExpression(testExpr.Right).Value
		  Assert.AreEqual 2, actual.IntegerValue, "AreEqual 2, actual.IntegerValue"
		  Assert.AreSame "2 * 2", testExpr.ToString, "AreSame ""2 * 2"", addExpr.ToString"
		  
		  Dim o1 As New ObjectWithBinaryExprMethod(10)
		  Dim o2 As New ObjectWithBinaryExprMethod(20)
		  Dim o3 As ObjectWithBinaryExprMethod= o1* o2
		  Dim method As Introspection.MethodInfo= Introspection.GetType(o1).GetMethodInfo("Operator_Multiply")
		  
		  testExpr= expr.Multiply(expr.Constant(o1), expr.Constant(o2), method)
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(testExpr.Left).Value Is o1), _
		  "IsTrue (EXS.Expressions.ConstantExpression(testExpr.Left).Value Is o1)"
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(testExpr.Right).Value Is o2), _
		  "IsTrue (EXS.Expressions.ConstantExpression(testExpr.Right).Value Is o2)"
		  
		  Dim testExprT As EXS.Expressions.MethodBinaryExpression= EXS.Expressions.MethodBinaryExpression(testExpr)
		  Assert.IsTrue (testExprT.Method Is method), "IsTrue (testExprT.Method Is method)"
		  Assert.AreSame "10 * 20", testExpr.ToString, "AreSame ""10 * 20"", testExpr.ToString"
		  
		  Dim params() As Variant
		  params.Append o2
		  Dim o4 As ObjectWithBinaryExprMethod= method.Invoke(o1, params)
		  Assert.AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue, _
		  "AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Multiply_CompileTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.Multiply(paramExpr, expr.Constant(2)), _
		  paramExpr)
		  Dim str1 As String= lambdaExpr.ToString
		  Assert.AreSame "a => a * 2", str1, "AreSame ""a => a * 2"", str1"
		  
		  Dim params() As Variant
		  params.Append 2
		  Dim result As Variant= lambdaExpr.Compile.Invoke(params)
		  Assert.AreEqual 4, result.IntegerValue, "AreEqual 4, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OrTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim testExpr As EXS.Expressions.BinaryExpression= expr.Or_(expr.Constant(False), expr.Constant(False))
		  Assert.IsNotNil testExpr, "IsNotNil testExpr"
		  Assert.IsTrue (testExpr.NodeType= EXS.ExpressionType.Or_), _
		  "IsTrue (testExpr.NodeType= EXS.ExpressionType.Or_)"
		  
		  Dim actual As Variant= EXS.Expressions.ConstantExpression(testExpr.Left).Value
		  Assert.IsFalse actual.BooleanValue, "IsFalse actual.BooleanValue"
		  
		  actual= EXS.Expressions.ConstantExpression(testExpr.Right).Value
		  Assert.IsFalse actual.BooleanValue, "IsFalse actual.BooleanValue"
		  Assert.AreSame "False | False", testExpr.ToString, "AreSame ""False | False"", testExpr.ToString"
		  
		  Dim o1 As New ObjectWithBinaryExprMethod(True)
		  Dim o2 As New ObjectWithBinaryExprMethod(False)
		  Dim o3 As ObjectWithBinaryExprMethod= o1 Or o2
		  Dim method As Introspection.MethodInfo= Introspection.GetType(o1).GetMethodInfo("Operator_Or")
		  
		  testExpr= expr.Or_(expr.Constant(o1), expr.Constant(o2), method)
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(testExpr.Left).Value Is o1), _
		  "IsTrue (EXS.Expressions.ConstantExpression(testExpr.Left).Value Is o1)"
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(testExpr.Right).Value Is o2), _
		  "IsTrue (EXS.Expressions.ConstantExpression(testExpr.Right).Value Is o2)"
		  
		  Dim testExprT As EXS.Expressions.MethodBinaryExpression= EXS.Expressions.MethodBinaryExpression(testExpr)
		  Assert.IsTrue (testExprT.Method Is method), "IsTrue (testExprT.Method Is method)"
		  Assert.AreSame "True | False", testExpr.ToString, "AreSame ""True | False"", testExpr.ToString"
		  
		  Dim params() As Variant
		  params.Append o2
		  Dim o4 As ObjectWithBinaryExprMethod= method.Invoke(o1, params)
		  Assert.AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue, _
		  "AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue"
		  
		  o1= New ObjectWithBinaryExprMethod(85)
		  o2= New ObjectWithBinaryExprMethod(170)
		  o3= o1 Or o2
		  
		  method= Introspection.GetType(o1).GetMethodInfo("Operator_Or")
		  
		  testExpr= expr.Or_(expr.Constant(o1), expr.Constant(o2), method)
		  
		  ReDim params(-1)
		  params.Append o2
		  o4= method.Invoke(o1, params)
		  Assert.AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue, _
		  "AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Or_CompileTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Boolean"), "a")
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.Or_(paramExpr, expr.Constant(False)), _
		  paramExpr)
		  Dim str1 As String= lambdaExpr.ToString
		  Assert.AreSame "a => a | False", str1, "AreSame ""a => a | False"", str1"
		  
		  Dim params() As Variant
		  params.Append False
		  Dim result As Variant= lambdaExpr.Compile.Invoke(params)
		  Assert.IsFalse result.BooleanValue, "IsFalse result.BooleanValue"
		  
		  params(0)= True
		  result= lambdaExpr.Compile.Invoke(params)
		  Assert.IsTrue result.BooleanValue, "IsTrue result.BooleanValue"
		  
		  paramExpr= expr.Parameter(EXS.GetType("Integer"), "a")
		  lambdaExpr= expr.Lambda(_
		  expr.Or_(paramExpr, expr.Constant(85)), _
		  paramExpr)
		  str1= lambdaExpr.ToString
		  Assert.AreSame "a => a | 85", str1, "AreSame ""a => a | 85"", str1"
		  
		  params(0)= 170
		  result= lambdaExpr.Compile.Invoke(params)
		  Assert.AreEqual 255, result.IntegerValue, "AreEqual 255, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ParameterTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "arg")
		  Assert.IsNotNil paramExpr, "IsNotNil paramExpr"
		  
		  Dim ti As Introspection.TypeInfo= paramExpr.Type
		  Assert.AreEqual "Int32", ti.Name, "AreEqual ""Int32"", ti.Name"
		  
		  Dim name As String= paramExpr.Name
		  Assert.AreSame "arg", name, "AreSame ""arg"", name"
		  
		  paramExpr= expr.Parameter(EXS.GetType("String"), "st1")
		  ti= paramExpr.Type
		  Assert.AreEqual "String", ti.Name, "AreEqual ""String"", ti.Name"
		  
		  name= paramExpr.Name
		  Assert.AreSame "st1", name, "AreSame ""st1"", name"
		  Assert.AreSame name, paramExpr.ToString, "AreSame name, paramExpr.ToString"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PowerTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim testExpr As EXS.Expressions.BinaryExpression= expr.Power(expr.Constant(2), expr.Constant(2))
		  Assert.IsNotNil testExpr, "IsNotNil testExpr"
		  Assert.IsTrue (testExpr.NodeType= EXS.ExpressionType.Power), _
		  "IsTrue (testExpr.NodeType= EXS.ExpressionType.Subtract)"
		  
		  Dim actual As Variant= EXS.Expressions.ConstantExpression(testExpr.Left).Value
		  Assert.AreEqual 2, actual.IntegerValue, "AreEqual 2, actual.IntegerValue"
		  
		  actual= EXS.Expressions.ConstantExpression(testExpr.Right).Value
		  Assert.AreEqual 2, actual.IntegerValue, "AreEqual 2, actual.IntegerValue"
		  Assert.AreSame "2 ^ 2", testExpr.ToString, "AreSame ""2 ^ 2"", addExpr.ToString"
		  
		  Dim o1 As New ObjectWithBinaryExprMethod(10)
		  Dim o2 As New ObjectWithBinaryExprMethod(3)
		  Dim o3 As ObjectWithBinaryExprMethod= o1 ^ o2
		  Dim method As Introspection.MethodInfo= Introspection.GetType(o1).GetMethodInfo("Operator_Power")
		  
		  testExpr= expr.Power(expr.Constant(o1), expr.Constant(o2), method)
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(testExpr.Left).Value Is o1), _
		  "IsTrue (EXS.Expressions.ConstantExpression(testExpr.Left).Value Is o1)"
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(testExpr.Right).Value Is o2), _
		  "IsTrue (EXS.Expressions.ConstantExpression(testExpr.Right).Value Is o2)"
		  
		  Dim testExprT As EXS.Expressions.MethodBinaryExpression= EXS.Expressions.MethodBinaryExpression(testExpr)
		  Assert.IsTrue (testExprT.Method Is method), "IsTrue (testExprT.Method Is method)"
		  Assert.AreSame "10 ^ 3", testExpr.ToString, "AreSame ""10 ^ 3"", testExpr.ToString"
		  
		  Dim params() As Variant
		  params.Append o2
		  Dim o4 As ObjectWithBinaryExprMethod= method.Invoke(o1, params)
		  Assert.AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue, _
		  "AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Power_CompileTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.Power(paramExpr, expr.Constant(2)), _
		  paramExpr)
		  Dim str1 As String= lambdaExpr.ToString
		  Assert.AreSame "a => a ^ 2", str1, "AreSame ""a => a ^ 2"", str1"
		  
		  Dim params() As Variant
		  params.Append 5
		  Dim result As Variant= lambdaExpr.Compile.Invoke(params)
		  Assert.AreEqual CType(25, Double), result.DoubleValue, "AreEqual 25, result.DoubleValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RightShiftTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim testExpr As EXS.Expressions.BinaryExpression= expr.RightShift(expr.Constant(31), expr.Constant(1))
		  Assert.IsNotNil testExpr, "IsNotNil testExpr"
		  Assert.IsTrue (testExpr.NodeType= EXS.ExpressionType.RightShift), _
		  "IsTrue (testExpr.NodeType= EXS.ExpressionType.RightShift)"
		  
		  Dim actual As Variant= EXS.Expressions.ConstantExpression(testExpr.Left).Value
		  Assert.AreEqual 31, actual.IntegerValue, "AreEqual 31, actual.IntegerValue"
		  
		  actual= EXS.Expressions.ConstantExpression(testExpr.Right).Value
		  Assert.AreEqual 1, actual.IntegerValue, "AreEqual 1, actual.IntegerValue"
		  Assert.AreSame "31 >> 1", testExpr.ToString, "AreSame ""31 >> 1"", testExpr.ToString"
		  
		  Dim o1 As New ObjectWithBinaryExprMethod(31)
		  Dim o2 As Integer= 2
		  Dim o3 As ObjectWithBinaryExprMethod= o1.RightShift(o2)
		  Dim method As Introspection.MethodInfo= Introspection.GetType(o1).GetMethodInfo("RightShift")
		  
		  testExpr= expr.RightShift(expr.Constant(o1), expr.Constant(o2), method)
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(testExpr.Left).Value Is o1), _
		  "IsTrue (EXS.Expressions.ConstantExpression(testExpr.Left).Value Is o1)"
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(testExpr.Right).Value= o2), _
		  "IsTrue (EXS.Expressions.ConstantExpression(testExpr.Right).Value= o2)"
		  
		  Dim testExprT As EXS.Expressions.MethodBinaryExpression= EXS.Expressions.MethodBinaryExpression(testExpr)
		  Assert.IsTrue (testExprT.Method Is method), "IsTrue (testExprT.Method Is method)"
		  Assert.AreSame "31 >> 2", testExpr.ToString, "AreSame ""31 >> 2"", testExpr.ToString"
		  
		  Dim params() As Variant
		  params.Append o2
		  Dim o4 As ObjectWithBinaryExprMethod= method.Invoke(o1, params)
		  Assert.AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue, _
		  "AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RightShift_CompileTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.RightShift(paramExpr, expr.Constant(2)), _
		  paramExpr)
		  Dim str1 As String= lambdaExpr.ToString
		  Assert.AreSame "a => a >> 2", str1, "AreSame ""a => a >> 2"", str1"
		  
		  Dim params() As Variant
		  params.Append &b00011111
		  Dim result As Variant= lambdaExpr.Compile.Invoke(params)
		  Assert.AreEqual 7, result.IntegerValue, "AreEqual 7, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SubscriptTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim arr() As Integer
		  arr.Append 10
		  arr.Append 20
		  arr.Append 30
		  
		  Dim testExpr As EXS.Expressions.BinaryExpression= expr.Subscript(expr.Constant(arr), expr.Constant(1))
		  Assert.IsNotNil testExpr, "IsNotNil testExpr"
		  Assert.IsTrue (testExpr.NodeType= EXS.ExpressionType.ArrayIndex), _
		  "IsTrue (testExpr.NodeType= EXS.ExpressionType.ArrayIndex)"
		  
		  Dim actualArr() As Integer= EXS.Expressions.ConstantExpression(testExpr.Left).Value
		  Assert.AreEqual 2, actualArr.LastIdxEXS, "AreEqual 2, actualArr.LastIdx"
		  
		  Dim actual As Variant= EXS.Expressions.ConstantExpression(testExpr.Right).Value
		  Assert.AreEqual 1, actual.IntegerValue, "AreEqual 1, actual.IntegerValue"
		  
		  Assert.AreSame "[10,20,30](1)", testExpr.ToString, "AreSame ""[10,20,30](1)"", testExpr.ToString"
		  
		  Dim o1 As New ObjectWithBinaryExprMethod(10)
		  Dim o2 As Integer= 2
		  Dim o3 As ObjectWithBinaryExprMethod= o1(o2)
		  Dim method As Introspection.MethodInfo= Introspection.GetType(o1).GetMethodInfo("Operator_Subscript")
		  
		  testExpr= expr.Subscript(expr.Constant(o1), expr.Constant(o2), method)
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(testExpr.Left).Value Is o1), _
		  "IsTrue (EXS.Expressions.ConstantExpression(testExpr.Left).Value Is o1)"
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(testExpr.Right).Value= o2), _
		  "IsTrue (EXS.Expressions.ConstantExpression(testExpr.Right).Value= o2)"
		  
		  Dim testExprT As EXS.Expressions.MethodBinaryExpression= EXS.Expressions.MethodBinaryExpression(testExpr)
		  Assert.IsTrue (testExprT.Method Is method), "IsTrue (testExprT.Method Is method)"
		  Assert.AreSame "10(2)", testExpr.ToString, "AreSame ""10(2)"", testExpr.ToString"
		  
		  Dim params() As Variant
		  params.Append o2
		  Dim o4 As ObjectWithBinaryExprMethod= method.Invoke(o1, params)
		  Assert.AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue, _
		  "AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SubtractTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim testExpr As EXS.Expressions.BinaryExpression= expr.Subtract(expr.Constant(2), expr.Constant(2))
		  Assert.IsNotNil testExpr, "IsNotNil testExpr"
		  Assert.IsTrue (testExpr.NodeType= EXS.ExpressionType.Subtract), _
		  "IsTrue (testExpr.NodeType= EXS.ExpressionType.Subtract)"
		  
		  Dim actual As Variant= EXS.Expressions.ConstantExpression(testExpr.Left).Value
		  Assert.AreEqual 2, actual.IntegerValue, "AreEqual 2, actual.IntegerValue"
		  
		  actual= EXS.Expressions.ConstantExpression(testExpr.Right).Value
		  Assert.AreEqual 2, actual.IntegerValue, "AreEqual 2, actual.IntegerValue"
		  Assert.AreSame "2 - 2", testExpr.ToString, "AreSame ""2 - 2"", addExpr.ToString"
		  
		  Dim o1 As New ObjectWithBinaryExprMethod(10)
		  Dim o2 As New ObjectWithBinaryExprMethod(20)
		  Dim o3 As ObjectWithBinaryExprMethod= o1- o2
		  Dim method As Introspection.MethodInfo= Introspection.GetType(o1).GetMethodInfo("Operator_Subtract")
		  
		  testExpr= expr.Subtract(expr.Constant(o1), expr.Constant(o2), method)
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(testExpr.Left).Value Is o1), _
		  "IsTrue (EXS.Expressions.ConstantExpression(testExpr.Left).Value Is o1)"
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(testExpr.Right).Value Is o2), _
		  "IsTrue (EXS.Expressions.ConstantExpression(testExpr.Right).Value Is o2)"
		  
		  Dim testExprT As EXS.Expressions.MethodBinaryExpression= EXS.Expressions.MethodBinaryExpression(testExpr)
		  Assert.IsTrue (testExprT.Method Is method), "IsTrue (testExprT.Method Is method)"
		  Assert.AreSame "10 - 20", testExpr.ToString, "AreSame ""10 - 20"", testExpr.ToString"
		  
		  Dim params() As Variant
		  params.Append o2
		  Dim o4 As ObjectWithBinaryExprMethod= method.Invoke(o1, params)
		  Assert.AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue, _
		  "AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Subtract_CompileTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.Subtract(paramExpr, expr.Constant(1)), _
		  paramExpr)
		  Dim str1 As String= lambdaExpr.ToString
		  Assert.AreSame "a => a - 1", str1, "AreSame ""a => a - 1"", str1"
		  
		  Dim params() As Variant
		  params.Append 1
		  Dim result As Variant= lambdaExpr.Compile.Invoke(params)
		  Assert.AreEqual 0, result.IntegerValue, "AreEqual 0, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XOrTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim testExpr As EXS.Expressions.BinaryExpression= expr.XOr_(expr.Constant(85), expr.Constant(43))
		  Assert.IsNotNil testExpr, "IsNotNil testExpr"
		  Assert.IsTrue (testExpr.NodeType= EXS.ExpressionType.ExclusiveOr), _
		  "IsTrue (testExpr.NodeType= EXS.ExpressionType.ExclusiveOr)"
		  
		  Dim actual As Variant= EXS.Expressions.ConstantExpression(testExpr.Left).Value
		  Assert.AreEqual 85, actual.IntegerValue, "AreEqual 85, actual.IntegerValue"
		  
		  actual= EXS.Expressions.ConstantExpression(testExpr.Right).Value
		  Assert.AreEqual 43, actual.IntegerValue, "AreEqual 43, actual.IntegerValue"
		  Assert.AreSame "85 ¿ 43", testExpr.ToString, "AreSame ""85 ¿ 43"", testExpr.ToString"
		  
		  Dim o1 As New ObjectWithBinaryExprMethod(87)
		  Dim o2 As New ObjectWithBinaryExprMethod(107)
		  Dim o3 As ObjectWithBinaryExprMethod= o1 XOr o2
		  Dim method As Introspection.MethodInfo= Introspection.GetType(o1).GetMethodInfo("Operator_XOr")
		  
		  testExpr= expr.XOr_(expr.Constant(o1), expr.Constant(o2), method)
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(testExpr.Left).Value Is o1), _
		  "IsTrue (EXS.Expressions.ConstantExpression(testExpr.Left).Value Is o1)"
		  Assert.IsTrue (EXS.Expressions.ConstantExpression(testExpr.Right).Value Is o2), _
		  "IsTrue (EXS.Expressions.ConstantExpression(testExpr.Right).Value Is o2)"
		  
		  Dim testExprT As EXS.Expressions.MethodBinaryExpression= EXS.Expressions.MethodBinaryExpression(testExpr)
		  Assert.IsTrue (testExprT.Method Is method), "IsTrue (testExprT.Method Is method)"
		  Assert.AreSame "87 ¿ 107", testExpr.ToString, "AreSame ""87 ¿ 107"", testExpr.ToString"
		  
		  Dim params() As Variant
		  params.Append o2
		  Dim o4 As ObjectWithBinaryExprMethod= method.Invoke(o1, params)
		  Assert.AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue, _
		  "AreEqual o3.Value.IntegerValue, o4.Value.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XOr_CompileTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Boolean"), "a")
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.XOr_(paramExpr, expr.Constant(False)), _
		  paramExpr)
		  Dim str1 As String= lambdaExpr.ToString
		  Assert.AreSame "a => a ¿ False", str1, "AreSame ""a => a ¿ False"", str1"
		  
		  Dim params() As Variant
		  params.Append False
		  Dim result As Variant= lambdaExpr.Compile.Invoke(params)
		  Assert.IsFalse result.BooleanValue, "IsFalse result.BooleanValue"
		  
		  lambdaExpr= expr.Lambda(_
		  expr.XOr_(paramExpr, expr.Constant(True)), _
		  paramExpr)
		  params(0)= True
		  result= lambdaExpr.Compile.Invoke(params)
		  Assert.IsFalse result.BooleanValue, "IsFalse result.BooleanValue"
		  
		  lambdaExpr= expr.Lambda(_
		  expr.XOr_(paramExpr, expr.Constant(True)), _
		  paramExpr)
		  params(0)= False
		  result= lambdaExpr.Compile.Invoke(params)
		  Assert.IsTrue result.BooleanValue, "IsTrue result.BooleanValue"
		  
		  lambdaExpr= expr.Lambda(_
		  expr.XOr_(paramExpr, expr.Constant(False)), _
		  paramExpr)
		  params(0)= True
		  result= lambdaExpr.Compile.Invoke(params)
		  Assert.IsTrue result.BooleanValue, "IsTrue result.BooleanValue"
		  
		  paramExpr= expr.Parameter(EXS.GetType("Integer"), "a")
		  lambdaExpr= expr.Lambda(_
		  expr.XOr_(paramExpr, expr.Constant(7)), _
		  paramExpr)
		  str1= lambdaExpr.ToString
		  Assert.AreSame "a => a ¿ 7", str1, "AreSame ""a => a ¿ 7"", str1"
		  
		  params(0)= 31
		  result= lambdaExpr.Compile.Invoke(params)
		  Assert.AreEqual 24, result.IntegerValue, "AreEqual 24, result.IntegerValue"
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
