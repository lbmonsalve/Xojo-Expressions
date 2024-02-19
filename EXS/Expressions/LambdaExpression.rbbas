#tag Class
Protected Class LambdaExpression
Inherits EXS.Expressions.Expression
	#tag Method, Flags = &h21
		Private Shared Function ChkReturnExpression(body As Expression) As Expression
		  Select Case body
		  Case IsA TypedParameterExpression, IsA ConstantExpression
		    Return New ReturnExpression(body)
		  Case IsA FullConditionalExpression
		    Dim cond As FullConditionalExpression= FullConditionalExpression(body)
		    cond.IfTrue= ChkReturnExpression(cond.IfTrue)
		    cond.IfFalse= ChkReturnExpression(cond.IfFalse)
		  Case IsA UnaryExpression // add oper
		    Dim unar As UnaryExpression= UnaryExpression(body)
		    Dim blockExpr As BlockExpression= Expression.Block(unar,_
		    New ReturnExpression(unar.Operand))
		    Return blockExpr
		  Case IsA AssignBinaryExpression
		    Dim assi As AssignBinaryExpression= AssignBinaryExpression(body)
		    Dim blockExpr As BlockExpression= Expression.Block(assi,_
		    New ReturnExpression(assi.Left))
		    Return blockExpr
		  Case IsA BlockExpression
		    Dim block As BlockExpression= BlockExpression(body)
		    Dim exprs() As Expression= block.Expressions
		    Dim lastIdx As Integer= exprs.LastIdx
		    exprs(lastIdx)= ChkReturnExpression(exprs(lastIdx))
		  End Select
		  
		  Return body
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Compile() As LambdaDelegate
		  mBody= ChkReturnExpression(mBody)
		  
		  mCompiler= New LambdaCompiler(Self)
		  mCompiler.EmitLambdaBody
		  
		  Return WeakAddressOf Run // return:
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(body As Expression, parameters() As ParameterExpression)
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  mNodeType= ExpressionType.Lambda
		  mBody= body
		  mParameters= parameters
		End Sub
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Function LambdaDelegate(ParamArray values As Variant) As Variant
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h0
		Function Parameters() As ParameterExpression()
		  Return mParameters
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Run(ParamArray values As Variant) As Variant
		  Return mCompiler.Run(values)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Dim bs As New BinaryStream(New MemoryBlock(0))
		  If mParameters.LastIdx= -1 Then // no params
		    bs.Write "() => "
		  ElseIf mParameters.LastIdx= 0 Then // one param
		    bs.Write mParameters(0).ToString+ " => "
		  Else // params
		    bs.Write "("
		    For i As Integer= 0 To mParameters.LastIdx
		      bs.Write mParameters(i).ToString
		      If i< mParameters.LastIdx Then bs.Write ", "
		    Next
		    bs.Write ")"
		  End If
		  bs.Write mBody.ToString
		  bs.Position= 0
		  
		  Return bs.Read(bs.Length, Encodings.UTF8)
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mBody
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mBody= value
			End Set
		#tag EndSetter
		Body As Expression
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mBody As Expression
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCompiler As ILambdaCompiler
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mParameters() As ParameterExpression
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
