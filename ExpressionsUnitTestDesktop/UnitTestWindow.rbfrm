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
         LockedInPosition=   False
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
         LockedInPosition=   False
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
		  
		  expr= expr.Lambda(expr.Block(exprs1), paramExpr)
		  
		  Dim compiler As New EXS.Expressions.Compiler(expr)
		  compiler.BinaryCode.Disassemble TextAreaWriter1
		  
		  TextAreaWriter1.WriteLn EndOfLine
		  
		  Dim runner As New EXS.Expressions.Runner(compiler.BinaryCode, TextAreaWriter1)
		  Dim result As Variant= runner.Run("hello")
		  TextAreaWriter1.WriteLn EndOfLine
		  TextAreaWriter1.WriteLn expr.ToString
		  TextAreaWriter1.WriteLn "result: "+ result.StringValue
		  
		  
		  // assign:
		  'Dim expr As EXS.Expressions.Expression
		  ''Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("String"), "s")
		  ''expr= expr.Assign(paramExpr, expr.Constant("world"))
		  ''expr= expr.Assign(paramExpr, expr.Add(expr.Constant("hello"), expr.Constant("world")))
		  ''expr= expr.Assign(paramExpr, paramExpr)
		  'expr= expr.Assign(expr.Constant("a"), expr.Constant(1))
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
		  
		  
		  // call:
		  'Dim expr As EXS.Expressions.Expression
		  'expr= expr.CallExpr(Nil, GetTypeInfo(EXS.System), "DebugLog", expr.Constant("hello world!"))
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
		  
		  
		  // u32, u64:
		  'Dim expr As EXS.Expressions.Expression
		  ''expr= expr.Constant(&hFFFFFFFF)
		  'expr= expr.Constant(&hFFFFFFFFFFFFFFFF)
		  '
		  'Dim compiler As New EXS.Expressions.Compiler(expr)
		  'compiler.BinaryCode.Disassemble TextAreaWriter1
		  'Break
		  
		  
		  // not equal, gratherOrEqual, lessOrEqual:
		  'Dim expr As EXS.Expressions.Expression
		  ''expr= expr.NotEqual(expr.Constant(1), expr.Constant(2))
		  ''expr= expr.NotEqual(expr.Constant(1), expr.Constant(1))
		  ''expr= expr.GreaterThanOrEqual(expr.Constant(2), expr.Constant(1))
		  ''expr= expr.GreaterThanOrEqual(expr.Constant(2), expr.Constant(2))
		  ''expr= expr.GreaterThanOrEqual(expr.Constant(1), expr.Constant(2))
		  ''expr= expr.LessThanOrEqual(expr.Constant(1), expr.Constant(2))
		  ''expr= expr.LessThanOrEqual(expr.Constant(1), expr.Constant(1))
		  'expr= expr.LessThanOrEqual(expr.Constant(2), expr.Constant(1))
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
		  'Dim bytecode As New EXS.Expressions.BinaryCode
		  'Dim ffile As FolderItem= SpecialFolder.Documents.Child("bytecode.bin")
		  'Dim bytecode As New EXS.Expressions.BinaryCode(ffile)
		  'Dim str1 As String= bytecode.Disassemble
		  
		  'Dim idx As Integer= bytecode.StoreSymbol("hola")
		  'idx= bytecode.StoreSymbol("mundo")
		  'idx= bytecode.StoreSymbol("hola")
		  'idx= bytecode.StoreSymbol(GetTypeInfo(TCPSocket))
		  'idx= bytecode.StoreSymbol(New EXS.Expressions.ConstantExpression(11))
		  'idx= bytecode.StoreSymbol(New EXS.Expressions.ConstantExpression(1.1))
		  'idx= bytecode.StoreSymbol(New EXS.Expressions.ConstantExpression(False))
		  '
		  'bytecode.EmitCode EXS.OpCodes.Ret
		  'bytecode.EmitValue idx
		  'Dim str2 As String= bytecode.Disassemble
		  
		  'bytecode.Save SpecialFolder.Documents.Child("bytecode.bin")
		  'Break
		  
		  
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
		  'expr.CallExpr(Nil, GetTypeInfo(EXS.System), "DebugLog", paramExpr),_
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
		  
		  
		  // convert:
		  'Dim expr As EXS.Expressions.Expression
		  'Dim result As Variant
		  '
		  'Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Integer"), "a")
		  'Dim typeAsExpr As EXS.Expressions.UnaryExpression= expr.Convert(_
		  'paramExpr, _
		  'EXS.GetType("String"))
		  'Dim str1 As String= typeAsExpr.ToString
		  '
		  'Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  'typeAsExpr, _
		  'paramExpr)
		  'str1= lambdaExpr.ToString
		  '
		  'Dim params() As Variant
		  'params.Append 5
		  'result= lambdaExpr.Compile.Invoke(params)
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
		  
		  
		  'Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(GetType("Integer"), "a")
		  'Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  'expr.RightShift(paramExpr, expr.Constant(2)), _
		  'paramExpr)
		  'Dim str1 As String= lambdaExpr.ToString
		  'Dim params() As Variant
		  'params.Append &b00011111
		  'result= lambdaExpr.Compile.Invoke(params)
		  'Break
		  '
		  'Dim p1 As EXS.Expressions.ParameterExpression= expr.Parameter(GetType("String"), "s1")
		  'Dim assignExpr1 As EXS.Expressions.BinaryExpression= expr.Assign(p1, expr.Constant("hello"))
		  'Dim str1 As String= assignExpr1.ToString
		  '
		  'Dim p2 As EXS.Expressions.ParameterExpression= expr.Parameter(GetType("String"), "s2")
		  'Dim assignExpr2 As EXS.Expressions.BinaryExpression= expr.Assign(p2, p1)
		  'Dim str2 As String= assignExpr2.ToString
		  '
		  'Dim blockExpr As EXS.Expressions.Expression= expr.Block(assignExpr1, assignExpr2, p2)
		  'result= expr.Lambda(blockExpr).Compile.Invoke(Nil)
		  'Break
		  '
		  'Dim parm1 As EXS.Expressions.ParameterExpression
		  'parm1= EXS.Expressions.ParameterExpression.Make(GetTypeInfo(Pair), "p1", True)
		  'Break
		  '
		  'Dim o1 As New ObjectWithBinaryExprMethod(10)
		  'Dim methodBin As Introspection.MethodInfo= Introspection.GetType(o1).GetMethodInfo("Operator_Subscript")
		  '
		  'Dim aVar() As Integer
		  'aVar.Append 10
		  'aVar.Append 20
		  'aVar.Append 30
		  'Dim binExpr As EXS.Expressions.Expression= expr.Subscript(expr.Constant(aVar), expr.Constant(1))
		  'Dim str1 As String= binExpr.ToString
		  'Break
		  '
		  'Dim binExpr As EXS.Expressions.BinaryExpression= expr.Subtract(expr.Constant(2), expr.Constant(2))
		  '
		  'Dim o1 As New ObjectWithBinaryExprMethod(10)
		  'Dim o2 As New ObjectWithBinaryExprMethod(20)
		  'Dim o3 As ObjectWithBinaryExprMethod= o1- o2
		  'Dim methodBin As Introspection.MethodInfo= Introspection.GetType(o1).GetMethodInfo("Operator_Subtract")
		  '
		  'Dim binExpr As EXS.Expressions.Expression= expr.Subtract(expr.Constant(o1), expr.Constant(o2), methodBin)
		  'Dim str1 As String= binExpr.ToString
		  'result= EXS.Expressions.ConstantExpression(binExpr.Left).Value- _
		  'EXS.Expressions.ConstantExpression(binExpr.Right).Value
		  '
		  'Dim params() As Variant
		  'params.Append o2
		  'Dim o4 As ObjectWithBinaryExprMethod= methodBin.Invoke(o1, params)
		  'Break
		  '
		  'Dim test1() As Variant
		  'test1.Append 10
		  'test1.Append "hello"
		  
		  'Dim test1() As EXS.Expressions.ConstantExpression
		  'test1.Append expr.Constant(1)
		  'test1.Append expr.Constant(2)
		  'Dim constExpr As EXS.Expressions.ConstantExpression= expr.Constant(test1)
		  'Dim str1 As String= constExpr.ToString
		  'Dim str2 As String= Join(test1.ToString, ",")
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
		  
		  'Dim expr As EXS.Expressions.Expression
		  'Dim blockExpr As EXS.Expressions.BlockExpression= expr.Block(_
		  'expr.CallExpr(Nil, GetTypeInfo(System), "DebugLog", expr.Constant("hello")), _
		  'expr.CallExpr(Nil, GetTypeInfo(System), "DebugLog", expr.Constant("World!")), _
		  'expr.Constant(42))
		  'Dim result As Variant= expr.Lambda(blockExpr).Compile.Invoke(Nil)
		  'Break
		  
		  'Dim constExpr As EXS.Expressions.ConstantExpression= expr.Constant(1)
		  'Dim typ As Introspection.TypeInfo= constExpr.Type
		  'Dim value As Integer= CType(constExpr.Value, Integer)
		  
		  'Dim mc As EXS.Expressions.MethodCallExpression= expr.CallExpr(GetTypeInfo(System), "Log", "Integer": 1, "String": "Hello")
		  'Dim scope As EXS.Expressions.BlockExpression= expr.Block(_
		  'Array(New EXS.Expressions.ParameterExpression(GetType("String"), "var1")), _
		  'expr.Constant(42) _
		  ')
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
