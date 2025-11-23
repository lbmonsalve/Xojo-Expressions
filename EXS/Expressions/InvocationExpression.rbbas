#tag Class
Protected Class InvocationExpression
Inherits EXS.Expressions.Expression
	#tag Method, Flags = &h0
		Function Accept(visitor As EXS.Expressions.IVisitor) As Variant
		  Return visitor.VisitInvocation(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Arguments() As Expression()
		  Return mArgs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(expr As Expression, typeTo As Introspection.TypeInfo, args() As Expression)
		  mNodeType= ExpressionType.Invocation
		  
		  mExpr= expr
		  mType= typeTo
		  mArgs= args
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Dim result() As String
		  result.Append mExpr.ToString+ "("
		  
		  For i As Integer= 0 To mArgs.LastIdxEXS
		    result.Append mArgs(i).ToString
		  Next
		  
		  result.Append ")"
		  
		  Return Join(result, "")
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mExpr
			End Get
		#tag EndGetter
		Expr As Expression
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mArgs() As Expression
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mExpr As Expression
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
