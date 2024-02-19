#tag Module
Protected Module EXS
	#tag Method, Flags = &h0
		Function ChkMethodParams(Extends value As Introspection.MethodInfo, left As Introspection.TypeInfo, right As Introspection.TypeInfo) As Boolean
		  Dim methodParams() As Introspection.ParameterInfo= value.GetParameters
		  Dim lastIdx As Integer= methodParams.LastIdxEXS
		  If lastIdx= -1 Then Return False // none param
		  If lastIdx= 0 Then // one param
		    If methodParams(0).ParameterType.Name<> right.Name Then Return False
		    Return True
		  End If
		  
		  If lastIdx<> 1 Then Return False // two params
		  If methodParams(0).ParameterType.Name<> left.Name Or methodParams(1).ParameterType.Name<> right.Name Then Return False
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CountEXS(Extends values() As Object) As Integer
		  Return values.LastIdxEXS+ 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EndFileEXS(Extends value As BinaryStream) As Boolean
		  #if RBVersion< 2019.02
		    Return value.EOF
		  #else
		    Return value.EndOfFile
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetLastExpression(Extends block As EXS.Expressions.BlockExpression) As EXS.Expressions.Expression
		  Dim exprs() As EXS.Expressions.Expression= block.Expressions
		  Dim expr As EXS.Expressions.Expression= exprs(exprs.LastIdx)
		  If expr IsA EXS.Expressions.BlockExpression Then
		    Return EXS.Expressions.BlockExpression(expr).GetLastExpression
		  End If
		  
		  Return expr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetMethodInfo(Extends value As Introspection.TypeInfo, methodName As String) As Introspection.MethodInfo
		  Dim methods() As Introspection.MethodInfo= value.GetMethods
		  For i As Integer= methods.LastIdxEXS To 0 Step -1
		    Dim method As Introspection.MethodInfo= methods(i)
		    If method.Name= methodName Then Return method
		  Next
		  
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetMethodToString(Extends value As Introspection.TypeInfo) As Introspection.MethodInfo
		  // search for method "ToString" returns String and NO params
		  Dim methods() As Introspection.MethodInfo= value.GetMethods
		  For i As Integer= methods.LastIdxEXS To 0 Step -1
		    Dim method As Introspection.MethodInfo= methods(i)
		    If method.Name.Lowercase = "tostring" And Not (method.ReturnType Is Nil) Then
		      If method.ReturnType.Name= "String" Then
		        Dim methodParams() As Introspection.ParameterInfo= method.GetParameters
		        If methodParams.LastIdxEXS= -1 Then
		          Return method
		        End If
		      End If
		    End If
		  Next
		  
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPropertyInfo(Extends value As Introspection.TypeInfo, propName As String) As Introspection.PropertyInfo
		  Dim props() As Introspection.PropertyInfo= value.GetProperties
		  For Each prop As Introspection.PropertyInfo In props
		    If prop.PropertyType.FullName= propName Then Return prop
		  Next
		  
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetRuntimeExc(msg As String, errNum As Integer = 0) As RuntimeException
		  Dim exc As New RuntimeException
		  exc.Message= msg
		  exc.ErrorNumber= errNum
		  
		  Return exc
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetType(name As String) As Introspection.TypeInfo
		  RegisterDefaultTypes
		  
		  Return EXS.TypesUtils.Get(name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasBaseType(Extends value As Introspection.TypeInfo, base As Introspection.TypeInfo) As Boolean
		  If value.BaseType Is Nil Then Return False
		  If value.BaseType.FullName= base.FullName Then Return True
		  
		  Return value.BaseType.HasBaseType(base)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsAssignable(Extends value As Introspection.TypeInfo, rhs As Introspection.TypeInfo) As Boolean
		  If value.Name= "Variant" Then Return True
		  
		  If value= rhs Then Return True
		  If value.FullName= rhs.FullName Then Return True
		  If value.IsInteger And rhs.IsInteger Then Return True
		  If value.IsFloat And rhs.IsInteger Then Return True
		  If value.IsFloat And rhs.IsFloat Then Return True
		  
		  If rhs.HasBaseType(value) Then Return True
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsConvertible(Extends value As Introspection.TypeInfo, other As Introspection.TypeInfo) As Boolean
		  If other.IsAssignable(value) Then Return True
		  If (other.Name= "String" Or other.HasBaseType(GetType("String"))) _
		    And (value.IsNumber Or value.Name= "Boolean" Or value.Name= "Color" Or value.Name= "Date") Then Return True
		    If (value.Name= "String" Or value.HasBaseType(GetType("String"))) _
		      And (other.IsNumber Or other.Name= "Boolean" Or other.Name= "Color" Or other.Name= "Date") Then Return True
		      
		      Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsEquivalent(Extends value As Introspection.TypeInfo, other As Introspection.TypeInfo) As Boolean
		  Return value Is other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsFloat(Extends value As Introspection.TypeInfo) As Boolean
		  Select Case value.Name
		  Case "Currency", "Single", "Double"
		    Return True
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsInteger(Extends value As Introspection.TypeInfo) As Boolean
		  Select Case value.Name
		  Case "Int8", "Int16", "Int32", "Int64", "UInt8", "UInt16", "UInt32", "UInt64"
		    Return True
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsLastExpression(Extends body As EXS.Expressions.Expression, test As EXS.Expressions.Expression) As Boolean
		  If body IsA EXS.Expressions.BlockExpression Then
		    body= EXS.Expressions.BlockExpression(body).GetLastExpression
		  End If
		  If body= test Then Return True
		  If body IsA EXS.Expressions.FullConditionalExpression Then Return True
		  If body IsA EXS.Expressions.TypedParameterExpression Then Return True
		  If body IsA EXS.Expressions.UnaryExpression Then Return True
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsNumber(Extends value As Introspection.TypeInfo) As Boolean
		  Select Case value.Name
		  Case "Int8", "Int16", "Int32", "Int64", "UInt8", "UInt16", "UInt32", "UInt64", "Currency", "Single", "Double"
		    Return True
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsReferenceAssignable(Extends value As Introspection.TypeInfo, other As Introspection.TypeInfo) As Boolean
		  If value.IsEquivalent(other) Then Return True
		  If value.IsAssignable(other) Then Return True
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LastIdx(Extends values() As EXS.Expressions.Expression) As Integer
		  Return values.Ubound
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LastIdx(Extends values() As EXS.Expressions.ParameterExpression) As Integer
		  Return values.Ubound
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LastIdxEXS(Extends values() As Integer) As Integer
		  Return values.Ubound
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LastIdxEXS(Extends values() As Introspection.MethodInfo) As Integer
		  Return values.Ubound
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LastIdxEXS(Extends values() As Introspection.ParameterInfo) As Integer
		  Return values.Ubound
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LastIdxEXS(Extends values() As Object) As Integer
		  Return values.Ubound
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LastIdxEXS(Extends values() As Pair) As Integer
		  Return values.Ubound
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LastIdxEXS(Extends values() As Variant) As Integer
		  Return values.Ubound
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MatchTypeWith(Extends values() As EXS.Expressions.ParameterExpression, varts() As Variant) As Boolean
		  If values.LastIdx= -1 Or varts.LastIdxEXS= -1 Then Return False
		  If values.LastIdx<> varts.LastIdxEXS Then Return False
		  
		  For i As Integer= 0 To values.LastIdx
		    Dim valueType As Introspection.TypeInfo= values(i).Type
		    Dim vartType As Introspection.TypeInfo= varts(i).ToTypeInfo
		    If Not valueType.IsAssignable(vartType) Then Return False
		  Next
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReferenceEquals(Extends value As Object, toCompare As Object) As Boolean
		  Dim vart1 As Variant= value
		  Dim vart2 As Variant= toCompare
		  
		  If vart1.Hash= vart2.Hash Then
		    Return True
		  Else
		    Return False
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Register(ti As Introspection.TypeInfo, name As String = "")
		  EXS.TypesUtils.Register ti, name
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RegisterDefaultTypes()
		  Static once As Boolean
		  If once Then Return
		  
		  Dim ti As Introspection.TypeInfo= GetTypeInfo(EXS.TypesUtils.DefaultTypes)
		  Dim props() As Introspection.PropertyInfo= ti.GetProperties
		  For Each prop As Introspection.PropertyInfo In props
		    Dim tprop As Introspection.TypeInfo= prop.PropertyType
		    Register tprop, tprop.FullName
		    #if Target32Bit
		      If tprop.FullName= "Int32" Then Register(tprop, "Integer")
		      If tprop.FullName= "UInt32" Then Register(tprop, "UInteger")
		    #elseif Target64Bit
		      If tprop.FullName= "Int64" Then Register(tprop, "Integer")
		      If tprop.FullName= "UInt64" Then Register(tprop, "UInteger")
		    #endif
		  Next
		  
		  once= True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Registered(name As String) As Boolean
		  Return EXS.TypesUtils.Registered(name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Release()
		  EXS.TypesUtils.Release
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RootType(Extends value As Introspection.TypeInfo) As Introspection.TypeInfo
		  If value.BaseType Is Nil Then Return value
		  
		  Return value.BaseType.RootType
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToInstructionCode(Extends value As EXS.Expressions.Expression.ExpressionType) As EXS.Expressions.LambdaCompiler.OpCodes
		  Select Case value
		  Case EXS.Expressions.Expression.ExpressionType.Add
		    Return EXS.Expressions.LambdaCompiler.OpCodes.Add
		  Case EXS.Expressions.Expression.ExpressionType.Subtract
		    Return EXS.Expressions.LambdaCompiler.OpCodes.Subtract
		  Case EXS.Expressions.Expression.ExpressionType.Multiply
		    Return EXS.Expressions.LambdaCompiler.OpCodes.Multiply
		  Case EXS.Expressions.Expression.ExpressionType.Divide
		    Return EXS.Expressions.LambdaCompiler.OpCodes.Divide
		  Case EXS.Expressions.Expression.ExpressionType.Modulo
		    Return EXS.Expressions.LambdaCompiler.OpCodes.Modulo
		  Case EXS.Expressions.Expression.ExpressionType.Power
		    Return EXS.Expressions.LambdaCompiler.OpCodes.Power
		  Case EXS.Expressions.Expression.ExpressionType.And_
		    Return EXS.Expressions.LambdaCompiler.OpCodes.And_
		  Case EXS.Expressions.Expression.ExpressionType.Or_
		    Return EXS.Expressions.LambdaCompiler.OpCodes.Or_
		  Case EXS.Expressions.Expression.ExpressionType.ExclusiveOr
		    Return EXS.Expressions.LambdaCompiler.OpCodes.ExclusiveOr
		  Case EXS.Expressions.Expression.ExpressionType.LeftShift
		    Return EXS.Expressions.LambdaCompiler.OpCodes.LeftShift
		  Case EXS.Expressions.Expression.ExpressionType.RightShift
		    Return EXS.Expressions.LambdaCompiler.OpCodes.RightShift
		  Case EXS.Expressions.Expression.ExpressionType.Convert
		    Return EXS.Expressions.LambdaCompiler.OpCodes.Convert
		  Case Else
		    Raise GetRuntimeExc("ExpressionType not implemented!")
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToInteger(Extends value As EXS.Expressions.LambdaCompiler.OpCodes) As Integer
		  Return Integer(value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToStringEXS(Extends values() As Boolean) As String()
		  Dim ret() As String
		  
		  For Each value As Boolean In values
		    ret.Append Str(value)
		  Next
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToStringEXS(Extends values() As Currency) As String()
		  Dim ret() As String
		  
		  For Each value As Currency In values
		    ret.Append Str(value)
		  Next
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToStringEXS(Extends values() As Double) As String()
		  Dim ret() As String
		  
		  For Each value As Double In values
		    ret.Append Str(value)
		  Next
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToStringEXS(Extends values() As Int64) As String()
		  Dim ret() As String
		  
		  For Each value As Int64 In values
		    ret.Append Str(value)
		  Next
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToStringEXS(Extends values() As Integer) As String()
		  Dim ret() As String
		  
		  For Each value As Integer In values
		    ret.Append Str(value)
		  Next
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToStringEXS(Extends values() As Object) As String()
		  Dim ret() As String
		  
		  For Each value As Object In values
		    Dim ti As Introspection.TypeInfo= Introspection.GetType(value)
		    Dim method As Introspection.MethodInfo= ti.GetMethodToString
		    If method Is Nil Then
		      ret.Append "#"+ ti.Name
		    Else
		      Dim params() As Variant
		      ret.Append method.Invoke(value, params)
		    End If
		  Next
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToStringEXS(Extends values() As Single) As String()
		  Dim ret() As String
		  
		  For Each value As Single In values
		    ret.Append Str(value)
		  Next
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToStringEXS(Extends values() As Variant) As String()
		  Dim ret() As String
		  
		  For i As Integer= 0 To values.LastIdxEXS
		    ret.Append values(i).StringValue
		  Next
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToStringSymbol(Extends value As EXS.Expressions.Expression.ExpressionType) As String
		  Select Case value
		  Case EXS.Expressions.Expression.ExpressionType.Assign
		    Return " = "
		  Case EXS.Expressions.Expression.ExpressionType.Add
		    Return " + "
		  Case EXS.Expressions.Expression.ExpressionType.Subtract
		    Return " - "
		  Case EXS.Expressions.Expression.ExpressionType.Multiply
		    Return " * "
		  Case EXS.Expressions.Expression.ExpressionType.Divide
		    Return " / "
		  Case EXS.Expressions.Expression.ExpressionType.Modulo
		    Return " % "
		  Case EXS.Expressions.Expression.ExpressionType.Power
		    Return " ^ "
		  Case EXS.Expressions.Expression.ExpressionType.And_
		    Return " & "
		  Case EXS.Expressions.Expression.ExpressionType.Or_
		    Return " | "
		  Case EXS.Expressions.Expression.ExpressionType.ExclusiveOr
		    Return " ¿ "
		  Case EXS.Expressions.Expression.ExpressionType.LeftShift
		    Return " << "
		  Case EXS.Expressions.Expression.ExpressionType.RightShift
		    Return " >> "
		  Case EXS.Expressions.Expression.ExpressionType.ArrayIndex
		    Return "(idx)"
		  Case EXS.Expressions.Expression.ExpressionType.Convert
		    Return " -> "
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToStringVart(Extends value As Variant) As String
		  Const kNull= "#null"
		  Const kUnsupported= "#unsup"
		  Const kFrmtFloats= "-###,###,###,###,###,##0.0#######"
		  
		  If value.IsNull Then
		    Return kNull
		  ElseIf value.IsArray Then
		    Dim ret() As String
		    Select Case value.ArrayElementType
		    Case 2
		      Dim values() As Integer= value
		      ret= values.ToStringEXS
		    Case 3
		      Dim values() As Int64= value
		      ret= values.ToStringEXS
		    Case 4
		      Dim values() As Single= value
		      ret= values.ToStringEXS
		    Case 5
		      Dim values() As Double= value
		      ret= values.ToStringEXS
		    Case 6
		      Dim values() As Currency= value
		      ret= values.ToStringEXS
		    Case 7
		      Dim values() As Date= value
		      ret= values.ToStringEXS
		    Case 8
		      ret= value
		    Case 9 // TODO: not working! maybe validate before
		      Try
		        #pragma BreakOnExceptions Off
		        Dim values() As Variant= value
		        ret= values.ToStringEXS
		        #pragma BreakOnExceptions Default
		      Catch exc As RuntimeException
		        System.DebugLog CurrentMethodName+ " exc: "+ Introspection.GetType(exc).Name
		        ret.Append kUnsupported
		      End Try
		    Case 11
		      Dim values() As Boolean= value
		      ret= values.ToStringEXS
		    Case Else
		      ret.Append kUnsupported
		    End Select
		    
		    Return "["+ Join(ret, ",")+ "]"
		  ElseIf value.Type= 9 Then
		    Dim obj As Object= value
		    Dim ti As Introspection.TypeInfo= Introspection.GetType(obj)
		    Dim method As Introspection.MethodInfo= ti.GetMethodToString
		    If method Is Nil Then
		      Return "#"+ ti.Name
		    Else
		      Dim params() As Variant
		      Return method.Invoke(value, params)
		    End If
		  Else
		    Select Case value.Type
		    Case 2, 3, 11, 16
		      Return value.StringValue
		    Case 4, 5, 6
		      Return Str(value.DoubleValue, kFrmtFloats)
		    Case 8
		      Return """"+ value.StringValue+ """"
		    End Select
		    Return kUnsupported
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToTypeInfo(Extends values() As Variant) As Introspection.TypeInfo()
		  Dim ret() As Introspection.TypeInfo
		  
		  For i As Integer= 0 To values.LastIdxEXS
		    ret.Append Introspection.TypeInfo(values(i))
		  Next
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToTypeInfo(Extends value As Variant) As Introspection.TypeInfo
		  Dim ttype As Integer= value.Type
		  Select Case ttype
		  Case 0 // Nil
		    Return Nil
		  Case 2
		    Return GetType("Integer")
		  Case 3
		    Return GetType("Int64")
		  Case 4
		    Return GetType("Single")
		  Case 5
		    Return GetType("Double")
		  Case 6
		    Return GetType("Currency")
		  Case 7
		    Return GetType("Date")
		  Case 8
		    Return GetType("String")
		  Case 9
		    Dim obj As Object= value
		    Return Introspection.GetType(obj)
		  Case 11
		    Return GetType("Boolean")
		  Case 16
		    Return GetType("Color")
		  Case 18, 19, 20, 21, 22, 23, 36 // CString, WString, PString...
		    Break
		  Case 26
		    Return GetType("Ptr")
		  Case 38 // DateTime
		    Break
		    Return GetType("DateTime")
		  Case Else
		    If value.IsArray Then // array
		      Dim ttypea As Integer= value.ArrayElementType
		      Select Case ttypea
		      Case 2
		        Return GetType("Int32()")
		      Case 3
		        Return GetType("Int64()")
		      Case 4
		        Return GetType("Single()")
		      Case 5
		        Return GetType("Double()")
		      Case 6
		        Return GetType("Currency()")
		      Case 7
		        Return GetType("Date()")
		      Case 8
		        Return GetType("String()")
		      Case 9
		        Return GetType("Object()")
		      Case 11
		        Return GetType("Boolean()")
		      Case 16
		        Return GetType("Color()")
		      Case 26
		        Return GetType("Ptr()")
		      Case 38 // DateTime
		        Break
		        Return GetType("DateTime()")
		      End Select
		    Else
		      Break
		    End If
		  End Select
		End Function
	#tag EndMethod


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
End Module
#tag EndModule
