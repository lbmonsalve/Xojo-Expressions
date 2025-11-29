#tag Window
Begin Window UnitTestWindow
   BackColor       =   16777215
   Backdrop        =   ""
   CloseButton     =   True
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   HasBackColor    =   False
   Height          =   600
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   True
   MaxWidth        =   32000
   MenuBar         =   97988607
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   True
   Title           =   "Expressions UnitTest"
   Visible         =   True
   Width           =   800
   Begin TabPanel TabPanel1
      AutoDeactivate  =   True
      Bold            =   ""
      Enabled         =   True
      Height          =   600
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Panels          =   ""
      Scope           =   0
      SmallTabs       =   ""
      TabDefinition   =   "UnitTest\rTest"
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   16
      TextUnit        =   0
      Top             =   0
      Underline       =   ""
      Value           =   1
      Visible         =   True
      Width           =   800
      Begin UnitTestPanel UnitTestPanel1
         AcceptFocus     =   ""
         AcceptTabs      =   True
         AutoDeactivate  =   True
         BackColor       =   16777215
         Backdrop        =   ""
         Enabled         =   True
         EraseBackground =   True
         HasBackColor    =   False
         Height          =   550
         HelpTag         =   ""
         InitialParent   =   "TabPanel1"
         Left            =   15
         LockBottom      =   True
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   True
         LockTop         =   True
         Scope           =   0
         TabIndex        =   0
         TabPanelIndex   =   1
         TabStop         =   True
         Top             =   38
         UseFocusRing    =   ""
         Visible         =   True
         Width           =   770
      End
      Begin PushButton PushButton1
         AutoDeactivate  =   True
         Bold            =   ""
         ButtonStyle     =   0
         Cancel          =   ""
         Caption         =   "Test"
         Default         =   ""
         Enabled         =   True
         Height          =   30
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "TabPanel1"
         Italic          =   ""
         Left            =   20
         LockBottom      =   ""
         LockedInPosition=   True
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Scope           =   0
         TabIndex        =   0
         TabPanelIndex   =   2
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   16
         TextUnit        =   0
         Top             =   54
         Underline       =   ""
         Visible         =   True
         Width           =   80
      End
      Begin TextAreaWriter TextAreaWriter1
         AcceptTabs      =   ""
         Alignment       =   0
         AutoDeactivate  =   True
         AutomaticallyCheckSpelling=   False
         BackColor       =   &hFFFFFF
         Bold            =   ""
         Border          =   True
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Format          =   ""
         Height          =   484
         HelpTag         =   ""
         HideSelection   =   True
         Index           =   -2147483648
         InitialParent   =   "TabPanel1"
         Italic          =   ""
         Left            =   20
         LimitText       =   0
         LockBottom      =   True
         LockedInPosition=   True
         LockLeft        =   True
         LockRight       =   True
         LockTop         =   True
         Mask            =   ""
         Multiline       =   True
         ReadOnly        =   ""
         Scope           =   0
         ScrollbarHorizontal=   ""
         ScrollbarVertical=   True
         Styled          =   False
         TabIndex        =   1
         TabPanelIndex   =   2
         TabStop         =   True
         Text            =   ""
         TextColor       =   &h000000
         TextFont        =   "System"
         TextSize        =   16
         TextUnit        =   0
         Top             =   96
         Underline       =   ""
         UseFocusRing    =   True
         Visible         =   True
         Width           =   760
      End
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Resized()
		  #if RBVersion< 2014
		    UnitTestPanel1.Refresh
		  #endif
		End Sub
	#tag EndEvent


	#tag MenuHandler
		Function EditClearAll() As Boolean Handles EditClearAll.Action
			UnitTestPanel1.SelectAllGroups(False, False)
			
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditSelectAll() As Boolean Handles EditSelectAll.Action
			UnitTestPanel1.SelectAllGroups(True, False)
			
			Return True
			
		End Function
	#tag EndMenuHandler


#tag EndWindowCode

#tag Events PushButton1
	#tag Event
		Sub Action()
		  // compile recursive fibonacci:
		  Dim expr As EXS.Expressions.Expression
		  Dim nParam As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Double"), "n")
		  Dim methodVar As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Variant"), "fibonacci")
		  Dim one As EXS.Expressions.ConstantExpression= expr.Constant(1)
		  Dim two As EXS.Expressions.ConstantExpression= expr.Constant(2)
		  
		  Dim test As EXS.Expressions.Expression= expr.LessThan(nParam, two)
		  Dim truthy As EXS.Expressions.Expression= nParam
		  Dim invoka As EXS.Expressions.Expression= expr.Invoke(methodVar, expr.Subtract(nParam, two))
		  Dim invokb As EXS.Expressions.Expression= expr.Invoke(methodVar, expr.Subtract(nParam, one))
		  Dim falsy As EXS.Expressions.Expression= expr.Add(invoka, invokb)
		  
		  Dim lambda As EXS.Expressions.Expression= expr.Lambda(expr.Condition(test, truthy, falsy), nParam)
		  
		  expr= expr.Lambda(expr.Block(expr.Assign(methodVar, lambda), expr.Invoke(methodVar, nParam)) _
		  , nParam)
		  TextAreaWriter1.WriteLn expr.ToString+ EndOfLine
		  
		  Dim compiler As New EXS.Expressions.Compiler(expr)
		  compiler.BinaryCode.Disassemble TextAreaWriter1
		  TextAreaWriter1.WriteLn EndOfLine
		  
		  Dim runner As New EXS.Expressions.Runner(compiler.BinaryCode, TextAreaWriter1)
		  Dim n As Double= 2
		  
		  Dim elapse As Double, result As Variant
		  Try
		    elapse= Microseconds
		    result= runner.Run(n)
		    elapse= (Microseconds- elapse)/ 1000
		  Catch exc As RuntimeException
		    'Break
		  End Try
		  
		  TextAreaWriter1.WriteLn "fibonacci"+ Str(n, "\(#\)\=\ ")+ Str(result)+ " "+ Str(elapse, "#\m\s")
		  
		  
		  // compile fun lambda
		  'Dim expr As EXS.Expressions.Expression
		  'Dim methodVar As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Variant"), "debug")
		  '
		  'Dim lambda As EXS.Expressions.Expression= expr.Lambda(expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", expr.Constant("hallo")))
		  'expr= expr.Lambda(expr.Block(expr.Assign(methodVar, lambda), expr.Invoke(methodVar)))
		  'TextAreaWriter1.WriteLn expr.ToString+ EndOfLine
		  '
		  'Dim compiler As New EXS.Expressions.Compiler(expr)
		  'compiler.BinaryCode.Disassemble TextAreaWriter1
		  'TextAreaWriter1.WriteLn EndOfLine
		  '
		  'Dim runner As New EXS.Expressions.Runner(compiler.BinaryCode, TextAreaWriter1)
		  '
		  'Dim result As Variant= runner.Run
		  'TextAreaWriter1.WriteLn "result: "+ result.StringValue+ " type:"+ Str(result.Type)
		  
		  
		  // test ret
		  'Dim expr As EXS.Expressions.Expression
		  'Dim paramI As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "i")
		  'Dim paramN As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "n")
		  '
		  'Dim exprs() As EXS.Expressions.Expression
		  'exprs.Append expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", paramI)
		  'exprs.Append expr.Assign(paramI, expr.Add(paramI, expr.Constant(1)))
		  'exprs.Append expr.Condition(expr.Equal(paramI, expr.Constant(5)), expr.Ret(paramI))
		  '
		  'expr= expr.Lambda(expr.While_(expr.LessThan(paramI, paramN)_
		  ', New EXS.Expressions.BlockExpression(exprs))_
		  ', paramI, paramN)
		  'TextAreaWriter1.WriteLn expr.ToString+ EndOfLine
		  '
		  'Dim compiler As New EXS.Expressions.Compiler(expr)
		  'compiler.BinaryCode.Disassemble TextAreaWriter1
		  'TextAreaWriter1.WriteLn EndOfLine
		  '
		  'Dim runner As New EXS.Expressions.Runner(compiler.BinaryCode, TextAreaWriter1)
		  '
		  'Dim result As Variant= runner.Run(1, 10)
		  'TextAreaWriter1.WriteLn "result: "+ result.StringValue+ " type:"+ Str(result.Type)
		  
		  
		  // recursive fibonacci:
		  'Dim expr As EXS.Expressions.Expression
		  'Dim nParam As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Double"), "n")
		  'Dim methodVar As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Variant"), "fibonacci")
		  'Dim one As EXS.Expressions.ConstantExpression= expr.Constant(1)
		  'Dim two As EXS.Expressions.ConstantExpression= expr.Constant(2)
		  '
		  'Dim test As EXS.Expressions.Expression= expr.LessThan(nParam, two)
		  'Dim truthy As EXS.Expressions.Expression= nParam
		  'Dim invoka As EXS.Expressions.Expression= expr.Invoke(methodVar, expr.Subtract(nParam, two))
		  'Dim invokb As EXS.Expressions.Expression= expr.Invoke(methodVar, expr.Subtract(nParam, one))
		  'Dim falsy As EXS.Expressions.Expression= expr.Add(invoka, invokb)
		  '
		  'Dim lambda As EXS.Expressions.Expression= expr.Lambda(expr.Condition(test, truthy, falsy), nParam)
		  '
		  'expr= expr.Lambda(expr.Block(expr.Assign(methodVar, lambda), expr.Invoke(methodVar, nParam)) _
		  ', nParam)
		  'TextAreaWriter1.WriteLn expr.ToString+ EndOfLine
		  '
		  'Dim n As Double= 22
		  'Dim resolver As New EXS.Misc.Resolver(n)
		  '
		  'Dim elapse As Double= Microseconds
		  'Dim result As Variant= resolver.Resolve(expr)
		  'elapse= (Microseconds- elapse)/ 1000
		  '
		  'TextAreaWriter1.WriteLn "fibonacci"+ Str(n, "\(#\)\=\ ")+ Str(result)+ " "+ Str(elapse, "#\m\s")
		  
		  
		  // recursive factorial:
		  'Dim expr As EXS.Expressions.Expression
		  'Dim nParam As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Double"), "n")
		  'Dim methodVar As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Variant"), "factorial")
		  'Dim one As EXS.Expressions.ConstantExpression= expr.Constant(1)
		  '
		  'Dim factorial As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  'expr.Condition(expr.LessThanOrEqual(nParam, one), one, _
		  'expr.Multiply(nParam, expr.Invoke(methodVar, expr.Subtract(nParam, one))))_
		  ', nParam)
		  '
		  'expr= expr.Lambda(expr.Block(expr.Assign(methodVar, factorial), expr.Invoke(methodVar, nParam)), nParam)
		  'TextAreaWriter1.WriteLn expr.ToString+ EndOfLine
		  '
		  'Dim resolver As New EXS.Misc.Resolver(30)
		  '
		  'Dim elapse As Double= Microseconds
		  'Dim result As Variant= resolver.Resolve(expr)
		  'elapse= (Microseconds- elapse)/ 1000
		  '
		  'TextAreaWriter1.WriteLn "factorial(30)= "+ Str(result)+ " "+ Str(elapse)+ "ms"
		  
		  
		  // convert:
		  'Dim expr As EXS.Expressions.Expression
		  'Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  'Dim typeAsExpr As EXS.Expressions.UnaryExpression= expr.Convert(_
		  'paramExpr, _
		  'EXS.GetType("String"))
		  'Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  'typeAsExpr, paramExpr)
		  'TextAreaWriter1.WriteLn lambdaExpr.ToString+ EndOfLine
		  '
		  'Dim compiler As New EXS.Expressions.Compiler(lambdaExpr)
		  'compiler.BinaryCode.Disassemble TextAreaWriter1
		  'Dim runner As New EXS.Expressions.Runner(compiler.BinaryCode, TextAreaWriter1)
		  'Dim result As Variant= runner.Run(5)
		  'TextAreaWriter1.WriteLn "result: "+ result.StringValue+ " type:"+ Str(result.Type)
		  
		  'Dim params() As Variant
		  'params.Append 5
		  'Dim result As Variant= lambdaExpr.Compile.Invoke(params)
		  'TextAreaWriter1.WriteLn "result: "+ result.StringValue+ " type:"+ Str(result.Type)
		  
		  
		  // jump:
		  'Dim expr As EXS.Expressions.Expression
		  'Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("String"), "a")
		  'Dim exprs() As EXS.Expressions.Expression
		  'exprs.Append expr.Assign(paramExpr, expr.Add(expr.Constant("hello"), expr.Constant("world")))
		  'exprs.Append expr.Condition(_
		  'expr.Constant(9> 10), _
		  'expr.Assign(paramExpr, expr.Constant("num > 10")), _
		  'expr.Assign(paramExpr, expr.Constant("num < 10")) _
		  ')
		  'exprs.Append expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", paramExpr)
		  'expr= expr.Lambda(expr.Block(exprs), paramExpr)
		  '
		  'TextAreaWriter1.WriteLn expr.ToString+ EndOfLine
		  '
		  'Dim compiler As New EXS.Expressions.Compiler(expr)
		  'compiler.BinaryCode.Disassemble TextAreaWriter1
		  '
		  'TextAreaWriter1.WriteLn EndOfLine
		  '
		  'Dim runner As New EXS.Expressions.Runner(compiler.BinaryCode, TextAreaWriter1)
		  'Dim result As Variant= runner.Run("hello")
		  '
		  'TextAreaWriter1.WriteLn EndOfLine
		  'TextAreaWriter1.WriteLn "result: "+ result.StringValue
		  
		  
		  '// binaryCode jump:
		  ''Dim bcode As New EXS.Expressions.BinaryCode
		  ''Dim theJump As Integer= bcode.EmitJump(EXS.OpCodes.Jump)
		  ''bcode.Disassemble TextAreaWriter1
		  ''
		  ''TextAreaWriter1.WriteLn EndOfLine
		  ''
		  ''bcode.PatchJump theJump
		  ''bcode.Disassemble TextAreaWriter1
		  
		  
		  // binaryCode load:
		  'Dim bcode As New EXS.Expressions.BinaryCode(SpecialFolder.Documents.Child("bytecode.bin"))
		  'bcode.Disassemble TextAreaWriter1
		  '
		  'TextAreaWriter1.WriteLn EndOfLine
		  '
		  'Dim runner As New EXS.Expressions.Runner(bcode, TextAreaWriter1)
		  'Dim result As Variant= runner.Run("hello")
		  '
		  'TextAreaWriter1.WriteLn EndOfLine
		  'TextAreaWriter1.WriteLn "result: "+ result.StringValue
		  
		  
		  // boolean short-circuit
		  'Dim expr As EXS.Expressions.Expression
		  'Dim exprs() As EXS.Expressions.Expression
		  ''exprs.Append expr.And_(expr.Constant(True), expr.Constant(False))
		  'exprs.Append expr.And_(expr.Constant(False), expr.Constant(False))
		  ''exprs.Append expr.Or_(expr.Constant(True), expr.Constant(False))
		  ''exprs.Append expr.Or_(expr.Constant(False), expr.Constant(False))
		  'expr= expr.Lambda(expr.Block(exprs))
		  'TextAreaWriter1.WriteLn expr.ToString+ EndOfLine
		  '
		  'Dim compiler As New EXS.Expressions.Compiler(expr)
		  'compiler.BinaryCode.Disassemble TextAreaWriter1
		  '
		  'TextAreaWriter1.WriteLn EndOfLine
		  '
		  'Dim runner As New EXS.Expressions.Runner(compiler.BinaryCode, TextAreaWriter1)
		  'Dim result As Variant= runner.Run
		  '
		  'TextAreaWriter1.WriteLn EndOfLine
		  'TextAreaWriter1.WriteLn "result: "+ result.StringValue
		  
		  
		  // while:
		  'Dim expr As EXS.Expressions.Expression
		  'Dim paramI As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "i")
		  'Dim paramN As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "n")
		  '
		  'Dim exprs() As EXS.Expressions.Expression
		  'exprs.Append expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", paramI)
		  'exprs.Append expr.Assign(paramI, expr.Add(paramI, expr.Constant(1)))
		  '
		  'expr= expr.Lambda(expr.While_(expr.LessThan(paramI, paramN), expr.Block(exprs)), _
		  'paramI, paramN)
		  'TextAreaWriter1.WriteLn expr.ToString+ EndOfLine
		  '
		  'Dim compiler As New EXS.Expressions.Compiler(expr)
		  'compiler.BinaryCode.Disassemble TextAreaWriter1
		  'TextAreaWriter1.WriteLn EndOfLine
		  
		  'Dim runner As New EXS.Expressions.Runner(compiler.BinaryCode, TextAreaWriter1)
		  'Dim result As Variant= runner.Run(1, 10)
		  'TextAreaWriter1.WriteLn "result: "+ result.StringValue+ " type:"+ Str(result.Type)
		  
		  
		  // assign block:
		  'Dim expr As EXS.Expressions.Expression
		  'Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("String"), "a")
		  'Dim exprs() As EXS.Expressions.Expression
		  'exprs.Append expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", paramExpr)
		  'exprs.Append expr.Assign(paramExpr, expr.Add(expr.Constant("hello"), expr.Constant("world")))
		  'exprs.Append expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", paramExpr)
		  'exprs.Append expr.Assign(paramExpr, expr.Constant("world"))
		  'exprs.Append expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", paramExpr)
		  'expr= expr.Lambda(expr.Block(exprs), paramExpr)
		  'TextAreaWriter1.WriteLn expr.ToString+ EndOfLine
		  '
		  'Dim compiler As New EXS.Expressions.Compiler(expr)
		  'compiler.BinaryCode.Disassemble TextAreaWriter1
		  'TextAreaWriter1.WriteLn EndOfLine
		  '
		  'Dim runner As New EXS.Expressions.Runner(compiler.BinaryCode, TextAreaWriter1)
		  '
		  'Dim result As Variant= runner.Run("hallo")
		  'TextAreaWriter1.WriteLn "result: "+ result.StringValue+ " type:"+ Str(result.Type)
		  
		  
		  // block:
		  'Dim expr As EXS.Expressions.Expression
		  'Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("String"), "a")
		  'Dim exprs() As EXS.Expressions.Expression
		  'exprs.Append expr.Assign(paramExpr, expr.Add(expr.Constant("hello"), expr.Constant("world")))
		  'exprs.Append expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", paramExpr)
		  '
		  'Dim exprs1() As EXS.Expressions.Expression
		  'exprs1.Append expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", paramExpr)
		  'exprs1.Append expr.Assign(paramExpr, expr.Constant("hallo"))
		  'exprs1.Append expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", paramExpr)
		  'exprs1.Append expr.Block(exprs)
		  'exprs1.Append expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", paramExpr)
		  '
		  'expr= expr.Lambda(expr.Block(exprs1), paramExpr)
		  'TextAreaWriter1.WriteLn expr.ToString+ EndOfLine
		  '
		  'Dim compiler As New EXS.Expressions.Compiler(expr)
		  'compiler.BinaryCode.Disassemble TextAreaWriter1
		  'TextAreaWriter1.WriteLn EndOfLine
		  '
		  'Dim runner As New EXS.Expressions.Runner(compiler.BinaryCode, TextAreaWriter1)
		  'Dim result As Variant= runner.Run("hello")
		  'TextAreaWriter1.WriteLn "result: "+ result.StringValue+ " type:"+ Str(result.Type)
		  
		  
		  // u32, u64:
		  'Dim expr As EXS.Expressions.Expression
		  ''expr= expr.Constant(&hFFFFFFFF)
		  'expr= expr.Constant(&hFFFFFFFFFFFFFFFF)
		  '
		  'Dim compiler As New EXS.Expressions.Compiler(expr)
		  'compiler.BinaryCode.Disassemble TextAreaWriter1
		  'Break
		  
		  
		  // not:
		  'Dim expr As EXS.Expressions.Expression
		  'expr= New EXS.Expressions.UnaryExpression(EXS.ExpressionType.Not_, expr.Constant(True), EXS.GetType("Boolean"), Nil)
		  '
		  'Dim compiler As New EXS.Expressions.Compiler(expr)
		  'compiler.BinaryCode.Disassemble TextAreaWriter1
		  '
		  'TextAreaWriter1.AppendText EndOfLine+ EndOfLine
		  '
		  'Dim runner As New EXS.Expressions.Runner(compiler.BinaryCode, TextAreaWriter1)
		  'Dim result As Variant= runner.Run
		  'TextAreaWriter1.AppendText EndOfLine+ EndOfLine
		  'TextAreaWriter1.AppendText expr.ToString+ EndOfLine
		  'TextAreaWriter1.AppendText "result: "+ result.StringValue
		  'Break
		  
		  
		  // parameter store header
		  'Dim expr As EXS.Expressions.Expression
		  ''expr= expr.Constant("hello")
		  ''expr= expr.Parameter(EXS.GetType("Integer"), "a")
		  'Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "b")
		  'expr= expr.Lambda(expr.Add(expr.Multiply(paramExpr, expr.Constant(-2)), expr.Constant(3)), paramExpr)
		  '
		  'Dim compiler As New EXS.Expressions.Compiler(expr)
		  '
		  'compiler.BinaryCode.Disassemble TextAreaWriter1
		  ''compiler.BinaryCode.Save SpecialFolder.Documents.Child("bytecode.bin")
		  '
		  'TextAreaWriter1.AppendText EndOfLine+ EndOfLine
		  '
		  'Dim runner As New EXS.Expressions.Runner(compiler.BinaryCode, TextAreaWriter1)
		  'Dim result As Variant= runner.Run(2)
		  '
		  'TextAreaWriter1.AppendText EndOfLine+ EndOfLine
		  'TextAreaWriter1.AppendText expr.ToString+ EndOfLine
		  'TextAreaWriter1.AppendText "result: "+ result.StringValue
		  'Break
		  
		  
		  // runner
		  'Dim expr As EXS.Expressions.Expression
		  ''expr= expr.Constant(20)
		  'Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  'expr= expr.Lambda(expr.Constant("hello"), paramExpr) // expr.Constant("hello")
		  '
		  'Dim compiler As New EXS.Expressions.Compiler
		  'compiler.Compile expr
		  '
		  'Dim runner As New EXS.Expressions.Runner(compiler.BinaryCode)
		  'Dim result As Variant= runner.Run("world")
		  'Dim str1 As String= compiler.BinaryCode.Disassemble
		  'Break
		  
		  
		  // compile
		  'Dim expr As EXS.Expressions.Expression
		  'Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  'expr= expr.Lambda(paramExpr, paramExpr) // expr.Constant("hello")
		  '
		  'Dim compiler As New EXS.Expressions.Compiler
		  'compiler.Compile expr
		  '
		  'Dim bcode As EXS.Expressions.BinaryCode= compiler.BinaryCode
		  'Dim str1 As String= bcode.Disassemble
		  '
		  'Break
		  
		  
		  // binaryCode:
		  'Dim bcode As New EXS.Expressions.BinaryCode
		  ''bcode.Disassemble TextAreaWriter1
		  '
		  '
		  'Dim idx As Integer= bcode.StoreSymbol("hola")
		  ''bcode.Disassemble TextAreaWriter1
		  '
		  'bcode.EmitCode EXS.OpCodes.Ret
		  'bcode.EmitValue idx
		  'bcode.Disassemble TextAreaWriter1
		  ''bcode.Save SpecialFolder.Documents.Child("bytecode.bin")
		  
		  
		  // symbol key:
		  'Dim key, typ, lng As UInt8
		  '
		  'typ= 15
		  'lng= 7
		  '
		  'key= Bitwise.ShiftLeft(lng, 5) Or typ
		  '
		  'lng= Bitwise.ShiftRight(key, 5)
		  'typ= &b00011111 And key
		  '
		  'lng= 1
		  'typ= 11
		  'key= Bitwise.ShiftLeft(lng, 5) Or typ
		  'Dim example1 As String= "0x"+ Hex(key)
		  '
		  'lng= 0
		  'typ= 4
		  'key= Bitwise.ShiftLeft(lng, 5) Or typ
		  'Dim example2 As String= "0x"+ Hex(key)
		  '
		  'lng= 3
		  'typ= 15
		  'key= Bitwise.ShiftLeft(lng, 5) Or typ
		  'Dim example3 As String= "0x"+ Hex(key)
		  'Break
		  
		  // compile:
		  'Dim expr As EXS.Expressions.Expression
		  'expr= expr.Lambda(expr.Constant(1))
		  'Dim compiler As New EXS.Expressions.Compiler
		  'compiler.Compile expr
		  'Break
		  
		  
		  // boolean short-circuit
		  'Dim expr As EXS.Expressions.Expression
		  ''expr= expr.And_(expr.Constant(True), expr.Constant(False))
		  ''expr= expr.And_(expr.Constant(False), expr.Constant(False))
		  ''expr= expr.Or_(expr.Constant(True), expr.Constant(False))
		  'expr= expr.Or_(expr.Constant(False), expr.Constant(False))
		  '
		  ''Dim printer As New EXS.Misc.Printer
		  ''Dim str1 As String= printer.Print(expr)
		  '
		  'Dim resolver As New EXS.Misc.Resolver
		  'Dim result As Variant
		  'Try
		  'result= resolver.Resolve(expr)
		  'Catch exc As RuntimeException
		  'Break
		  'End Try
		  'Dim str2 As String= expr.ToString
		  'Break
		  
		  
		  // runtime exception:
		  'Dim expr As EXS.Expressions.Expression
		  'Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  ''expr= expr.Lambda(expr.Divide(expr.Constant(5), paramExpr), paramExpr)
		  'expr= expr.Lambda(_
		  'expr.CallExpr(Nil, GetTypeInfo(EXS.Sys), "DebugLog", paramExpr),_
		  'expr.Parameter(EXS.GetType("Integer"), "b"))
		  '
		  ''Dim printer As New EXS.Misc.Printer
		  ''Dim str1 As String= printer.Print(expr)
		  '
		  'Dim resolver As New EXS.Misc.Resolver(0)
		  'Dim result As Variant
		  'Try
		  'result= resolver.Resolve(expr)
		  'Catch exc As RuntimeException
		  'Break
		  'End Try
		  'Dim str2 As String= expr.ToString
		  'Break
		  
		  
		  'Dim p1 As New Pair(1, 1)
		  'Dim p2 As Integer= 1
		  '
		  'Dim t1 As Introspection.TypeInfo= GetTypeInfo(Pair)
		  'Dim t2 As Introspection.TypeInfo= GetTypeInfo(Pair)
		  'Dim t3 As Introspection.TypeInfo= GetTypeInfo(REALbasic.Rect)
		  'Dim t4 As Introspection.TypeInfo= Introspection.GetType(p1)
		  'Dim t5 As Introspection.TypeInfo= GetType("Integer")
		  'Dim t6 As Introspection.TypeInfo= GetType("Variant")
		  'Dim t7 As Introspection.TypeInfo= GetType("Integer")
		  'Dim b1 As Boolean= t5.IsEquivalent(t7)
		  'Dim b2 As Boolean= t5.IsReferenceAssignable(t6)
		  'Break
		  '
		  'Dim expr As EXS.Expressions.Expression
		  'Dim p1 As EXS.Expressions.ParameterExpression= expr.Parameter(GetType("String"), "s1")
		  'Dim p2 As EXS.Expressions.Expression= expr.Constant(10)
		  'Dim t1 As Introspection.TypeInfo= Introspection.GetType(p1)
		  'Dim t2 As Introspection.TypeInfo= GetTypeInfo(EXS.Expressions.Expression)
		  'If t2.IsAssignable(t1) Then
		  'Break
		  'End If
		  'Break
		  
		  
		  'Dim i1 As Integer= 85
		  'Dim i2 As Integer= 170
		  'Dim i3 As Integer= i1 Or i2
		  'Break
		  
		  
		  'Dim i1 As Integer= &b00011111
		  'Dim i2 As Integer= &b00000111
		  'Dim i3 As Integer= Bitwise.ShiftRight(i1, 2)
		  'Dim i3 As Integer= Bitwise.ShiftLeft(i1, 2)
		  'Dim i3 As Integer= i1 XOr i2
		  'If (i3 And i2)= i2 Then
		  'Break
		  'End If
		  'Break
		  
		  
		  ''Dim expr As EXS.Expressions.Expression
		  'Dim aVar() As Integer
		  'aVar.Append 10
		  'aVar.Append 20
		  'aVar.Append 30
		  'Dim binExpr As EXS.Expressions.Expression= expr.Subscript(expr.Constant(aVar), expr.Constant(1))
		  'Dim str1 As String= binExpr.ToString
		  'Break
		  
		  
		  // TODO:
		  ''Dim expr As EXS.Expressions.Expression
		  'Dim test1() As EXS.Expressions.ConstantExpression
		  'test1.Append expr.Constant(1)
		  'test1.Append expr.Constant(2)
		  'Dim constExpr As EXS.Expressions.ConstantExpression= expr.Constant(test1)
		  'Dim str1 As String= constExpr.ToString
		  ''Dim str2 As String= Join(test1.ToString, ",")
		  'Break
		  
		  
		  'Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(GetType("Integer"), "arg")
		  'Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  'expr.Add(paramExpr, expr.Constant(1)), _
		  'paramExpr)
		  'Try
		  '#pragma BreakOnExceptions Off
		  'result= lambdaExpr.Compile.Invoke(CType(1, Variant))
		  '#pragma BreakOnExceptions Default
		  'Catch exc As RuntimeException
		  'System.DebugLog CurrentMethodName+ " "+ Introspection.GetType(exc).FullName
		  'End Try
		  
		  'Break
		  
		  
		  'Dim ti As Introspection.TypeInfo= GetTypeInfo(Realbasic.Rect)
		  'Dim methods() As Introspection.MethodInfo= ti.GetMethods
		  'For Each method As Introspection.MethodInfo In methods
		  'Dim parameters() As Introspection.ParameterInfo= method.GetParameters
		  'Dim parameterDescrips() As String
		  'For Each parameter As Introspection.ParameterInfo In parameters
		  'parameterDescrips.Append parameter.ParameterType.FullName
		  'Next
		  'Dim parameterDescrip As String= method.Name+ "("+ Join(parameterDescrips, ",")+ ")"
		  'Break
		  'Next
		  'Break
		  'Break
		  
		  
		  // variant:
		  'Dim vart1 As Variant= "1"
		  'Dim vart2 As Variant= 2
		  'Dim vart3 As Variant= vart1+ vart2
		  
		  'Dim i8 As Int8= 108
		  'Dim u8 As UInt8= 255
		  'Dim v1 As Variant= i8
		  'Dim vtype As Integer= v1.Type
		  'v1= u8
		  'vtype= v1.Type
		  'Break
		  
		  
		  'Dim v1 As Variant= &hFFFFFFFFFFFFFFFF
		  'Dim vtype As Integer= v1.Type
		  'If v1.DoubleValue> &h7FFFFFFFFFFFFFFF Then
		  'Dim u64 As UInt64= v1.UInt64Value
		  'Dim i64 As Int64= u64
		  'Dim v2 As Variant= u64
		  'Dim vtype2 As Integer= v2.Type
		  'Break
		  'End If
		  '
		  'Dim mb As New MemoryBlock(8)
		  'mb.LittleEndian= False
		  'mb.UInt64Value(0)= v1.UInt64Value
		  '
		  'Dim v2 As UInt64= mb.UInt64Value(0)
		  'Break
		  
		  
		  // INF IND (NaN):
		  'Dim var1 As Variant= -2
		  'Dim var2 As Variant= 0
		  'Dim var3 As Variant= var1/ var2
		  'Dim var4 As Variant= sqrt(var1)
		  'Break
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events TextAreaWriter1
	#tag Event
		Sub Open()
		  #if TargetWin32
		    Me.TextFont= "Courier"
		  #endif
		End Sub
	#tag EndEvent
#tag EndEvents
