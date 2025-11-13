#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  Dim expr As EXS.Expressions.Expression
		  'expr= expr.Constant("hello")
		  'expr= expr.Parameter(EXS.GetType("Integer"), "a")
		  Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "b")
		  expr= expr.Lambda(expr.Add(expr.Multiply(paramExpr, expr.Constant(-2)), expr.Constant(3)), paramExpr)
		  
		  Dim compiler As New EXS.Expressions.Compiler
		  compiler.Compile expr
		  
		  compiler.BinaryCode.Disassemble stdout
		  'compiler.BinaryCode.Save SpecialFolder.Documents.Child("bytecode.bin")
		  
		  stdout.WriteLn EndOfLine+ EndOfLine
		  
		  Dim runner As New EXS.Expressions.Runner(compiler.BinaryCode, stdout)
		  Dim result As Variant= runner.Run(2)
		  
		  stdout.WriteLn EndOfLine+ EndOfLine
		  stdout.WriteLn expr.ToString
		  
		  stdout.WriteLn "result: "+ result.StringValue
		  Break
		End Function
	#tag EndEvent


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
