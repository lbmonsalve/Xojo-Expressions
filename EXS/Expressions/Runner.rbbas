#tag Class
Protected Class Runner
	#tag Method, Flags = &h0
		Sub Constructor(bcode As BinaryCode, Optional debugTrace As Writeable)
		  If bcode Is Nil Then Raise GetRuntimeExc("bcode Is Nil")
		  
		  mBinaryCode= bcode
		  mDebugTrace= debugTrace
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
		  
		  If Not paramsExpr.MatchTypeWith(paramValues) Then _
		  Raise GetRuntimeExc("Not paramsExpr.MatchTypeWith(mParamValues)")
		  
		  For i As Integer= 0 To paramsExpr.LastIdx
		    Dim paramExpr As EXS.Expressions.ParameterExpression= paramsExpr(i)
		    mEnv.Define paramExpr.Name, paramValues(i)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Run(ParamArray values As Variant) As Variant
		  mEnv= New Env
		  DefineParams values
		  
		  mBinaryCode.InstructionsBS.Position= 0
		  
		  While Not mBinaryCode.InstructionsBS.EndFileEXS
		    RunInstruction
		  Wend
		  
		  If mStack.LastIdxEXS= -1 Then Return Nil
		  
		  Return mStack.Pop
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RunInstruction()
		  Static debug As Boolean= Not (mDebugTrace Is Nil)
		  
		  Dim bs As BinaryStream= mBinaryCode.InstructionsBS
		  Dim offset As UInt64= bs.Position
		  Dim instruction As UInt8= bs.ReadUInt8
		  Dim opCode As OpCodes= instruction.ToOpCodes
		  
		  Dim symbols() As Variant= mBinaryCode.Symbols
		  
		  Const kFidx= "\[#\]"
		  
		  Select Case opCode
		  Case OpCodes.Nop // do nothing
		    If debug Then Trace(instruction.OpCodesToString)
		    
		  Case OpCodes.Ret
		    Dim idx As Integer= GetVUInt(bs)
		    mStack.Append symbols(idx)
		    
		    If debug Then Trace("# Ret "+ Str(idx, kFidx))
		    
		  Case OpCodes.Load
		    Dim idx As Integer= GetVUInt(bs)
		    Dim value As Variant= symbols(idx)
		    If value IsA ParameterExpression Then
		      Dim param As ParameterExpression= ParameterExpression(value)
		      value= mEnv.Get(param.Name)
		    End If
		    mStack.Append value
		    
		    If debug Then Trace("# Load "+ Str(idx, kFidx))
		    
		  Case OpCodes.And_
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left And right
		    
		    If debug Then Trace("# And "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.Or_
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left Or right
		    
		    If debug Then Trace("# Or "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.ExclusiveOr
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left Xor right
		    
		    If debug Then Trace("# Xor "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.LeftShift
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append Bitwise.ShiftLeft(left, right)
		    
		    If debug Then Trace("# LeftShift "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.RightShift
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append Bitwise.ShiftRight(left, right)
		    
		    If debug Then Trace("# RightShift "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.Greater
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left> right
		    
		    If debug Then Trace("# Greater "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.GreaterOrEqual
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left>= right
		    
		    If debug Then Trace("# GreaterOrEqual "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.Less
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left< right
		    
		    If debug Then Trace("# Less "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.LessOrEqual
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left<= right
		    
		    If debug Then Trace("# LessOrEqual "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.Equal
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left= right
		    
		    If debug Then Trace("# Equal "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.NotEqual
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left<> right
		    
		    If debug Then Trace("# NotEqual "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.Add
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left+ right
		    
		    If debug Then Trace("# Add "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.Subtract
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left- right
		    
		    If debug Then Trace("# Subtract "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.Multiply
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left* right
		    
		    If debug Then Trace("# Multiply "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.Divide
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left/ right
		    
		    If debug Then Trace("# Divide "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.Modulo
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left Mod right
		    
		    If debug Then Trace("# Modulo "+ Str(left)+ " "+ Str(right))
		    
		  Case OpCodes.Power
		    Dim right As Variant= mStack.Pop
		    Dim left As Variant= mStack.Pop
		    mStack.Append left^ right
		    
		    If debug Then Trace("# Power "+ Str(left)+ " "+ Str(right))
		    
		  Case Else
		    Raise GetRuntimeExc("# Unknown opcode 0x"+ Hex(instruction))
		    
		  End Select
		  
		  If debug Then TraceStack
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Trace(s As String)
		  mDebugTrace.Write s+ EndOfLine.UNIX
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TraceStack()
		  For i As Integer= mStack.LastIdxEXS To 0 Step -1
		    mDebugTrace.Write Str(i, "00000")+ " "+ mStack(i).ToStringVart+ EndOfLine.UNIX
		  Next
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mBinaryCode As BinaryCode
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDebugTrace As Writeable
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mEnv As Env
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
