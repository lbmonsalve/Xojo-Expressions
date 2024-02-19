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
		  // reduce:
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim multExpr As EXS.Expressions.BinaryExpression= expr.Multiply(expr.Constant(2), expr.Constant(2))
		  Dim addExpr As EXS.Expressions.BinaryExpression= expr.Add(expr.Constant(1), multExpr)
		  'Assert.AreSame "1 + 2 * 2", addExpr.ToString, "AreSame ""1 + 2 * 2"", addExpr.ToString"
		  
		  Dim lambdaExpr As EXS.Expressions.LambdaExpression= expr.Lambda(addExpr)
		  Dim str1 As String= lambdaExpr.ToString
		  
		  Dim result As Variant= lambdaExpr.Compile.Invoke(Nil)
		  Break
		  
		  
		  // convert:
		  'Dim expr As EXS.Expressions.Expression
		  'Dim result As Variant
		  '
		  'Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(GetType("Integer"), "a")
		  'Dim typeAsExpr As EXS.Expressions.UnaryExpression= expr.Convert(_
		  'paramExpr, _
		  'GetType("String"))
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
		  
		  
		  'Dim paramExpr As EXS.Expressions.ParameterExpression= expr.Parameter(GetType("Boolean"), "a")
		  'Dim conditionExpr As EXS.Expressions.ConditionalExpression= expr.Condition(_
		  'paramExpr, _
		  'expr.Constant("true"), _
		  'expr.Constant("false") _
		  ')
		  'Dim str1 As String= conditionExpr.ToString
		  '
		  'Dim params() As Variant
		  'params.Append False
		  'result= expr.Lambda(conditionExpr, paramExpr).Compile.Invoke(params)
		  'Break
		  
		  'Dim num As Integer= 9
		  'Dim conditionExpr As EXS.Expressions.ConditionalExpression= expr.Condition(_
		  'expr.Constant(num> 10), _
		  'expr.Constant("num is greater than 10"), _
		  'expr.Constant("num is smaller than 10") _
		  ')
		  'Dim str1 As String= conditionExpr.ToString
		  'result= expr.Lambda(conditionExpr).Compile.Invoke(Nil)
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
		  
		  
		  'Dim level As System.LogLevel= System.LogLevel.Emergency
		  'System.Log System.LogLevel.Success, "hello"
		  'Dim netw As Variant= System.Network
		  'Break
		  
		  
		  'Dim ti As Introspection.TypeInfo= GetTypeInfo(System)
		  'Dim methods() As Introspection.MethodInfo= ti.GetMethods
		  'Dim method As Introspection.MethodInfo= methods(0)
		  'Dim params() As Variant
		  'params.Append "hello"
		  'method.Invoke Nil, params
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
		  
		End Sub
	#tag EndEvent
#tag EndEvents
