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

	#tag Method, Flags = &h21
		Private Function Convert(from As Variant, toType As String) As Variant
		  Select Case toType
		  Case "String"
		    Return from.StringValue
		  Case "Integer"
		    Return from.IntegerValue
		  Case "Int32"
		    Return from.Int32Value
		  Case "Int64"
		    Return from.Int64Value
		  Case "UInt32"
		    Return from.UInt32Value
		  Case "UInt64"
		    Return from.UInt64Value
		  Case "Double"
		    Return from.DoubleValue
		  Case "Boolean"
		    Return from.BooleanValue
		  Case Else
		    Break
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CountEXS(Extends values() As Object) As Integer
		  Return values.LastIdxEXS+ 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function EncodePrintable(Extends value As String, unPrintable As String = "º") As String
		  Dim result() As String
		  
		  For i As Integer= 1 To value.LenB
		    Dim chr As String= value.MidB(i, 1)
		    Dim achr As Integer= Asc(chr)
		    If achr> 31 And achr< 127 Then
		      result.Append chr
		    Else
		      result.Append unPrintable
		    End If
		  Next
		  
		  Return Join(result, "")
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

	#tag Method, Flags = &h21
		Private Function GetFlags() As UInt64
		  //Dim flags As UInt8= &b01111110 Or &b00000001
		  //Return flags
		  
		  Return 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetLastExpression(Extends block As EXS.Expressions.BlockExpression) As EXS.Expressions.Expression
		  Dim exprs() As EXS.Expressions.Expression= block.Expressions
		  Dim expr As EXS.Expressions.Expression= exprs(exprs.LastIdxEXS)
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

	#tag Method, Flags = &h21
		Private Function GetVariantValue(vartType As String, vartValue As MemoryBlock) As Variant
		  Dim ret As Variant
		  
		  Select Case vartType
		  Case "Int8", "Uint8"
		    If vartValue.Size= 1 Then ret= vartValue.UInt8Value(0)
		  Case "Int16", "Uint16"
		    If vartValue.Size= 2 Then ret= vartValue.UInt16Value(0)
		  Case "Int32", "Uint32", "Integer", "UInteger"
		    If vartValue.Size= 4 Then ret= vartValue.UInt32Value(0)
		  Case "Int64", "Uint64"
		    If vartValue.Size= 8 Then ret= vartValue.UInt64Value(0)
		  Case "Currency"
		    If vartValue.Size= 4 Then ret= vartValue.CurrencyValue(0)
		  Case "Single"
		    If vartValue.Size= 4 Then ret= vartValue.SingleValue(0)
		  Case "Doble"
		    If vartValue.Size= 8 Then ret= vartValue.DoubleValue(0)
		  Case "String", "Variant"
		    ret= vartValue.StringValue(0, vartValue.Size)
		  Case "Date"
		    Break
		  Case "DateTime"
		    Break
		  Case "Color"
		    Break
		  Case "Boolean"
		    If vartValue.Size= 1 Then ret= vartValue.BooleanValue(0)
		  Case Else
		    Raise GetRuntimeExc(vartType+ " not implemented!")
		  End Select
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetVersion() As MemoryBlock
		  Dim mb As New MemoryBlock(3)
		  mb.LittleEndian= False
		  mb.UInt8Value(0)= kVersionMayor
		  mb.UInt16Value(1)= kVersionMinor
		  
		  Return mb
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetVUInt(bs As BinaryStream) As UInt64
		  Dim sizeByte As UInt8= GetVUInt64Size(bs.ReadUInt8)
		  bs.Position= bs.Position- 1
		  
		  Return GetVUInt64Value(bs.Read(sizeByte))
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
		  If value.Name= "String" Then Return True
		  
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
		  If body IsA EXS.Expressions.ConditionalExpression Then Return True
		  If body IsA EXS.Expressions.ParameterExpression Then Return True
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
		Function LastIdxEXS(Extends values() As EXS.Expressions.Expression) As Integer
		  Return values.Ubound
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LastIdxEXS(Extends values() As EXS.Expressions.Local) As Integer
		  Return values.Ubound
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LastIdxEXS(Extends values() As EXS.Expressions.ParameterExpression) As Integer
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
		Function LastIdxEXS(Extends values() As String) As Integer
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
		  If values.LastIdxEXS= -1 And varts Is Nil Then Return True
		  If values.LastIdxEXS= -1 And varts.LastIdxEXS= -1 Then Return True
		  If values.LastIdxEXS<> varts.LastIdxEXS Then Return False
		  
		  For i As Integer= 0 To values.LastIdxEXS
		    Dim valueType As Introspection.TypeInfo= values(i).Type
		    Dim vartType As Introspection.TypeInfo= varts(i).ToTypeInfo
		    If Not valueType.IsAssignable(vartType) Then Return False
		  Next
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OpCodesToString(Extends code As UInt8) As String
		  Select Case code
		  Case &h00
		    Return "Nop"
		    
		  Case &h01
		    Return "Load"
		  Case &h02
		    Return "Store"
		  Case &h03
		    Return "Local"
		  Case &h04
		    Return "Call"
		  Case &h05
		    Return "Pop"
		    
		  Case &h06
		    Return "Negate"
		  Case &h07
		    Return "Equal"
		  Case &h08
		    Return "Greater"
		  Case &h09
		    Return "Less"
		    
		  Case &h0A
		    Return "And"
		  Case &h0B
		    Return "Or"
		  Case &h0C
		    Return "ExclusiveOr"
		    
		  Case &h0D
		    Return "Add"
		  Case &h0E
		    Return "Subtract"
		  Case &h0F
		    Return "Multiply"
		  Case &h10
		    Return "Divide"
		  Case &h11
		    Return "Modulo"
		  Case &h12
		    Return "Power"
		    
		  Case &h13
		    Return "LeftShift"
		  Case &h14
		    Return "RightShift"
		    
		  Case &h15
		    Return "Convert"
		    
		  Case &h16
		    Return "Jump"
		  Case &h17
		    Return "JumpFalse"
		    
		  Case &h18
		    Return "Ret"
		    
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
		  
		  Register GetTypeInfo(EXS.System), "EXS.System"
		  
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

	#tag Method, Flags = &h1
		Protected Function Repeat(num As Integer, chars As String = " ") As String
		  Dim result() As String
		  
		  For i As Integer= 1 To num
		    result.Append chars
		  Next
		  
		  Return Join(result, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReverseScopeLookup(Extends values() As EXS.Expressions.Local, search As String) As Integer
		  Dim last As Integer= values.LastIdxEXS
		  
		  'For i As Integer= last To 0 Step -1
		  'Dim loc As EXS.Expressions.Local= values(i)
		  'If scope> loc.Scope Then Exit
		  'If loc.Name= search And loc.Scope= scope Then Return i
		  'Next
		  
		  For i As Integer= last To 0 Step -1
		    Dim loc As EXS.Expressions.Local= values(i)
		    If loc.Name= search Then Return i
		  Next
		  
		  Return -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReverseScopeLookupOrAppend(Extends values() As EXS.Expressions.Local, search As String, scope As Integer) As Integer
		  Dim idx As Integer= values.ReverseScopeLookup(search)
		  If idx<> -1 Then Return idx
		  
		  values.Append New EXS.Expressions.Local(search, scope)
		  
		  Return values.LastIdxEXS
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RootType(Extends value As Introspection.TypeInfo) As Introspection.TypeInfo
		  If value.BaseType Is Nil Then Return value
		  
		  Return value.BaseType.RootType
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToInteger(Extends value As EXS.OpCodes) As Integer
		  Return Integer(value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToOpCode(Extends value As EXS.ExpressionType) As EXS.OpCodes
		  Select Case value
		  Case ExpressionType.Add
		    Return OpCodes.Add
		  Case ExpressionType.Subtract
		    Return OpCodes.Subtract
		  Case ExpressionType.Multiply
		    Return OpCodes.Multiply
		  Case ExpressionType.Divide
		    Return OpCodes.Divide
		  Case ExpressionType.Modulo
		    Return OpCodes.Modulo
		  Case ExpressionType.Power
		    Return OpCodes.Power
		    
		  Case ExpressionType.And_
		    Return OpCodes.And_
		  Case ExpressionType.Or_
		    Return OpCodes.Or_
		  Case ExpressionType.ExclusiveOr
		    Return OpCodes.ExclusiveOr
		  Case ExpressionType.LeftShift
		    Return OpCodes.LeftShift
		  Case ExpressionType.RightShift
		    Return OpCodes.RightShift
		  Case ExpressionType.Convert
		    Return OpCodes.Convert
		    
		  Case ExpressionType.Equal
		    Return OpCodes.Equal
		  Case ExpressionType.GreaterThan
		    Return OpCodes.Greater
		  Case ExpressionType.LessThan
		    Return OpCodes.Less
		    
		  Case ExpressionType.Not_
		    Return OpCodes.Not_
		    
		  Case Else
		    Raise GetRuntimeExc("ExpressionType not implemented!")
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToOpCodes(Extends value As UInt8) As OpCodes
		  Select Case value
		  Case &h00
		    Return OpCodes.Nop
		    
		  Case &h01
		    Return OpCodes.Load
		  Case &h02
		    Return OpCodes.Store
		  Case &h03
		    Return OpCodes.Local
		  Case &h04
		    Return OpCodes.Call_
		  Case &h05
		    Return OpCodes.Pop
		    
		  Case &h06
		    Return OpCodes.Not_
		  Case &h07
		    Return OpCodes.Equal
		  Case &h08
		    Return OpCodes.Greater
		  Case &h09
		    Return OpCodes.Less
		    
		  Case &h0A
		    Return OpCodes.And_
		  Case &h0B
		    Return OpCodes.Or_
		  Case &h0C
		    Return OpCodes.ExclusiveOr
		    
		  Case &h0D
		    Return OpCodes.Add
		  Case &h0E
		    Return OpCodes.Subtract
		  Case &h0F
		    Return OpCodes.Multiply
		  Case &h10
		    Return OpCodes.Divide
		  Case &h11
		    Return OpCodes.Modulo
		  Case &h12
		    Return OpCodes.Power
		    
		  Case &h13
		    Return OpCodes.LeftShift
		  Case &h14
		    Return OpCodes.RightShift
		    
		  Case &h15
		    Return OpCodes.Convert
		    
		  Case &h16
		    Return OpCodes.Jump
		  Case &h17
		    Return OpCodes.JumpFalse
		    
		  Case &h18
		    Return OpCodes.Ret
		    
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
		  Case ExpressionType.Assign
		    Return " = "
		  Case ExpressionType.Add
		    Return " + "
		  Case ExpressionType.Subtract
		    Return " - "
		  Case ExpressionType.Multiply
		    Return " * "
		  Case ExpressionType.Divide
		    Return " / "
		  Case ExpressionType.Modulo
		    Return " % "
		  Case ExpressionType.Power
		    Return " ^ "
		  Case ExpressionType.And_
		    Return " & "
		  Case ExpressionType.Or_
		    Return " | "
		  Case ExpressionType.ExclusiveOr
		    Return " ¿ "
		  Case ExpressionType.LeftShift
		    Return " << "
		  Case ExpressionType.RightShift
		    Return " >> "
		  Case ExpressionType.ArrayIndex
		    Return "(idx)"
		  Case ExpressionType.Convert
		    Return " -> "
		  Case ExpressionType.Equal
		    Return " == "
		  Case ExpressionType.NotEqual
		    Return " <> "
		  Case ExpressionType.LessThan
		    Return " < "
		  Case ExpressionType.LessThanOrEqual
		    Return " <= "
		  Case ExpressionType.GreaterThan
		    Return " > "
		  Case ExpressionType.GreaterThanOrEqual
		    Return " >= "
		  Case ExpressionType.While_
		    Return " while "
		  Case ExpressionType.Not_
		    Return "Not "
		  Case Else
		    Break
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
		Function ToSymbolType(Extends value As Integer) As SymbolType
		  Select Case value
		  Case 0
		    Return SymbolType.I8
		  Case 1
		    Return SymbolType.U8
		  Case 2
		    Return SymbolType.I16
		  Case 3
		    Return SymbolType.U16
		  Case 4
		    Return SymbolType.I32
		  Case 5
		    Return SymbolType.U32
		  Case 6
		    Return SymbolType.I64
		  Case 7
		    Return SymbolType.U64
		  Case 10
		    Return SymbolType.Float
		  Case 11
		    Return SymbolType.Double
		  Case 12
		    Return SymbolType.Bool
		  Case 13
		    Return SymbolType.String
		  Case 14
		    Return SymbolType.Method
		  Case 15
		    Return SymbolType.Parameter
		    
		  Case Else
		    Raise GetRuntimeExc("can't convert value to ""SymbolType""")
		  End Select
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

	#tag Method, Flags = &h1
		Protected Function Version() As String
		  Return Str(kVersionMayor)+ "."+ Str(kVersionMinor)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteLn(Extends value As Writeable, s As String)
		  value.Write s+ EndOfLine.UNIX
		End Sub
	#tag EndMethod


	#tag Note, Name = Readme
		
		# Xojo-Expressions
		Implementation of [MS lambda expression.]
		(https://learn.microsoft.com/es-es/dotnet/api/system.linq.expressions)  
		
		code expressions to be represented as objects in the form of expression trees.
	#tag EndNote


	#tag Constant, Name = kFidx, Type = String, Dynamic = False, Default = \"\\[#\\]\\ ", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kFoff, Type = String, Dynamic = False, Default = \"00000", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kFtyp, Type = String, Dynamic = False, Default = \"(0#)\\ ", Scope = Private
	#tag EndConstant

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

	#tag Constant, Name = kStreamMinSize, Type = Double, Dynamic = False, Default = \"10", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kVersionMayor, Type = Double, Dynamic = False, Default = \"0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kVersionMinor, Type = Double, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant


	#tag Enum, Name = ExpressionType, Flags = &h0
		Add
		  And_
		  ArrayIndex
		  Call_
		  Conditional
		  Constant
		  Convert
		  Divide
		  Equal
		  ExclusiveOr
		  GreaterThan
		  GreaterThanOrEqual
		  Lambda
		  LeftShift
		  LessThan
		  LessThanOrEqual
		  Modulo
		  Multiply
		  UnaryPlus
		  New_
		  Not_
		  NotEqual
		  Or_
		  OrElse
		  Parameter
		  Power
		  RightShift
		  Subtract
		  Assign
		  Block
		  DebugInfo
		  Decrement
		  Dynamic
		  Default
		  Increment
		  Index
		  Loop_
		  Switch
		  Throw
		  Try_
		  Unbox
		  AddAssign
		  AndAssign
		  DivideAssign
		  ExclusiveOrAssign
		  LeftShiftAssign
		  ModuloAssign
		  MultiplyAssign
		  OrAssign
		  PowerAssign
		  RightShiftAssign
		  SubtractAssign
		  PreIncrementAssign
		  PreDecrementAssign
		  PostIncrementAssign
		  PostDecrementAssign
		  TypeEqual
		  OnesComplement
		  IsTrue
		  IsFalse
		  Ret
		While_
	#tag EndEnum

	#tag Enum, Name = OpCodes, Flags = &h0
		Nop= &h00
		  Load= &h01
		  Store= &h02
		  Local= &h03
		  Call_= &h04
		  Pop= &h05
		  Not_= &h06
		  Equal= &h07
		  Greater= &h08
		  Less= &h09
		  And_= &h0A
		  Or_= &h0B
		  ExclusiveOr= &h0C
		  Add= &h0D
		  Subtract= &h0E
		  Multiply= &h0F
		  Divide= &h10
		  Modulo= &h11
		  Power= &h12
		  LeftShift= &h13
		  RightShift= &h14
		  Convert= &h15
		  Jump= &h16
		  JumpFalse= &h17
		Ret= &h18
	#tag EndEnum

	#tag Enum, Name = SymbolType, Type = Integer, Flags = &h0
		I8
		  U8
		  I16
		  U16
		  I32
		  U32
		  I64
		  U64
		  Float= 10
		  Double= 11
		  Bool= 12
		  String= 13
		  Method= 14
		Parameter= 15
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
