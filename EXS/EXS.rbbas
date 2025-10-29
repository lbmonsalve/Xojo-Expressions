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
		Function GetVUInt64(value As UInt64) As MemoryBlock
		  Dim mValue As MemoryBlock
		  
		  If value<= &h7F Then // 1Byte
		    mValue= New MemoryBlock(1)
		    mValue.LittleEndian= False
		    mValue.UInt8Value(0)= value Or kSize1Byte
		  ElseIf value<= &h3FFF Then // 2Byte
		    mValue= New MemoryBlock(2)
		    mValue.LittleEndian= False
		    mValue.UInt16Value(0)= value
		    mValue.UInt8Value(0)= mValue.UInt8Value(0) Or kSize2Byte
		  ElseIf value<= &h1FFFFF Then // 3Byte
		    Dim mb As New MemoryBlock(4)
		    mb.LittleEndian= False
		    mb.UInt32Value(0)= value
		    
		    mValue= New MemoryBlock(3)
		    mValue.LittleEndian= False
		    mValue.StringValue(0, 3)= mb.StringValue(1, 3)
		    mValue.UInt8Value(0)= mValue.UInt8Value(0) Or kSize3Byte
		  ElseIf value<= &hFFFFFFF Then // 4Byte
		    mValue= New MemoryBlock(4)
		    mValue.LittleEndian= False
		    mValue.UInt32Value(0)= value
		    mValue.UInt8Value(0)= mValue.UInt8Value(0) Or kSize4Byte
		  ElseIf value<= &h7FFFFFFFF Then // 5Byte
		    Dim mb As New MemoryBlock(8)
		    mb.LittleEndian= False
		    mb.UInt64Value(0)= value
		    
		    mValue= New MemoryBlock(5)
		    mValue.LittleEndian= False
		    mValue.StringValue(0, 5)= mb.StringValue(3, 5)
		    mValue.UInt8Value(0)= mValue.UInt8Value(0) Or kSize5Byte
		  ElseIf value<= &h3FFFFFFFFFF Then // 6Byte
		    Dim mb As New MemoryBlock(8)
		    mb.LittleEndian= False
		    mb.UInt64Value(0)= value
		    
		    mValue= New MemoryBlock(6)
		    mValue.LittleEndian= False
		    mValue.StringValue(0, 6)= mb.StringValue(2, 6)
		    mValue.UInt8Value(0)= mValue.UInt8Value(0) Or kSize6Byte
		  ElseIf value<= &h1FFFFFFFFFFFF Then // 7Byte
		    Dim mb As New MemoryBlock(8)
		    mb.LittleEndian= False
		    mb.UInt64Value(0)= value
		    
		    mValue= New MemoryBlock(7)
		    mValue.LittleEndian= False
		    mValue.StringValue(0, 7)= mb.StringValue(1, 7)
		    mValue.UInt8Value(0)= mValue.UInt8Value(0) Or kSize7Byte
		  ElseIf value<= &hFFFFFFFFFFFFFF Then // 8Byte
		    mValue= New MemoryBlock(8)
		    mValue.LittleEndian= False
		    mValue.UInt64Value(0)= value
		    mValue.UInt8Value(0)= mValue.UInt8Value(0) Or kSize8Byte
		  Else
		    mValue= New MemoryBlock(9)
		    mValue.LittleEndian= False
		    mValue.UInt8Value(0)= 0
		    mValue.UInt64Value(1)= value
		    'Raise GetRuntimeExc("can't encode vint value")
		  End If
		  
		  Return mValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetVUInt64Size(value As UInt8) As UInt8
		  If (value And kSize1Byte)= kSize1Byte Then
		    Return 1
		  ElseIf (value And kSize2Byte)= kSize2Byte Then
		    Return 2
		  ElseIf (value And kSize3Byte)= kSize3Byte Then
		    Return 3
		  ElseIf (value And kSize4Byte)= kSize4Byte Then
		    Return 4
		  ElseIf (value And kSize5Byte)= kSize5Byte Then
		    Return 5
		  ElseIf (value And kSize6Byte)= kSize6Byte Then
		    Return 6
		  ElseIf (value And kSize7Byte)= kSize7Byte Then
		    Return 7
		  ElseIf (value And kSize8Byte)= kSize8Byte Then
		    Return 8
		  ElseIf value= 0 Then
		    Return 9
		  Else
		    Raise GetRuntimeExc("invalid vint size")
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetVUInt64Value(value As String) As UInt64
		  Dim ret As UInt64
		  Dim mValue As MemoryBlock= value
		  
		  If mValue.Size= 1 Then
		    Dim mb As New MemoryBlock(1)
		    mb.LittleEndian= False
		    mb.StringValue(0, mb.Size)= mValue.StringValue(0, mb.Size)
		    mb.UInt8Value(0)= mb.UInt8Value(0) And &b01111111
		    ret= mb.UInt8Value(0)
		  ElseIf mValue.Size= 2 Then
		    Dim mb As New MemoryBlock(2)
		    mb.LittleEndian= False
		    mb.StringValue(0, mb.Size)= mValue.StringValue(0, mb.Size)
		    mb.UInt8Value(0)= mb.UInt8Value(0) And &b00111111
		    ret= mb.UInt16Value(0)
		  ElseIf mValue.Size= 3 Then
		    Dim mb As New MemoryBlock(4)
		    mb.LittleEndian= False
		    mb.StringValue(1, 3)= mValue.StringValue(0, 3)
		    mb.UInt8Value(1)= mb.UInt8Value(1) And &b00011111
		    ret= mb.UInt32Value(0)
		  ElseIf mValue.Size= 4 Then
		    Dim mb As New MemoryBlock(4)
		    mb.LittleEndian= False
		    mb.StringValue(0, mb.Size)= mValue.StringValue(0, mb.Size)
		    mb.UInt8Value(0)= mb.UInt8Value(0) And &b00001111
		    ret= mb.UInt32Value(0)
		  ElseIf mValue.Size= 5 Then
		    Dim mb As New MemoryBlock(8)
		    mb.LittleEndian= False
		    mb.StringValue(3, 5)= mValue.StringValue(0, 5)
		    mb.UInt8Value(3)= mb.UInt8Value(3) And &b00000111
		    ret= mb.UInt64Value(0)
		  ElseIf mValue.Size= 6 Then
		    Dim mb As New MemoryBlock(8)
		    mb.LittleEndian= False
		    mb.StringValue(2, 6)= mValue.StringValue(0, 6)
		    mb.UInt8Value(2)= mb.UInt8Value(2) And &b00000011
		    ret= mb.UInt64Value(0)
		  ElseIf mValue.Size= 7 Then
		    Dim mb As New MemoryBlock(8)
		    mb.LittleEndian= False
		    mb.StringValue(1, 7)= mValue.StringValue(0, 7)
		    mb.UInt8Value(1)= mb.UInt8Value(1) And &b00000001
		    ret= mb.UInt64Value(0)
		  ElseIf mValue.Size= 8 Then
		    Dim mb As New MemoryBlock(8)
		    mb.LittleEndian= False
		    mb.StringValue(0, mb.Size)= mValue.StringValue(0, mb.Size)
		    mb.UInt8Value(0)= mb.UInt8Value(0) And &b00000000
		    ret= mb.UInt64Value(0)
		  ElseIf mValue.Size= 9 Then
		    mValue.LittleEndian= False
		    ret= mValue.UInt64Value(1)
		  Else
		    Raise GetRuntimeExc("can't decode vint value")
		  End If
		  
		  Return ret
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

	#tag Method, Flags = &h21
		Private Function OpCodesAsString(code As Integer) As String
		  Select Case code
		  Case &h00
		    Return "Nop"
		  Case &h01
		    Return "Load"
		  Case &h02
		    Return "LoadParam"
		  Case &h03
		    Return "Store"
		  Case &h04
		    Return "StoreParam"
		  Case &h05
		    Return "Call"
		  Case &h06
		    Return "CallVirt"
		  Case &h07
		    Return "Ret"
		  Case &h08
		    Return "RetParam"
		  Case &h09
		    Return "Add"
		  Case &h0A
		    Return "Subtract"
		  Case &h0B
		    Return "Multiply"
		  Case &h0C
		    Return "Divide"
		  Case &h0D
		    Return "Modulo"
		  Case &h0E
		    Return "Power"
		    
		  Case &h10
		    Return "And"
		  Case &h11
		    Return "Or"
		  Case &h12
		    Return "ExclusiveOr"
		  Case &h13
		    Return "LeftShift"
		  Case &h14
		    Return "RightShift"
		  Case &h15
		    Return "Jump"
		  Case &h16
		    Return "JumpTrue"
		  Case &h17
		    Return "JumpFalse"
		  Case &h18
		    Return "JumpEqual"
		  Case &h19
		    Return "JumpGreater"
		  Case &h1A
		    Return "JumpGreaterOrEqual"
		  Case &h1B
		    Return "JumpLess"
		  Case &h1C
		    Return "JumpLessOrEqual"
		  Case &h1D
		    Return "Convert"
		    
		  Case Else
		    Raise GetRuntimeExc("cant decode ""OpCodes""")
		  End Select
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
		Function ToInstructionCode(Extends value As EXS.ExpressionType) As EXS.OpCodes
		  Select Case value
		  Case EXS.ExpressionType.Add
		    Return OpCodes.Add
		  Case EXS.ExpressionType.Subtract
		    Return OpCodes.Subtract
		  Case EXS.ExpressionType.Multiply
		    Return OpCodes.Multiply
		  Case EXS.ExpressionType.Divide
		    Return OpCodes.Divide
		  Case EXS.ExpressionType.Modulo
		    Return OpCodes.Modulo
		  Case EXS.ExpressionType.Power
		    Return OpCodes.Power
		  Case EXS.ExpressionType.And_
		    Return OpCodes.And_
		  Case EXS.ExpressionType.Or_
		    Return OpCodes.Or_
		  Case EXS.ExpressionType.ExclusiveOr
		    Return OpCodes.ExclusiveOr
		  Case EXS.ExpressionType.LeftShift
		    Return OpCodes.LeftShift
		  Case EXS.ExpressionType.RightShift
		    Return OpCodes.RightShift
		  Case EXS.ExpressionType.Convert
		    Return OpCodes.Convert
		  Case Else
		    Raise GetRuntimeExc("ExpressionType not implemented!")
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToInteger(Extends value As EXS.OpCodes) As Integer
		  Return Integer(value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToOpCodes(value As Integer) As OpCodes
		  Select Case value
		  Case &h00
		    Return OpCodes.Nop
		  Case &h01
		    Return OpCodes.Load
		  Case &h02
		    Return OpCodes.LoadParam
		  Case &h03
		    Return OpCodes.Store
		  Case &h04
		    Return OpCodes.StoreParam
		  Case &h05
		    Return OpCodes.Call_
		  Case &h06
		    Return OpCodes.CallVirt
		  Case &h07
		    Return OpCodes.Ret
		  Case &h08
		    Return OpCodes.RetParam
		  Case &h09
		    Return OpCodes.Add
		  Case &h0A
		    Return OpCodes.Subtract
		  Case &h0B
		    Return OpCodes.Multiply
		  Case &h0C
		    Return OpCodes.Divide
		  Case &h0D
		    Return OpCodes.Modulo
		  Case &h0E
		    Return OpCodes.Power
		    
		  Case &h10
		    Return OpCodes.And_
		  Case &h11
		    Return OpCodes.Or_
		  Case &h12
		    Return OpCodes.ExclusiveOr
		  Case &h13
		    Return OpCodes.LeftShift
		  Case &h14
		    Return OpCodes.RightShift
		  Case &h15
		    Return OpCodes.Jump
		  Case &h16
		    Return OpCodes.JumpTrue
		  Case &h17
		    Return OpCodes.JumpFalse
		  Case &h18
		    Return OpCodes.JumpEqual
		  Case &h19
		    Return OpCodes.JumpGreater
		  Case &h1A
		    Return OpCodes.JumpGreaterOrEqual
		  Case &h1B
		    Return OpCodes.JumpLess
		  Case &h1C
		    Return OpCodes.JumpLessOrEqual
		  Case &h1D
		    Return OpCodes.Convert
		    
		  Case Else
		    Raise GetRuntimeExc("can't convert value to ""OpCodes""")
		  End Select
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
		Function ToStringSymbol(Extends value As EXS.ExpressionType) As String
		  Select Case value
		  Case EXS.ExpressionType.Assign
		    Return " = "
		  Case EXS.ExpressionType.Add
		    Return " + "
		  Case EXS.ExpressionType.Subtract
		    Return " - "
		  Case EXS.ExpressionType.Multiply
		    Return " * "
		  Case EXS.ExpressionType.Divide
		    Return " / "
		  Case EXS.ExpressionType.Modulo
		    Return " % "
		  Case EXS.ExpressionType.Power
		    Return " ^ "
		  Case EXS.ExpressionType.And_
		    Return " & "
		  Case EXS.ExpressionType.Or_
		    Return " | "
		  Case EXS.ExpressionType.ExclusiveOr
		    Return " ¿ "
		  Case EXS.ExpressionType.LeftShift
		    Return " << "
		  Case EXS.ExpressionType.RightShift
		    Return " >> "
		  Case EXS.ExpressionType.ArrayIndex
		    Return "(idx)"
		  Case EXS.ExpressionType.Convert
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


	#tag Constant, Name = kSize1Byte, Type = Double, Dynamic = False, Default = \"&b10000000", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSize2Byte, Type = Double, Dynamic = False, Default = \"&b01000000", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSize3Byte, Type = Double, Dynamic = False, Default = \"&b00100000", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSize4Byte, Type = Double, Dynamic = False, Default = \"&b00010000", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSize5Byte, Type = Double, Dynamic = False, Default = \"&b00001000", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSize6Byte, Type = Double, Dynamic = False, Default = \"&b00000100", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSize7Byte, Type = Double, Dynamic = False, Default = \"&b00000010", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSize8Byte, Type = Double, Dynamic = False, Default = \"&b00000001", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kStreamMagicHeader, Type = Double, Dynamic = False, Default = \"&hBEBECAFE", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kStreamMinSize, Type = Double, Dynamic = False, Default = \"12", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kVersionMayor, Type = Double, Dynamic = False, Default = \"0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kVersionMinor, Type = Double, Dynamic = False, Default = \"0", Scope = Private
	#tag EndConstant


	#tag Enum, Name = ExpressionType, Flags = &h0
		Add = 0
		  AddChecked = 1
		  And_ = 2
		  AndAlso = 3
		  ArrayLength = 4
		  ArrayIndex = 5
		  Call_ = 6
		  Coalesce = 7
		  Conditional = 8
		  Constant = 9
		  Convert = 10
		  ConvertChecked = 11
		  Divide = 12
		  Equal = 13
		  ExclusiveOr = 14
		  GreaterThan = 15
		  GreaterThanOrEqual = 16
		  Invoke = 17
		  Lambda = 18
		  LeftShift = 19
		  LessThan = 20
		  LessThanOrEqual = 21
		  ListInit = 22
		  MemberAccess = 23
		  MemberInit = 24
		  Modulo = 25
		  Multiply = 26
		  MultiplyChecked = 27
		  Negate = 28
		  UnaryPlus = 29
		  NegateChecked = 30
		  New_ = 31
		  NewArrayInit = 32
		  NewArrayBounds = 33
		  Not_ = 34
		  NotEqual = 35
		  Or_ = 36
		  OrElse = 37
		  Parameter = 38
		  Power = 39
		  Quote = 40
		  RightShift = 41
		  Subtract = 42
		  SubtractChecked = 43
		  TypeAs = 44
		  TypeIs = 45
		  Assign = 46
		  Block = 47
		  DebugInfo = 48
		  Decrement = 49
		  Dynamic = 50
		  Default = 51
		  Extension = 52
		  Goto_ = 53
		  Increment = 54
		  Index = 55
		  Label = 56
		  RuntimeVariables = 57
		  Loop_ = 58
		  Switch = 59
		  Throw = 60
		  Try_ = 61
		  Unbox = 62
		  AddAssign = 63
		  AndAssign = 64
		  DivideAssign = 65
		  ExclusiveOrAssign = 66
		  LeftShiftAssign = 67
		  ModuloAssign = 68
		  MultiplyAssign = 69
		  OrAssign = 70
		  PowerAssign = 71
		  RightShiftAssign = 72
		  SubtractAssign = 73
		  AddAssignChecked = 74
		  MultiplyAssignChecked = 75
		  SubtractAssignChecked = 76
		  PreIncrementAssign = 77
		  PreDecrementAssign = 78
		  PostIncrementAssign = 79
		  PostDecrementAssign = 80
		  TypeEqual = 81
		  OnesComplement = 82
		  IsTrue = 83
		  IsFalse = 84
		Ret = 85
	#tag EndEnum

	#tag Enum, Name = OpCodes, Flags = &h0
		Nop= &h00
		  Load= &h01
		  LoadParam= &h02
		  Store= &h03
		  StoreParam= &h04
		  Call_= &h05
		  CallVirt= &h06
		  Ret= &h07
		  RetParam= &h08
		  Add= &h09
		  Subtract= &h0A
		  Multiply= &h0B
		  Divide= &h0C
		  Modulo= &h0D
		  Power= &h0E
		  And_= &h10
		  Or_= &h11
		  ExclusiveOr= &h12
		  LeftShift= &h13
		  RightShift= &h14
		  Jump= &h15
		  JumpTrue= &h16
		  JumpFalse= &h17
		  JumpEqual= &h18
		  JumpGreater= &h19
		  JumpGreaterOrEqual= &h1A
		  JumpLess= &h1B
		  JumpLessOrEqual= &h1C
		Convert= &h1D
	#tag EndEnum


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
