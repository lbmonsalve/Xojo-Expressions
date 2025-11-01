#tag Class
Protected Class LambdaCompiler
Implements ILambdaCompiler,ILambdaCompilerFriend
	#tag Method, Flags = &h0
		Sub Constructor(file As FolderItem, Optional loading As LoadingAction)
		  mLoading= loading
		  
		  If file Is Nil Then Raise GetRuntimeExc("file Is Nil")
		  
		  Dim bs As BinaryStream= BinaryStream.Open(file)
		  bs.LittleEndian= False
		  If bs.Length< kStreamMinSize Then Raise GetRuntimeExc("bs.Length< kStreamMinSize")
		  
		  Dim magic As UInt32= bs.ReadUInt32
		  If magic<> kStreamMagicHeader Then Raise GetRuntimeExc("magic<> 0xBEBECAFE")
		  
		  Dim versionMajor As UInt8= bs.ReadUInt8 // semver 2.0
		  If versionMajor> kVersionMayor Then Raise GetRuntimeExc("versionMajor> kVersionMayor")
		  Dim versionMinor As UInt16= bs.ReadUInt16
		  If versionMinor> kVersionMinor Then Raise GetRuntimeExc("versionMinor> kVersionMinor")
		  
		  Dim sizeByte As UInt8= GetVUInt64Size(bs.ReadUInt8)
		  bs.Position= bs.Position- 1
		  Dim flags As UInt64= GetVUInt64Value(bs.Read(sizeByte))
		  
		  Dim instructionsPosition As UInt32= bs.ReadUInt16
		  
		  If Not (mLoading Is Nil) Then // RaiseEvent Loading
		    If mLoading.Invoke(versionMajor, versionMinor, flags) Then Return
		  End If
		  
		  bs.Position= 0
		  mHeaderMB= bs.Read(instructionsPosition)
		  mHeaderMB.LittleEndian= False
		  mHeaderBS= New BinaryStream(mHeaderMB)
		  mHeaderBS.LittleEndian= False
		  
		  mInstructionsMB= bs.Read(bs.Length- instructionsPosition)
		  mInstructionsMB.LittleEndian= False
		  mInstructionsBS= New BinaryStream(mInstructionsMB)
		  mInstructionsBS.LittleEndian= False
		  
		  mHeaderCache= New Dictionary
		  mLoaded= True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(lambda As LambdaExpression)
		  mLambda= lambda
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DefineLabel() As LabelMark
		  mLabelCounter= mLabelCounter+ 1
		  
		  Dim lbl As LabelMark
		  lbl.Id= mLabelCounter
		  
		  Return lbl
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EmitCode(code As UInt8)
		  mInstructionsBS.WriteUInt8 code
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EmitCode(code As UInt8, argsCount As UInt8)
		  EmitCode code
		  EmitCode argsCount
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EmitExpr(expr As Expression, begin As LabelMark, after As LabelMark)
		  InvokeMethod expr, begin, after
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EmitExpression(expr As AssignBinaryExpression, begin As LabelMark, after As LabelMark)
		  Dim icode As OpCodes
		  If expr.Right IsA ConstantExpression Then
		    icode= OpCodes.Store
		    // emit opCode+ right+ left+ scope
		    EmitCode icode.ToInteger
		    EmitExpr expr.Right, begin, after
		    EmitExpr expr.Left, begin, after
		    EmitValue mScopeIndex
		  ElseIf expr.Right IsA ParameterExpression Then
		    icode= OpCodes.StoreParam
		    // emit opCode+ right+ left+ scope
		    EmitCode icode.ToInteger
		    EmitExpr expr.Right, begin, after
		    EmitExpr expr.Left, begin, after
		    EmitValue mScopeIndex
		  Else
		    Break
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EmitExpression(expr As BlockExpression, begin As LabelMark, after As LabelMark)
		  Dim expressions() As Expression= expr.Expressions
		  
		  ScopeIni
		  MarkLabel begin
		  For i As Integer= 0 To expressions.LastIdx
		    Dim currExpr As Expression= expressions(i)
		    Dim beginBlock As LabelMark= DefineLabel, afterBlock As LabelMark= DefineLabel
		    EmitExpr currExpr, beginBlock, afterBlock
		  Next
		  MarkLabel after
		  ScopeEnd
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EmitExpression(expr As ConditionalExpression, begin As LabelMark, after As LabelMark)
		  If expr.Test IsA ConstantExpression _
		    And (expr.IfTrue IsA ConstantExpression Or expr.IfTrue IsA ParameterExpression) _
		    And (expr.IfFalse IsA ConstantExpression Or expr.IfFalse IsA ParameterExpression) Then
		    Dim testValue As Boolean= ConstantExpression(expr.Test).Value.BooleanValue
		    If testValue Then
		      EmitExpr expr.IfTrue, begin, after
		    Else
		      EmitExpr expr.IfFalse, begin, after
		    End If
		  ElseIf expr.Test IsA ParameterExpression Then
		    Dim icode As OpCodes
		    Dim local As UInt16= ScopeDeclareLocal
		    
		    EmitLocal local, ParameterExpression(expr.Test)
		    
		    // emit jumpTrue local "labelTrue"
		    icode= OpCodes.JumpTrue
		    EmitCode icode.ToInteger
		    EmitValue local
		    Dim labelTrue As UInt64= EmitLabel(0) // to update
		    
		    EmitExpr expr.IfFalse, begin, after // Emit ifFalse
		    
		    // emit jump "labelEnd"
		    icode= OpCodes.Jump
		    EmitCode icode.ToInteger
		    Dim labelEnd As UInt64= EmitLabel(0) // to update
		    
		    Const kLabelSize= 2
		    // update labelTrue address
		    mInstructionsMB.Int16Value(labelTrue)= mInstructionsBS.Position- labelTrue- kLabelSize
		    
		    EmitExpr expr.IfTrue, begin, after // Emit ifTrue
		    
		    // update labelEnd address
		    mInstructionsMB.Int16Value(labelEnd)= mInstructionsBS.Position- labelEnd- kLabelSize
		    
		  Else // TODO: evaluate test
		    Break
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EmitExpression(expr As ConstantExpression, begin As LabelMark, after As LabelMark)
		  // store in header
		  Dim constHeaderType As Pair= StoreHeader(expr.Type)
		  Dim constHeader As Pair= StoreHeader(expr)
		  
		  // emit const
		  EmitHeaderAddress constHeaderType.Left.UInt64Value, constHeaderType.Right.UInt64Value
		  EmitHeaderAddress constHeader.Left.UInt64Value, constHeader.Right.UInt64Value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EmitExpression(expr As MethodCallExpression, begin As LabelMark, after As LabelMark)
		  // store in header
		  Dim args() As Expression= expr.Arguments
		  Dim argsHeader() As Pair, argsHeaderType() As Pair
		  For i As Integer= 0 To args.LastIdx
		    Dim arg As Expression= args(i)
		    If arg IsA ConstantExpression Then
		      argsHeaderType.Append StoreHeader(arg.Type)
		      argsHeader.Append StoreHeader(ConstantExpression(arg))
		    ElseIf arg IsA ParameterExpression Then
		      argsHeaderType.Append StoreHeader(expr.Type)
		      argsHeader.Append StoreHeader(ParameterExpression(arg))
		    Else
		      Raise GetRuntimeExc("arg missing type")
		    End If
		  Next
		  // store method in header
		  Dim methodHeader As Pair= StoreHeader(expr.Type.FullName+ ":"+ expr.Method.Name)
		  
		  // emit opCode argumentsCount
		  Dim icode As OpCodes
		  If expr.Obj Is Nil Then icode= OpCodes.Call_ Else icode= OpCodes.CallVirt
		  EmitCode icode.ToInteger, args.CountEXS
		  // emit arguments headerAddress
		  For i As Integer= 0 To argsHeader.LastIdxEXS
		    Dim pa As Pair= argsHeaderType(i)
		    EmitHeaderAddress pa.Left.UInt64Value, pa.Right.UInt64Value
		    pa= argsHeader(i)
		    EmitHeaderAddress pa.Left.UInt64Value, pa.Right.UInt64Value
		  Next
		  // emit method headerAddress
		  EmitHeaderAddress methodHeader.Left.UInt64Value, methodHeader.Right.UInt64Value
		  // emit objetID (not nil) different instruction
		  If icode= OpCodes.CallVirt Then
		    EmitValue GetObjectID(expr.Obj)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EmitExpression(expr As ParameterExpression, begin As LabelMark, after As LabelMark)
		  // store in header
		  Dim paramHeaderType As Pair= StoreHeader(expr.Type)
		  Dim paramHeader As Pair= StoreHeader(expr)
		  
		  // emit param
		  EmitHeaderAddress paramHeaderType.Left.UInt64Value, paramHeaderType.Right.UInt64Value
		  EmitHeaderAddress paramHeader.Left.UInt64Value, paramHeader.Right.UInt64Value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EmitExpression(expr As ReturnExpression, begin As LabelMark, after As LabelMark)
		  Dim icode As OpCodes
		  If expr.Expr IsA ParameterExpression Then
		    icode= OpCodes.RetParam
		  Else
		    icode= OpCodes.Ret
		  End If
		  EmitCode icode.ToInteger
		  EmitExpr expr.Expr, begin, after
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EmitExpression(expr As SimpleBinaryExpression, begin As LabelMark, after As LabelMark)
		  // TODO:
		  'Dim gen As Expression= expr.Gen(Self)
		  'Break
		  
		  
		  // store in header
		  Dim leftHeaderType As Pair= StoreHeader(expr.Left.Type)
		  Dim rightHeaderType As Pair= StoreHeader(expr.Right.Type)
		  Dim leftHeader As Pair, rightHeader As Pair
		  
		  If expr.Left IsA ParameterExpression Then
		    leftHeader= StoreHeader(ParameterExpression(expr.Left))
		  ElseIf expr.Left IsA ConstantExpression Then
		    leftHeader= StoreHeader(ConstantExpression(expr.Left))
		  End If
		  If expr.Right IsA ParameterExpression Then
		    rightHeader= StoreHeader(ParameterExpression(expr.Right))
		  ElseIf expr.Right IsA ConstantExpression Then
		    rightHeader= StoreHeader(ConstantExpression(expr.Right))
		  End If
		  If leftHeader Is Nil Or rightHeader Is Nil Then Raise GetRuntimeExc("leftHeader Is Nil Or rightHeader Is Nil")
		  
		  Dim icode As OpCodes= expr.NodeType.ToInstructionCode
		  
		  // emit opCode left right
		  EmitCode icode.ToInteger
		  EmitHeaderAddress leftHeaderType.Left.UInt64Value, leftHeaderType.Right.UInt64Value
		  EmitHeaderAddress leftHeader.Left.UInt64Value, leftHeader.Right.UInt64Value
		  
		  EmitHeaderAddress rightHeaderType.Left.UInt64Value, rightHeaderType.Right.UInt64Value
		  EmitHeaderAddress rightHeader.Left.UInt64Value, rightHeader.Right.UInt64Value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EmitExpression(expr As UnaryExpression, begin As LabelMark, after As LabelMark)
		  Dim icode As OpCodes= expr.NodeType.ToInstructionCode
		  
		  Select Case icode
		  Case OpCodes.Convert
		    Dim oper As Expression= expr.Operand
		    If oper IsA ParameterExpression Then
		      Break
		      'Dim local As UInt16= ScopeDeclareLocal
		      'EmitLocal local, ParameterExpression(oper)
		    End If
		    
		    EmitCode icode.ToInteger
		    EmitExpr oper, begin, after
		  Case Else
		    Break
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EmitHeaderAddress(pos As UInt64, size As UInt64)
		  mInstructionsBS.Write GetVUInt64(pos)
		  mInstructionsBS.Write GetVUInt64(size)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EmitLabel(address As Int16) As UInt64
		  Dim pos As UInt64= mInstructionsBS.Position
		  
		  mInstructionsBS.WriteInt16 address
		  
		  Return pos
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EmitLambdaBody()
		  If mLambda Is Nil Then Raise GetRuntimeExc("mLambda Is Nil")
		  
		  Init
		  
		  Dim begin As LabelMark= DefineLabel, after As LabelMark= DefineLabel
		  EmitExpr mLambda.Body, begin, after
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EmitLocal(local As UInt16, param As ParameterExpression)
		  // store in header
		  Dim paramHeaderType As Pair= StoreHeader(param.Type)
		  Dim paramHeader As Pair= StoreHeader(param)
		  Dim icode As OpCodes= OpCodes.LoadParam
		  
		  // emit loadParam local param
		  EmitCode icode.ToInteger
		  EmitValue local // "__internal__"+ Str(local)
		  EmitHeaderAddress paramHeaderType.Left.UInt64Value, paramHeaderType.Right.UInt64Value
		  EmitHeaderAddress paramHeader.Left.UInt64Value, paramHeader.Right.UInt64Value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EmitValue(value As UInt64)
		  mInstructionsBS.Write GetVUInt64(value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function GetFlags() As UInt64
		  //Dim flags As UInt8= &b01111110 Or &b00000001
		  //Return flags
		  
		  Return 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function GetMethod(code As Integer) As Introspection.MethodInfo
		  Const kMethodNameSuffix= "Process"
		  Dim methodName As String= kMethodNameSuffix+ OpCodesAsString(code)
		  
		  Static ti As Introspection.TypeInfo
		  If ti Is Nil Then ti= GetTypeInfo(LambdaCompiler)
		  
		  Static methods() As Introspection.MethodInfo
		  If methods.LastIdxEXS= -1 Then
		    Dim methodsSelf() As Introspection.MethodInfo= ti.GetMethods
		    For Each method As Introspection.MethodInfo In methodsSelf
		      If method.Name.Left(7)= kMethodNameSuffix Then methods.Append method
		    Next
		  End If
		  
		  For Each method As Introspection.MethodInfo In methods
		    If method.Name= methodName Then Return method
		  Next
		  
		  Raise GetRuntimeExc(methodName+ " not found!")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetObjectID(expr As Expression) As Integer
		  If Not (expr IsA ConstantExpression) Then Raise GetRuntimeExc("Not (expr IsA ConstantExpression)")
		  
		  Dim key As Variant= ConstantExpression(expr).Value
		  Dim idx As Integer= mObjects.IndexOf(key)
		  
		  If idx= -1 Then // not found
		    mObjects.Append key
		    Return mObjects.LastIdxEXS
		  End If
		  
		  Return idx
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function GetVariantValue(vartType As String, vartValue As MemoryBlock) As Variant
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
		Private Shared Function GetVersion() As MemoryBlock
		  Dim mb As New MemoryBlock(3)
		  mb.LittleEndian= False
		  mb.UInt8Value(0)= kVersionMayor
		  mb.UInt16Value(1)= kVersionMinor
		  
		  Return mb
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Init()
		  // use bigEndian for vint type
		  
		  mHeaderMB= New MemoryBlock(kStreamMinSize) // 12bytes
		  mHeaderMB.LittleEndian= False // bigEndian
		  mHeaderBS= New BinaryStream(mHeaderMB)
		  mHeaderBS.LittleEndian= False // bigEndian
		  
		  mHeaderBS.WriteUInt32 kStreamMagicHeader // 4bytes
		  mHeaderBS.Write GetVersion // 3bytes
		  mHeaderBS.Write GetVUInt64(GetFlags) // 1byte
		  mHeaderFirstInstruction= mHeaderBS.Position
		  mHeaderBS.WriteUInt16 mHeaderBS.Length // address first instruction 2bytes= 10bytes
		  
		  mInstructionsMB= New MemoryBlock(2) // twoBytes -> ret zero
		  mInstructionsMB.LittleEndian= False // bigEndian
		  mInstructionsBS= New BinaryStream(mInstructionsMB)
		  mInstructionsBS.LittleEndian= False // bigEndian
		  
		  mHeaderCache= New Dictionary
		  ReDim mObjects(-1)
		  
		  mScopeIndex= 0
		  mScopeLocalIndex= 0
		  
		  ReDim mScopes(-1)
		  mScopes.Append New Dictionary
		  
		  mParametersValues= New Dictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub InvokeMethod(expr As Expression, begin As LabelMark, after As LabelMark)
		  Dim tiBody As Introspection.TypeInfo= Introspection.GetType(expr)
		  Dim tiSelf As Introspection.TypeInfo= Introspection.GetType(Self)
		  
		  Static methods() As Introspection.MethodInfo
		  If methods.LastIdxEXS= -1 Then // once
		    Dim methodsSelf() As Introspection.MethodInfo= tiSelf.GetMethods
		    For Each method As Introspection.MethodInfo In methodsSelf
		      If method.Name= "EmitExpression" Then methods.Append(method)
		    Next
		  End If
		  
		  For Each method As Introspection.MethodInfo In methods
		    Dim paramsInfo() As Introspection.ParameterInfo= method.GetParameters
		    If paramsInfo(0).ParameterType.Name= tiBody.Name Then
		      Dim params() As Variant
		      params.Append expr
		      params.Append begin
		      params.Append after
		      method.Invoke Self, params
		      Return
		    End If
		  Next
		  
		  Raise GetRuntimeExc(tiBody.Name+ " not implemented!") // should not do this
		End Sub
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Function LoadingAction(majorVersion As UInt8, minorVersion As UInt16, flags As UInt64) As Boolean
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h21
		Private Function LocalValueGet(name As String) As Variant
		  Dim ret As Variant
		  
		  For i As Integer= mScopes.LastIdxEXS To 0 Step -1
		    Dim scopeVars As Dictionary= mScopes(i)
		    If scopeVars.HasKey(name) Then Return scopeVars.Value(name)
		  Next
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub LocalValueSet(scope As UInt16, paramName As String, constValue As Variant)
		  While mScopes.LastIdxEXS< scope
		    mScopes.Append New Dictionary
		  Wend
		  
		  Dim scopeVars As Dictionary= mScopes(scope)
		  scopeVars.Value(paramName)= constValue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub MarkLabel(lbl As LabelMark)
		  'Break
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ParametersChk(values() As Variant)
		  If Self.LambdaBody Is Nil Then Return
		  
		  Dim paramsExpr() As ParameterExpression= Self.LambdaBody.Parameters
		  Dim paramsMatch As Boolean= paramsExpr.MatchTypeWith(values)
		  If Not paramsMatch Then Return
		  
		  For i As Integer= 0 To paramsExpr.LastIdx
		    Dim paramExpr As ParameterExpression= paramsExpr(i)
		    Dim value As Variant= values(i)
		    mParametersValues.Value(paramExpr.Name)= value
		    LocalValueSet 0, "__internal__"+ paramExpr.Name, value
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessAdd()
		  Dim pos As UInt64= ReadVIntValue
		  Dim size As UInt64= ReadVIntValue
		  Dim leftType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim leftValue As MemoryBlock= mHeaderMB.StringValue(pos, size)
		  
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim rightType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim rightValue As MemoryBlock= mHeaderMB.StringValue(pos, size)
		  
		  Dim leftValueStringValue As String= leftValue.StringValue(0, leftValue.Size)
		  Dim localValue As Variant
		  If mParametersValues.HasKey(leftValueStringValue) Then
		    localValue= mParametersValues.Value(leftValueStringValue)
		    localValue= localValue+ GetVariantValue(rightType, rightValue)
		    If mInstructionsBS.EndFileEXS Then // last instruction
		      mRetValue= localValue
		      Return
		    End If
		    mParametersValues.Value(leftValueStringValue)= localValue
		  Else // TODO: try constants values
		    Break
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessAnd()
		  Dim pos As UInt64= ReadVIntValue
		  Dim size As UInt64= ReadVIntValue
		  Dim leftType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim leftValue As MemoryBlock= mHeaderMB.StringValue(pos, size)
		  
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim rightType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim rightValue As MemoryBlock= mHeaderMB.StringValue(pos, size)
		  
		  Dim leftValueStringValue As String= leftValue.StringValue(0, leftValue.Size)
		  Dim localValue As Variant
		  If mParametersValues.HasKey(leftValueStringValue) Then
		    localValue= mParametersValues.Value(leftValueStringValue)
		    localValue= localValue And GetVariantValue(rightType, rightValue)
		    If mInstructionsBS.EndFileEXS Then // last instruction
		      mRetValue= localValue
		      Return
		    End If
		    mParametersValues.Value(leftValueStringValue)= localValue
		  Else // TODO: try constants values
		    Break
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessCall()
		  Dim methodParams() As Variant
		  
		  Dim nArgs As UInt8= mInstructionsBS.ReadUInt8
		  For i As Integer= 1 To nArgs
		    Dim posHeader As UInt64= ReadVIntValue
		    Dim sizeHeader As UInt64= ReadVIntValue
		    Dim methodParamType As String= mHeaderMB.StringValue(posHeader, sizeHeader)
		    posHeader= ReadVIntValue
		    sizeHeader= ReadVIntValue
		    Dim methodParamValue As MemoryBlock= mHeaderMB.StringValue(posHeader, sizeHeader)
		    methodParams.Append GetVariantValue(methodParamType, methodParamValue)
		  Next
		  
		  Dim pos As UInt64= ReadVIntValue
		  Dim size As UInt64= ReadVIntValue
		  Dim objMethodStr As String= mHeaderMB.StringValue(pos, size)
		  Dim objStr As String= NthField(objMethodStr, ":", 1)
		  Dim methodStr As String= NthField(objMethodStr, ":", 2)
		  Dim tiObj As Introspection.TypeInfo= GetType(objStr)
		  If tiObj Is Nil Then Raise GetRuntimeExc("tiObj Is Nil")
		  Dim methodInfo As Introspection.MethodInfo= tiObj.GetMethodInfo(methodStr)
		  If methodInfo Is Nil Then Raise GetRuntimeExc("methodInfo Is Nil")
		  
		  If methodInfo.ReturnType Is Nil Then
		    methodInfo.Invoke Nil, methodParams
		  Else
		    mRetValue= methodInfo.Invoke(Nil, methodParams)
		  End If
		  
		  If mInstructionsBS.EndFileEXS Then
		    Break // todo:
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessConvert()
		  Dim pos As UInt64= ReadVIntValue
		  Dim size As UInt64= ReadVIntValue
		  Dim paramType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim paramName As String= mHeaderMB.StringValue(pos, size)
		  
		  If mParametersValues.HasKey(paramName) Then
		    Dim tempLocal As Variant=  mParametersValues.Value(paramName)
		    LocalValueSet 0, "__internal__"+ paramName, tempLocal
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessDivide()
		  Dim pos As UInt64= ReadVIntValue
		  Dim size As UInt64= ReadVIntValue
		  Dim leftType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim leftValue As MemoryBlock= mHeaderMB.StringValue(pos, size)
		  
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim rightType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim rightValue As MemoryBlock= mHeaderMB.StringValue(pos, size)
		  
		  Dim leftValueStringValue As String= leftValue.StringValue(0, leftValue.Size)
		  Dim localValue As Variant
		  If mParametersValues.HasKey(leftValueStringValue) Then
		    localValue= mParametersValues.Value(leftValueStringValue)
		    localValue= localValue/ GetVariantValue(rightType, rightValue)
		    If mInstructionsBS.EndFileEXS Then // last instruction
		      mRetValue= localValue
		      Return
		    End If
		    mParametersValues.Value(leftValueStringValue)= localValue
		  Else // TODO: try constants values
		    Break
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessExclusiveOr()
		  Dim pos As UInt64= ReadVIntValue
		  Dim size As UInt64= ReadVIntValue
		  Dim leftType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim leftValue As MemoryBlock= mHeaderMB.StringValue(pos, size)
		  
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim rightType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim rightValue As MemoryBlock= mHeaderMB.StringValue(pos, size)
		  
		  Dim leftValueStringValue As String= leftValue.StringValue(0, leftValue.Size)
		  Dim localValue As Variant
		  If mParametersValues.HasKey(leftValueStringValue) Then
		    localValue= mParametersValues.Value(leftValueStringValue)
		    localValue= localValue XOr GetVariantValue(rightType, rightValue)
		    If mInstructionsBS.EndFileEXS Then // last instruction
		      mRetValue= localValue
		      Return
		    End If
		    mParametersValues.Value(leftValueStringValue)= localValue
		  Else // TODO: try constants values
		    Break
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessJump()
		  Dim offset As Int16= ReadJumpAddress
		  mInstructionsBS.Position= mInstructionsBS.Position+ offset
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessJumpTrue()
		  Dim local As UInt64= ReadVIntValue
		  Dim offset As Int16= ReadJumpAddress
		  Dim localValue As Variant= LocalValueGet("__internal__"+ Str(local))
		  
		  If localValue.BooleanValue Then
		    mInstructionsBS.Position= mInstructionsBS.Position+ offset
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessLeftShift()
		  Dim pos As UInt64= ReadVIntValue
		  Dim size As UInt64= ReadVIntValue
		  Dim leftType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim leftValue As MemoryBlock= mHeaderMB.StringValue(pos, size)
		  
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim rightType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim rightValue As MemoryBlock= mHeaderMB.StringValue(pos, size)
		  
		  Dim leftValueStringValue As String= leftValue.StringValue(0, leftValue.Size)
		  Dim localValue As Variant
		  If mParametersValues.HasKey(leftValueStringValue) Then
		    localValue= mParametersValues.Value(leftValueStringValue)
		    localValue= Bitwise.ShiftLeft(localValue.IntegerValue, GetVariantValue(rightType, rightValue).IntegerValue)
		    If mInstructionsBS.EndFileEXS Then // last instruction
		      mRetValue= localValue
		      Return
		    End If
		    mParametersValues.Value(leftValueStringValue)= localValue
		  Else // TODO: try constants values
		    Break
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessLoadParam()
		  Dim local As UInt64= ReadVIntValue
		  
		  Dim pos As UInt64= ReadVIntValue
		  Dim size As UInt64= ReadVIntValue
		  Dim paramType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim paramName As String= mHeaderMB.StringValue(pos, size)
		  
		  If mParametersValues.HasKey(paramName) Then
		    Dim tempLocal As Variant=  mParametersValues.Value(paramName)
		    LocalValueSet 0, "__internal__"+ Str(local), tempLocal
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessModulo()
		  Dim pos As UInt64= ReadVIntValue
		  Dim size As UInt64= ReadVIntValue
		  Dim leftType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim leftValue As MemoryBlock= mHeaderMB.StringValue(pos, size)
		  
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim rightType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim rightValue As MemoryBlock= mHeaderMB.StringValue(pos, size)
		  
		  Dim leftValueStringValue As String= leftValue.StringValue(0, leftValue.Size)
		  Dim localValue As Variant
		  If mParametersValues.HasKey(leftValueStringValue) Then
		    localValue= mParametersValues.Value(leftValueStringValue)
		    localValue= localValue Mod GetVariantValue(rightType, rightValue)
		    If mInstructionsBS.EndFileEXS Then // last instruction
		      mRetValue= localValue
		      Return
		    End If
		    mParametersValues.Value(leftValueStringValue)= localValue
		  Else // TODO: try constants values
		    Break
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessMultiply()
		  Dim pos As UInt64= ReadVIntValue
		  Dim size As UInt64= ReadVIntValue
		  Dim leftType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim leftValue As MemoryBlock= mHeaderMB.StringValue(pos, size)
		  
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim rightType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim rightValue As MemoryBlock= mHeaderMB.StringValue(pos, size)
		  
		  Dim leftValueStringValue As String= leftValue.StringValue(0, leftValue.Size)
		  Dim localValue As Variant
		  If mParametersValues.HasKey(leftValueStringValue) Then
		    localValue= mParametersValues.Value(leftValueStringValue)
		    localValue= localValue* GetVariantValue(rightType, rightValue)
		    If mInstructionsBS.EndFileEXS Then // last instruction
		      mRetValue= localValue
		      Return
		    End If
		    mParametersValues.Value(leftValueStringValue)= localValue
		  Else // TODO: try constants values
		    Break
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessOr()
		  Dim pos As UInt64= ReadVIntValue
		  Dim size As UInt64= ReadVIntValue
		  Dim leftType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim leftValue As MemoryBlock= mHeaderMB.StringValue(pos, size)
		  
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim rightType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim rightValue As MemoryBlock= mHeaderMB.StringValue(pos, size)
		  
		  Dim leftValueStringValue As String= leftValue.StringValue(0, leftValue.Size)
		  Dim localValue As Variant
		  If mParametersValues.HasKey(leftValueStringValue) Then
		    localValue= mParametersValues.Value(leftValueStringValue)
		    localValue= localValue Or GetVariantValue(rightType, rightValue)
		    If mInstructionsBS.EndFileEXS Then // last instruction
		      mRetValue= localValue
		      Return
		    End If
		    mParametersValues.Value(leftValueStringValue)= localValue
		  Else // TODO: try constants values
		    Break
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessPower()
		  Dim pos As UInt64= ReadVIntValue
		  Dim size As UInt64= ReadVIntValue
		  Dim leftType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim leftValue As MemoryBlock= mHeaderMB.StringValue(pos, size)
		  
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim rightType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim rightValue As MemoryBlock= mHeaderMB.StringValue(pos, size)
		  
		  Dim leftValueStringValue As String= leftValue.StringValue(0, leftValue.Size)
		  Dim localValue As Variant
		  If mParametersValues.HasKey(leftValueStringValue) Then
		    localValue= mParametersValues.Value(leftValueStringValue)
		    localValue= localValue.DoubleValue ^ GetVariantValue(rightType, rightValue).DoubleValue
		    If mInstructionsBS.EndFileEXS Then // last instruction
		      mRetValue= localValue
		      Return
		    End If
		    mParametersValues.Value(leftValueStringValue)= localValue
		  Else // TODO: try constants values
		    Break
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessRet()
		  Dim posHeader As UInt64= ReadVIntValue
		  Dim sizeHeader As UInt64= ReadVIntValue
		  Dim objType As String= mHeaderMB.StringValue(posHeader, sizeHeader)
		  posHeader= ReadVIntValue
		  sizeHeader= ReadVIntValue
		  Dim objValue As MemoryBlock= mHeaderMB.StringValue(posHeader, sizeHeader)
		  
		  mRetValue= GetVariantValue(objType, objValue)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessRetParam()
		  Dim posHeader As UInt64= ReadVIntValue
		  Dim sizeHeader As UInt64= ReadVIntValue
		  Dim objType As String= mHeaderMB.StringValue(posHeader, sizeHeader)
		  posHeader= ReadVIntValue
		  sizeHeader= ReadVIntValue
		  Dim objName As String= mHeaderMB.StringValue(posHeader, sizeHeader)
		  
		  mRetValue= LocalValueGet("__internal__"+ objName)
		  If mRetValue.IsNull Then
		    mRetValue= LocalValueGet(objName)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessRightShift()
		  Dim pos As UInt64= ReadVIntValue
		  Dim size As UInt64= ReadVIntValue
		  Dim leftType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim leftValue As MemoryBlock= mHeaderMB.StringValue(pos, size)
		  
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim rightType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim rightValue As MemoryBlock= mHeaderMB.StringValue(pos, size)
		  
		  Dim leftValueStringValue As String= leftValue.StringValue(0, leftValue.Size)
		  Dim localValue As Variant
		  If mParametersValues.HasKey(leftValueStringValue) Then
		    localValue= mParametersValues.Value(leftValueStringValue)
		    localValue= Bitwise.ShiftRight(localValue.IntegerValue, GetVariantValue(rightType, rightValue).IntegerValue)
		    If mInstructionsBS.EndFileEXS Then // last instruction
		      mRetValue= localValue
		      Return
		    End If
		    mParametersValues.Value(leftValueStringValue)= localValue
		  Else // TODO: try constants values
		    Break
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessStore()
		  Dim pos As UInt64= ReadVIntValue
		  Dim size As UInt64= ReadVIntValue
		  Dim constType As String= mHeaderMB.StringValue(pos, size)
		  
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim tempMB As MemoryBlock= mHeaderMB.StringValue(pos, size)
		  Dim constValue As Variant= GetVariantValue(constType, tempMB)
		  
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim paramType As String= mHeaderMB.StringValue(pos, size)
		  
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim paramName As String= mHeaderMB.StringValue(pos, size)
		  
		  If mInstructionsBS.EndFileEXS Then
		    Break // TODO:
		  End If
		  
		  Dim scope As UInt16= ReadVIntValue
		  
		  LocalValueSet scope, paramName, constValue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessStoreParam()
		  Dim pos As UInt64= ReadVIntValue
		  Dim size As UInt64= ReadVIntValue
		  Dim rightType As String= mHeaderMB.StringValue(pos, size)
		  
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim rightName As String= mHeaderMB.StringValue(pos, size)
		  
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim leftType As String= mHeaderMB.StringValue(pos, size)
		  
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim leftName As String= mHeaderMB.StringValue(pos, size)
		  
		  If mInstructionsBS.EndFileEXS Then
		    Break // todo:
		  End If
		  
		  Dim scope As UInt16= ReadVIntValue
		  
		  LocalValueSet scope, leftName, LocalValueGet(rightName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessSubtract()
		  Dim pos As UInt64= ReadVIntValue
		  Dim size As UInt64= ReadVIntValue
		  Dim leftType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim leftValue As MemoryBlock= mHeaderMB.StringValue(pos, size)
		  
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim rightType As String= mHeaderMB.StringValue(pos, size)
		  pos= ReadVIntValue
		  size= ReadVIntValue
		  Dim rightValue As MemoryBlock= mHeaderMB.StringValue(pos, size)
		  
		  Dim leftValueStringValue As String= leftValue.StringValue(0, leftValue.Size)
		  Dim localValue As Variant
		  If mParametersValues.HasKey(leftValueStringValue) Then
		    localValue= mParametersValues.Value(leftValueStringValue)
		    localValue= localValue- GetVariantValue(rightType, rightValue)
		    If mInstructionsBS.EndFileEXS Then // last instruction
		      mRetValue= localValue
		      Return
		    End If
		    mParametersValues.Value(leftValueStringValue)= localValue
		  Else // TODO: try constants values
		    Break
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ReadJumpAddress() As Int32
		  Return mInstructionsBS.ReadInt16
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ReadVIntValue() As UInt64
		  Dim sizeByte As UInt8= GetVUInt64Size(mInstructionsBS.ReadUInt8)
		  mInstructionsBS.Position= mInstructionsBS.Position- 1
		  
		  Return GetVUInt64Value(mInstructionsBS.Read(sizeByte))
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetLabelCounter()
		  mLabelCounter= 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Run(values() As Variant) As Variant
		  If mHeaderBS Is Nil Then Raise GetRuntimeExc("mHeaderBS Is Nil")
		  If mInstructionsBS Is Nil Then Raise GetRuntimeExc("mInstructionsBS Is Nil")
		  
		  ParametersChk values
		  
		  mInstructionsBS.Position= 0
		  While Not mInstructionsBS.EndFileEXS // read instructions
		    Dim method As Introspection.MethodInfo= GetMethod(mInstructionsBS.ReadUInt8)
		    method.Invoke Self
		  Wend
		  
		  Return mRetValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Save(file As FolderItem)
		  If file Is Nil Then Raise GetRuntimeExc("file Is Nil")
		  If mHeaderBS Is Nil Then Raise GetRuntimeExc("mHeaderBS Is Nil")
		  If mInstructionsBS Is Nil Then Raise GetRuntimeExc("mInstructionsBS Is Nil")
		  
		  Dim headerPosition As UInt64= mHeaderBS.Position
		  Dim instructionsPosition As UInt64= mInstructionsBS.Position
		  mHeaderBS.Position= 0
		  mInstructionsBS.Position= 0
		  
		  Dim bs As BinaryStream= BinaryStream.Create(file, True)
		  bs.Write mHeaderBS.Read(mHeaderBS.Length)
		  bs.Write mInstructionsBS.Read(mInstructionsBS.Length)
		  bs.Close
		  
		  mHeaderBS.Position= headerPosition
		  mInstructionsBS.Position= instructionsPosition
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ScopeDeclareLocal()
		  If mScopeLocalIndex= &hFFFF Then Raise GetRuntimeExc("mScopeLocalIndex= &hFFFF")
		  
		  mScopeLocalIndex= mScopeLocalIndex+ 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ScopeDeclareLocal() As UInt16
		  Dim ret As UInt16= mScopeLocalIndex
		  
		  ScopeDeclareLocal
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ScopeEnd()
		  If mScopeIndex= 0 Then Raise GetRuntimeExc("mScopeIndex= 0")
		  
		  mScopeIndex= mScopeIndex- 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ScopeIni()
		  If mScopeIndex= &hFFFF Then Raise GetRuntimeExc("mScopeIndex= &hFFFF")
		  
		  mScopeIndex= mScopeIndex+ 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function StoreHeader(expr As ConstantExpression) As Pair
		  Dim key As MemoryBlock= ToMemoryBlock(expr)
		  If mHeaderCache.HasKey(MD5(key)) Then Return Pair(mHeaderCache.Value(MD5(key)))
		  
		  Dim pos As UInt64= mHeaderBS.Position
		  
		  mHeaderBS.Write key
		  mHeaderMB.UInt16Value(mHeaderFirstInstruction)= mHeaderBS.Length
		  
		  Dim ret As New Pair(pos, key.Size)
		  mHeaderCache.Value(key)= ret
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function StoreHeader(ti As Introspection.TypeInfo) As Pair
		  If mHeaderCache.HasKey(ti) Then Return Pair(mHeaderCache.Value(ti))
		  
		  Dim pos As UInt64= mHeaderBS.Position
		  
		  mHeaderBS.Write ti.FullName
		  mHeaderMB.UInt16Value(mHeaderFirstInstruction)= mHeaderBS.Length
		  
		  Dim ret As New Pair(pos, ti.FullName.LenB)
		  mHeaderCache.Value(ti)= ret
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function StoreHeader(expr As ParameterExpression) As Pair
		  Dim key As String= expr.Name
		  If mHeaderCache.HasKey(key) Then Return Pair(mHeaderCache.Value(key))
		  
		  Dim pos As UInt64= mHeaderBS.Position
		  
		  mHeaderBS.Write key
		  mHeaderMB.UInt16Value(mHeaderFirstInstruction)= mHeaderBS.Length
		  
		  Dim ret As New Pair(pos, key.LenB)
		  mHeaderCache.Value(key)= ret
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function StoreHeader(s As String) As Pair
		  If mHeaderCache.HasKey(s) Then Return Pair(mHeaderCache.Value(s))
		  
		  Dim pos As UInt64= mHeaderBS.Position
		  
		  mHeaderBS.Write s
		  mHeaderMB.UInt16Value(mHeaderFirstInstruction)= mHeaderBS.Length
		  
		  Dim ret As New Pair(pos, s.LenB)
		  mHeaderCache.Value(s)= ret
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ToMemoryBlock(expr As ConstantExpression) As MemoryBlock
		  Dim value As Variant= expr.Value
		  Dim valueType As Integer= value.Type
		  Select Case valueType
		  Case 2 // integer
		    Dim mb As New MemoryBlock(4)
		    mb.LittleEndian= True
		    mb.Int32Value(0)= value.Int32Value
		    Return mb
		  Case 3 // long
		    Dim mb As New MemoryBlock(8)
		    mb.LittleEndian= True
		    mb.Int64Value(0)= value.Int64Value
		    Return mb
		  Case 4 // single
		    Dim mb As New MemoryBlock(4)
		    mb.LittleEndian= True
		    mb.SingleValue(0)= value.SingleValue
		    Return mb
		  Case 5 // double
		    Dim mb As New MemoryBlock(8)
		    mb.LittleEndian= True
		    mb.DoubleValue(0)= value.DoubleValue
		    Return mb
		  Case 6 // currency
		    Dim mb As New MemoryBlock(8)
		    mb.LittleEndian= True
		    mb.CurrencyValue(0)= value.CurrencyValue
		    Return mb
		  Case 7 // date as u64
		    Dim mb As New MemoryBlock(8)
		    mb.LittleEndian= True
		    mb.DoubleValue(0)= value.DateValue.TotalSeconds
		    Return mb
		  Case 8 // string
		    Dim mb As New MemoryBlock(value.LenB)
		    mb.LittleEndian= True
		    mb= value.StringValue
		    Return mb
		  Case 9 // object
		    Dim mb As MemoryBlock= GetVUInt64(GetObjectID(expr))
		    mb.LittleEndian= True
		    Return mb
		  Case 11 // boolean
		    Dim mb As New MemoryBlock(1)
		    mb.LittleEndian= True
		    If value.BooleanValue Then mb.UInt8Value(0)= 1
		    Return mb
		  Case Else
		    Raise GetRuntimeExc("variant type not implemented!")
		  End Select
		End Function
	#tag EndMethod


	#tag Note, Name = Spec
		
		# Introduction
		store in big-endian order  
		use vUInts to encode unsigned integers [VLQ](https://en.wikipedia.org/wiki/Variable-length_quantity)  
		
		# Binary format
		
		'''
		+--------------+
		| Header       |
		+--------------+
		| Symbols      |
		+--------------+
		| Instructions |
		+--------------+
		'''
		
		'''
		+--------+------+---------------------+
		| offset | size | description         |
		+--------+------+---------------------+
		| 0      | 4    | magic: &hBEBECAFE   |
		| 4      | 1    | mayor version       |
		| 5      | 2    | minor version       |
		| 7      | 1    | flags               |
		| 8      | 2    | instructions offset |
		| 10     | n    | symbols             |
		| 10+n   | m    | instructions        |
		+--------+------+---------------------+
		'''
		
		# Instructions
		instructions are variable-length in size  
		instruction begin with 1byte as opCode folows by variable operands  
		operands are coded in vUint format  
		
		+---------+-------+---------------------+
		| offset  | size  | description         |
		+---------+-------+---------------------+
		| 0       | 1     | opCode              |
		+---------+-------+---------------------+
		| 1       | vUint | operands            |
		| ...     | vUint | operands            |
		+---------+-------+---------------------+
		
		## Opcode instructions
		
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
	#tag EndNote


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mLambda
			End Get
		#tag EndGetter
		LambdaBody As LambdaExpression
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mLoaded
			End Get
		#tag EndGetter
		Loaded As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mHeaderBS As BinaryStream
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHeaderCache As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHeaderFirstInstruction As UInt64
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHeaderMB As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInstructionsBS As BinaryStream
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInstructionsMB As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared mLabelCounter As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLambda As LambdaExpression
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLoaded As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLoading As LoadingAction
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mObjects() As Variant
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mParametersValues As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRetValue As Variant
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mScopeIndex As UInt16
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mScopeLocalIndex As UInt16
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mScopes() As Dictionary
	#tag EndProperty


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
			Name="Loaded"
			Group="Behavior"
			Type="Boolean"
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
End Class
#tag EndClass
