#tag Class
Protected Class CompileTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub AddTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.Add(paramExpr, expr.Constant(1)), _
		  paramExpr)
		  Dim str1 As String= lambdaExpr.ToString
		  Assert.AreSame "(a) => a + 1", str1, "AreSame ""(a) => a + 1"", str1"
		  
		  Dim params() As Variant
		  params.Append 1
		  Dim result As Variant= lambdaExpr.Compile.Invoke(params)
		  Assert.AreEqual 2, result.IntegerValue, "AreEqual 2, result.IntegerValue"
		  
		  paramExpr= expr.Parameter(EXS.GetType("String"), "a")
		  lambdaExpr= expr.Lambda(_
		  expr.Add(paramExpr, expr.Constant(" world")), _
		  paramExpr)
		  
		  str1= lambdaExpr.ToString
		  Assert.AreSame "(a) => a + "" world""", str1, "AreSame ""(a) => a + "" world"""", str1"
		  
		  ReDim params(-1)
		  params.Append "Hello"
		  result= lambdaExpr.Compile.Invoke(params)
		  Assert.AreEqual "Hello world", result.StringValue, "AreEqual ""Hello world"", result.StringValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AndTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Boolean"), "a")
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.And_(paramExpr, expr.Constant(True)), _
		  paramExpr)
		  Dim str1 As String= lambdaExpr.ToString
		  Assert.AreSame "(a) => a & True", str1, "AreSame ""(a) => a & True"", str1"
		  
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
		  Assert.AreSame "(a) => a & 85", str1, "AreSame ""(a) => a & 85"", str1"
		  
		  params(0)= 170
		  result= lambdaExpr.Compile.Invoke(params)
		  Assert.AreEqual 0, result.IntegerValue, "AreEqual 0, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AssignBlockTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("String"), "a")
		  Dim exprs() As EXS.Expressions.Expression
		  exprs.Append expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", paramExpr)
		  exprs.Append expr.Assign(paramExpr, expr.Add(expr.Constant("hello"), expr.Constant("world")))
		  exprs.Append expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", paramExpr)
		  exprs.Append expr.Assign(paramExpr, expr.Constant("world"))
		  exprs.Append expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", paramExpr)
		  
		  Dim params() As Variant
		  params.Append "hallo"
		  Dim result As Variant= expr.Lambda(expr.Block(exprs), paramExpr).Compile.Invoke(params)
		  Assert.AreSame "world", result.StringValue, "AreSame ""world"", result.StringValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AssignConstantTest()
		  Dim expr As EXS.Expressions.Expression
		  'Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("String"), "s")
		  'expr= expr.Assign(paramExpr, expr.Constant("world"))
		  'expr= expr.Assign(paramExpr, expr.Add(expr.Constant("hello"), expr.Constant("world")))
		  'expr= expr.Assign(paramExpr, paramExpr)
		  expr= expr.Assign(expr.Constant("a"), expr.Constant(1))
		  
		  Dim result As Variant= expr.Lambda(expr).Compile.Invoke(Nil)
		  Assert.AreEqual 1, result.IntegerValue, "AreEqual 1, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AssignTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim p1 As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("String"), "s1")
		  Dim assignExpr1 As EXS.Expressions.BinaryExpression= expr.Assign(p1, expr.Constant("hello"))
		  
		  Dim blockExpr As EXS.Expressions.Expression= expr.Block(assignExpr1, p1)
		  
		  Dim params() As Variant
		  params.Append "world"
		  Dim result As Variant= expr.Lambda(blockExpr, p1).Compile.Invoke(params)
		  
		  Assert.AreSame "hello", result.StringValue, "AreSame ""hello"", result.StringValue"
		  
		  Dim p2 As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("String"), "s2")
		  Dim assignExpr2 As EXS.Expressions.BinaryExpression= expr.Assign(p2, p1)
		  
		  blockExpr= expr.Block(assignExpr1, assignExpr2, p2)
		  
		  params.Append "w"
		  result= expr.Lambda(blockExpr, p1, p2).Compile.Invoke(params)
		  
		  Assert.AreSame "hello", result.StringValue, "AreSame ""hello"", result.StringValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BlockTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("String"), "a")
		  Dim exprs() As EXS.Expressions.Expression
		  exprs.Append expr.Assign(paramExpr, expr.Add(expr.Constant("hello"), expr.Constant("world")))
		  exprs.Append expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", paramExpr)
		  
		  Dim exprs1() As EXS.Expressions.Expression
		  exprs1.Append expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", paramExpr)
		  exprs1.Append expr.Assign(paramExpr, expr.Constant("hallo"))
		  exprs1.Append expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", paramExpr)
		  exprs1.Append expr.Block(exprs)
		  exprs1.Append expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", paramExpr)
		  
		  expr= expr.Lambda(expr.Block(exprs1), paramExpr)
		  
		  Dim params() As Variant
		  params.Append "hello"
		  
		  Dim result As Variant= expr.Lambda(expr).Compile.Invoke(params)
		  Assert.AreEqual "helloworld", result.StringValue, "AreEqual ""helloworld"", result.StringValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CallTest()
		  Dim expr As EXS.Expressions.Expression
		  expr= expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", expr.Constant("hello world!"))
		  
		  Dim result As Variant= expr.Lambda(expr.Block(expr)).Compile.Invoke(Nil)
		  Assert.IsNil result, "IsNil result"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CompileLoading(majorVersion As UInt8, minorVersion As UInt16, flags As UInt64) As Boolean
		  #pragma Unused majorVersion
		  #pragma Unused minorVersion
		  #pragma Unused flags
		  
		  Assert.Message "Return True do not load the bin file, .Loaded is False"
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CompileSaveLoadTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim blockExpr As EXS.Expressions.BlockExpression= expr.Block(_
		  expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", expr.Constant("hello")), _
		  expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", expr.Constant("World!")), _
		  expr.Constant(42))
		  Dim result As Variant= expr.Lambda(blockExpr).Compile.Invoke(Nil)
		  Assert.AreEqual 42, result.IntegerValue, "AreEqual 42, result.IntegerValue"
		  
		  Dim binfile As FolderItem= GetTemporaryFolderItem //SpecialFolder.Documents.Child("Expressions.bin")
		  Dim lambdaCompiler As EXS.Expressions.ILambdaCompiler= New EXS.Expressions.LambdaCompiler(expr.Lambda(blockExpr))
		  lambdaCompiler.EmitLambdaBody
		  lambdaCompiler.Save binfile
		  Assert.IsTrue binfile.Exists, "IsTrue binfile.Exists"
		  
		  result= Nil
		  
		  Dim bcode As New EXS.Expressions.BinaryCode(binfile)
		  Dim runner As New EXS.Expressions.Runner(bcode)
		  result= runner.Run
		  Assert.AreEqual 42, result.IntegerValue, "AreEqual 42, result.IntegerValue"
		  
		  bcode= New EXS.Expressions.BinaryCode(binfile, WeakAddressOf CompileLoading)
		  Assert.IsFalse bcode.Loaded, "IsFalse bcode.Loaded"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConditionalTest()
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
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.Divide(paramExpr, expr.Constant(2)), _
		  paramExpr)
		  Dim str1 As String= lambdaExpr.ToString
		  Assert.AreSame "(a) => a / 2", str1, "AreSame ""(a) => a / 2"", str1"
		  
		  Dim params() As Variant
		  params.Append 2
		  Dim result As Variant= lambdaExpr.Compile.Invoke(params)
		  Assert.AreEqual 1, result.IntegerValue, "AreEqual 1, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EqualsTest()
		  Dim expr As EXS.Expressions.Expression
		  expr= expr.NotEqual(expr.Constant(1), expr.Constant(2))
		  
		  Dim result As Variant= expr.Lambda(expr).Compile.Invoke(Nil)
		  Assert.IsTrue result.BooleanValue, "IsTrue result.BooleanValue"
		  
		  expr= expr.NotEqual(expr.Constant(1), expr.Constant(1))
		  result= expr.Lambda(expr).Compile.Invoke(Nil)
		  Assert.IsFalse result.BooleanValue, "IsFalse result.BooleanValue"
		  
		  expr= expr.GreaterThanOrEqual(expr.Constant(2), expr.Constant(1))
		  result= expr.Lambda(expr).Compile.Invoke(Nil)
		  Assert.IsTrue result.BooleanValue, "IsTrue result.BooleanValue"
		  
		  expr= expr.GreaterThanOrEqual(expr.Constant(2), expr.Constant(2))
		  result= expr.Lambda(expr).Compile.Invoke(Nil)
		  Assert.IsTrue result.BooleanValue, "IsTrue result.BooleanValue"
		  
		  expr= expr.GreaterThanOrEqual(expr.Constant(1), expr.Constant(2))
		  result= expr.Lambda(expr).Compile.Invoke(Nil)
		  Assert.IsFalse result.BooleanValue, "IsFalse result.BooleanValue"
		  
		  expr= expr.LessThanOrEqual(expr.Constant(1), expr.Constant(2))
		  result= expr.Lambda(expr).Compile.Invoke(Nil)
		  Assert.IsTrue result.BooleanValue, "IsTrue result.BooleanValue"
		  
		  expr= expr.LessThanOrEqual(expr.Constant(1), expr.Constant(1))
		  result= expr.Lambda(expr).Compile.Invoke(Nil)
		  Assert.IsTrue result.BooleanValue, "IsTrue result.BooleanValue"
		  
		  expr= expr.LessThanOrEqual(expr.Constant(2), expr.Constant(1))
		  result= expr.Lambda(expr).Compile.Invoke(Nil)
		  Assert.IsFalse result.BooleanValue, "IsFalse result.BooleanValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LeftShiftTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.LeftShift(paramExpr, expr.Constant(2)), _
		  paramExpr)
		  Dim str1 As String= lambdaExpr.ToString
		  Assert.AreSame "(a) => a << 2", str1, "AreSame ""(a) => a << 2"", str1"
		  
		  Dim params() As Variant
		  params.Append &b00011111
		  Dim result As Variant= lambdaExpr.Compile.Invoke(params)
		  Assert.AreEqual 124, result.IntegerValue, "AreEqual 124, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MethodCallTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim blockExpr As EXS.Expressions.BlockExpression= expr.Block(_
		  expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", expr.Constant("hello world!")), _
		  expr.Constant(42))
		  Dim str1 As String= "{Sys.DebugLog(""hello world!"")"+ EndOfLine.UNIX+ "42}"
		  Dim str2 As String= ReplaceLineEndings(blockExpr.ToString, EndOfLine.UNIX)
		  Assert.AreSame str1, str2, "AreSame str1, str2"
		  
		  Dim result As Variant= expr.Lambda(blockExpr).Compile.Invoke(Nil)
		  Assert.AreEqual 42, result.IntegerValue, "AreEqual 42, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ModuloTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.Modulo(paramExpr, expr.Constant(2)), _
		  paramExpr)
		  Dim str1 As String= lambdaExpr.ToString
		  Assert.AreSame "(a) => a % 2", str1, "AreSame ""(a) => a % 2"", str1"
		  
		  Dim params() As Variant
		  params.Append 5
		  Dim result As Variant= lambdaExpr.Compile.Invoke(params)
		  Assert.AreEqual 1, result.IntegerValue, "AreEqual 1, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MultiplyTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.Multiply(paramExpr, expr.Constant(2)), _
		  paramExpr)
		  Dim str1 As String= lambdaExpr.ToString
		  Assert.AreSame "(a) => a * 2", str1, "AreSame ""(a) => a * 2"", str1"
		  
		  Dim params() As Variant
		  params.Append 2
		  Dim result As Variant= lambdaExpr.Compile.Invoke(params)
		  Assert.AreEqual 4, result.IntegerValue, "AreEqual 4, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OrTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Boolean"), "a")
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.Or_(paramExpr, expr.Constant(False)), _
		  paramExpr)
		  Dim str1 As String= lambdaExpr.ToString
		  Assert.AreSame "(a) => a | False", str1, "AreSame ""(a) => a | False"", str1"
		  
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
		  Assert.AreSame "(a) => a | 85", str1, "AreSame ""(a) => a | 85"", str1"
		  
		  params(0)= 170
		  result= lambdaExpr.Compile.Invoke(params)
		  Assert.AreEqual 255, result.IntegerValue, "AreEqual 255, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PowerTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.Power(paramExpr, expr.Constant(2)), _
		  paramExpr)
		  Dim str1 As String= lambdaExpr.ToString
		  Assert.AreSame "(a) => a ^ 2", str1, "AreSame ""(a) => a ^ 2"", str1"
		  
		  Dim params() As Variant
		  params.Append 5
		  Dim result As Variant= lambdaExpr.Compile.Invoke(params)
		  Assert.AreEqual CType(25, Double), result.DoubleValue, "AreEqual 25, result.DoubleValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ReturnTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim paramI As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "i")
		  Dim paramN As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "n")
		  
		  Dim exprs() As EXS.Expressions.Expression
		  exprs.Append expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", paramI)
		  exprs.Append expr.Assign(paramI, expr.Add(paramI, expr.Constant(1)))
		  exprs.Append expr.Condition(expr.Equal(paramI, expr.Constant(5)), expr.Ret(paramI), Nil)
		  
		  expr= expr.Lambda(expr.While_(expr.LessThan(paramI, paramN)_
		  , New EXS.Expressions.BlockExpression(exprs))_
		  , paramI, paramN)
		  
		  Dim params() As Variant
		  params.Append 1
		  params.Append 10
		  
		  Dim result As Variant= expr.Lambda(expr).Compile.Invoke(params)
		  Assert.AreEqual 5, result.IntegerValue, "AreEqual 5, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RightShiftTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.RightShift(paramExpr, expr.Constant(2)), _
		  paramExpr)
		  Dim str1 As String= lambdaExpr.ToString
		  Assert.AreSame "(a) => a >> 2", str1, "AreSame ""(a) => a >> 2"", str1"
		  
		  Dim params() As Variant
		  params.Append &b00011111
		  Dim result As Variant= lambdaExpr.Compile.Invoke(params)
		  Assert.AreEqual 7, result.IntegerValue, "AreEqual 7, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SubtractTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.Subtract(paramExpr, expr.Constant(1)), _
		  paramExpr)
		  Dim str1 As String= lambdaExpr.ToString
		  Assert.AreSame "(a) => a - 1", str1, "AreSame ""(a) => a - 1"", str1"
		  
		  Dim params() As Variant
		  params.Append 1
		  Dim result As Variant= lambdaExpr.Compile.Invoke(params)
		  Assert.AreEqual 0, result.IntegerValue, "AreEqual 0, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WhileTest()
		  Dim expr As EXS.Expressions.Expression
		  Dim paramI As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "i")
		  Dim paramN As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "n")
		  
		  Dim exprs() As EXS.Expressions.Expression
		  exprs.Append expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", paramI)
		  exprs.Append expr.Assign(paramI, expr.Add(paramI, expr.Constant(1)))
		  
		  expr= expr.Lambda(expr.While_(expr.LessThan(paramI, paramN), expr.Block(exprs)), _
		  paramI, paramN)
		  
		  Dim params() As Variant
		  params.Append 1
		  params.Append 10
		  
		  Dim result As Variant= expr.Lambda(expr).Compile.Invoke(params)
		  Assert.AreEqual 10, result.IntegerValue, "AreEqual 10, result.IntegerValue"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XOrTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Boolean"), "a")
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.XOr_(paramExpr, expr.Constant(False)), _
		  paramExpr)
		  Dim str1 As String= lambdaExpr.ToString
		  Assert.AreSame "(a) => a ¿ False", str1, "AreSame ""(a) => a ¿ False"", str1"
		  
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
		  Assert.AreSame "(a) => a ¿ 7", str1, "AreSame ""(a) => a ¿ 7"", str1"
		  
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
