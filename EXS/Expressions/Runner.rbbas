#tag Class
Protected Class Runner
	#tag Method, Flags = &h0
		Sub Constructor(bcode As BinaryCode, Optional debugTrace As Writeable)
		  If bcode Is Nil Then Raise GetRuntimeExc("bcode Is Nil")
		  
		  mBinaryCode= bcode
		  mDebugTrace= debugTrace
		  mDebug= Not (mDebugTrace Is Nil)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DefineParams(paramValues() As Variant)
		  Dim paramsExpr() As ParameterExpression
		  Dim symbols() As Variant= mBinaryCode.Symbols
		  
		  For i As Integer= 0 To symbols.LastIdxEXS
		    If symbols(i) IsA ParameterExpression Then
		      paramsExpr.Append ParameterExpression(symbols(i))
		    End If
		  Next
		  
		  If Not (paramValues Is Nil) And paramValues.LastIdxEXS= -1 Then Return
		  
		  If Not paramsExpr.MatchTypeWith(paramValues) Then _
		  Raise GetRuntimeExc("Not paramsExpr.MatchTypeWith(mParamValues)")
		  
		  For i As Integer= 0 To paramsExpr.LastIdxEXS
		    Dim paramExpr As EXS.Expressions.ParameterExpression= paramsExpr(i)
		    mLocals.Value(paramExpr.Name)= paramValues(i)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Run(values() As Variant) As Variant
		  mLocals= New Dictionary
		  DefineParams values
		  
		  mBinaryCode.InstructionsBS.Position= 0
		  mRetPos= mBinaryCode.InstructionsBS.Length
		  
		  While Not mBinaryCode.InstructionsBS.EndFileEXS
		    RunInstruction
		  Wend
		  
		  If mStack.LastIdxEXS= -1 Then Return Nil
		  
		  Return mStack.Pop
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Run(ParamArray values As Variant) As Variant
		  Return Run(values)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RunInstruction()
		  Dim bs As BinaryStream= mBinaryCode.InstructionsBS
		  Dim instruction As UInt8= bs.ReadUInt8
		  Dim symbols() As Variant= mBinaryCode.Symbols
		  
		  Select Case instruction.ToOpCodes
		  Case OpCodes.Invoke
		    Dim idx As Integer= GetVUInt(bs)
		    Dim value As Variant= mStack(idx)
		    
		    mRetPos= bs.Position
		    bs.Position= value
		    
		    If mDebug Then Trace("# Invoke "+ Str(idx, kFidx))
		    
		  Case OpCodes.Load
		    Dim idx As Integer= GetVUInt(bs)
		    Dim value As Variant= symbols(idx)
		    If value IsA ParameterExpression Then
		      value= mLocals.Value(ParameterExpression(value).Name)
		    End If
		    mStack.Append value
		    
		    If mDebug Then Trace("# Load "+ Str(idx, kFidx))
		    
		  Case OpCodes.Store
		    Dim idx As Integer= GetVUInt(bs)
		    If mStack.LastIdxEXS<> idx Then mStack(idx)= mStack.Pop
		    
		    If mDebug Then Trace("# Store "+ Str(idx, kFidx))
		    
		  Case OpCodes.Local
		    Dim idx As Integer= GetVUInt(bs)
		    mStack.Append mStack(idx)
		    
		    If mDebug Then Trace("# Local "+ Str(idx, kFidx))
		    
		  Case OpCodes.Call_
		    Dim idx As Integer= GetVUInt(bs)
		    Dim symbol As Variant= symbols(idx)
		    If symbol IsA MethodCallExpression Then
		      RunMethod symbol
		    Else
		      Raise GetRuntimeExc("Not symbol IsA MethodCallExpression")
		    End If
		    
		    If mDebug Then Trace("# Call "+ Str(idx, kFidx))
		    
		  Case OpCodes.Pop
		    Dim value As Variant= mStack.Pop
		    
		    If mDebug Then Trace("# Pop "+ Str(value))
		    
		  Case OpCodes.Jump
		    Dim pos As UInt64= bs.ReadUInt16
		    bs.Position= pos
		    
		    If mDebug Then Trace("# Jump "+ Str(pos, kFoff))
		    
		  Case OpCodes.JumpFalse
		    Dim pos As UInt64= bs.ReadUInt16
		    Dim test As Variant= Not mStack(mStack.LastIdxEXS)
		    
		    If test.BooleanValue Then bs.Position= pos
		    
		    If mDebug Then Trace("# JumpFalse "+ Str(test)+ " "+ Str(pos, kFoff))
		    
		  Case OpCodes.Not_
		    Dim value As Boolean= mStack.Pop.BooleanValue
		    mStack.Append Not value
		    
		    If mDebug Then Trace("# Negate "+ Str(value))
		    
		  Case OpCodes.Convert
		    Dim idx As Integer= GetVUInt(bs)
		    Dim symbol As Variant= symbols(idx)
		    mStack.Append Convert(mStack.Pop, symbol)
		    
		    If mDebug Then Trace("# Convert "+ Str(idx, kFidx))
		    
		  Case OpCodes.Ret
		    bs.Position= mRetPos
		    
		    If mDebug Then Trace("# Ret ")+ Str(mRetPos, kFoff)
		    
		  Case OpCodes.Equal
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left= right
		    
		    If mDebug Then Trace("# Equal "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.Greater
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left> right
		    
		    If mDebug Then Trace("# Greater "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.Less
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left< right
		    
		    If mDebug Then Trace("# Less "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.And_
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left And right
		    
		    If mDebug Then Trace("# And "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.Or_
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left Or right
		    
		    If mDebug Then Trace("# Or "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.ExclusiveOr
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left Xor right
		    
		    If mDebug Then Trace("# Xor "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.Add
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left+ right
		    
		    If mDebug Then Trace("# Add "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.Subtract
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left- right
		    
		    If mDebug Then Trace("# Subtract "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.Multiply
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left* right
		    
		    If mDebug Then Trace("# Multiply "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.Divide
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left/ right
		    
		    If mDebug Then Trace("# Divide "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.Modulo
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left Mod right
		    
		    If mDebug Then Trace("# Modulo "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.Power
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left.DoubleValue^ right.DoubleValue
		    
		    If mDebug Then Trace("# Power "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.LeftShift
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append Bitwise.ShiftLeft(left, right)
		    
		    If mDebug Then Trace("# LeftShift "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.RightShift
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append Bitwise.ShiftRight(left, right)
		    
		    If mDebug Then Trace("# RightShift "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.Nop // do nothing
		    If mDebug Then Trace(instruction.OpCodesToString)
		    
		  Case Else
		    Raise GetRuntimeExc("Unknown opcode 0x"+ Hex(instruction))
		    
		  End Select
		  
		  If mDebug Then TraceStack
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RunMethod(method As EXS.Expressions.MethodCallExpression)
		  Dim tiObj As Introspection.TypeInfo= GetType(method.Type.FullName)
		  If tiObj Is Nil Then Raise GetRuntimeExc("tiObj Is Nil")
		  
		  Dim methodInfo As Introspection.MethodInfo= method.Method
		  If methodInfo Is Nil Then Raise GetRuntimeExc("methodInfo Is Nil")
		  
		  Dim params() As Introspection.ParameterInfo= methodInfo.GetParameters
		  Dim methodParams() As Variant
		  For i As Integer= 0 To params.LastIdxEXS
		    methodParams.Append mStack.Pop
		  Next
		  
		  Dim retValue As Variant
		  
		  If methodInfo.ReturnType Is Nil Then
		    methodInfo.Invoke Nil, methodParams
		  Else
		    retValue= methodInfo.Invoke(Nil, methodParams)
		  End If
		  
		  If Not (retValue Is Nil) Then mStack.Append(retValue)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Trace(s As String)
		  mDebugTrace.WriteLn s
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TraceStack()
		  For i As Integer= mStack.LastIdxEXS To 0 Step -1
		    mDebugTrace.WriteLn Str(i, kFoff)+ " "+ mStack(i).ToStringVart
		  Next
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mBinaryCode As BinaryCode
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDebug As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDebugTrace As Writeable
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLocals As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRetPos As UInt64
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mStack() As Variant
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
