#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  // block:
		  Dim expr As EXS.Expressions.Expression
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("String"), "a")
		  Dim exprs() As EXS.Expressions.Expression
		  exprs.Append expr.Assign(paramExpr, expr.Add(expr.Constant("hello"), expr.Constant("world")))
		  exprs.Append expr.CallExpr(Nil, GetTypeInfo(EXS.System), "DebugLog", paramExpr)
		  
		  Dim exprs1() As EXS.Expressions.Expression
		  exprs1.Append expr.CallExpr(Nil, GetTypeInfo(EXS.System), "DebugLog", paramExpr)
		  exprs1.Append expr.Assign(paramExpr, expr.Constant("hallo"))
		  exprs1.Append expr.CallExpr(Nil, GetTypeInfo(EXS.System), "DebugLog", paramExpr)
		  exprs1.Append expr.Block(exprs)
		  exprs1.Append expr.CallExpr(Nil, GetTypeInfo(EXS.System), "DebugLog", paramExpr)
		  
		  expr= expr.Lambda(expr.Block(exprs1))
		  
		  Dim compiler As New EXS.Expressions.Compiler(expr)
		  compiler.BinaryCode.Disassemble stdout
		  
		  stdout.WriteLn EndOfLine
		  
		  Dim runner As New EXS.Expressions.Runner(compiler.BinaryCode, stdout)
		  Dim result As Variant= runner.Run("hello")
		  stdout.WriteLn EndOfLine
		  stdout.WriteLn expr.ToString
		  stdout.WriteLn "result: "+ result.StringValue
		  Call Input
		  
		  
		  // test
		  'Dim expr As EXS.Expressions.Expression
		  ''expr= expr.Constant("hello")
		  ''expr= expr.Parameter(EXS.GetType("Integer"), "a")
		  'Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "b")
		  'expr= expr.Lambda(expr.Add(expr.Multiply(paramExpr, expr.Constant(-2)), expr.Constant(3)), paramExpr)
		  '
		  'Dim compiler As New EXS.Expressions.Compiler
		  'compiler.Compile expr
		  '
		  'compiler.BinaryCode.Disassemble stdout
		  ''compiler.BinaryCode.Save SpecialFolder.Documents.Child("bytecode.bin")
		  '
		  'stdout.WriteLn EndOfLine+ EndOfLine
		  '
		  'Dim runner As New EXS.Expressions.Runner(compiler.BinaryCode, stdout)
		  'Dim result As Variant= runner.Run(2)
		  '
		  'stdout.WriteLn EndOfLine+ EndOfLine
		  'stdout.WriteLn expr.ToString
		  '
		  'stdout.WriteLn "result: "+ result.StringValue
		  'Break
		End Function
	#tag EndEvent


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
