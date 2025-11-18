#tag Class
Protected Class BlockExpression
Inherits EXS.Expressions.Expression
	#tag Method, Flags = &h0
		Function Accept(visitor As EXS.Expressions.IVisitor) As Variant
		  Return visitor.VisitBlock(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(expressions() As Expression)
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  mNodeType= ExpressionType.Block
		  mExpressions= expressions
		  
		  If mExpressions.LastIdxEXS= -1 Then Return
		  
		  Dim expr As Expression= mExpressions(mExpressions.LastIdxEXS)
		  mType= expr.Type
		  mResult= expr
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(variables() As ParameterExpression, expressions() As Expression)
		  Constructor expressions
		  
		  mVariables= variables
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Expressions() As Expression()
		  Return mExpressions
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Dim bs As New BinaryStream(New MemoryBlock(0))
		  
		  bs.Write "{"
		  For i As Integer= 0 To mExpressions.LastIdxEXS
		    bs.Write mExpressions(i).ToString
		    If i< mExpressions.LastIdxEXS Then bs.Write EndOfLine
		  Next
		  bs.Write "}"
		  
		  bs.Position= 0
		  
		  Return bs.Read(bs.Length, Encodings.UTF8)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Variables() As ParameterExpression()
		  Return mVariables
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mExpressions() As Expression
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mResult As Expression
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mVariables() As ParameterExpression
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mResult
			End Get
		#tag EndGetter
		Result As Expression
	#tag EndComputedProperty


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
