#tag Class
Protected Class BinaryExpression
Inherits EXS.Expressions.Expression
	#tag Method, Flags = &h1000
		Sub Constructor(left As Expression, right As Expression)
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  mLeft= left
		  mRight= right
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  If mLeft Is Nil Or mRight Is Nil Then Raise GetRuntimeExc("mLeft Is Nil Or mRight Is Nil")
		  
		  If mNodeType= ExpressionType.ArrayIndex Then
		    Return mLeft.ToString+ mNodeType.ToStringSymbol.Replace("idx", mRight.ToString)
		  Else
		    Return mLeft.ToString+ mNodeType.ToStringSymbol+ mRight.ToString
		  End If
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mLeft
			End Get
		#tag EndGetter
		Left As Expression
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mMethod
			End Get
		#tag EndGetter
		Method As Introspection.MethodInfo
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mLeft As Expression
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mMethod As Introspection.MethodInfo
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRight As Expression
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mRight
			End Get
		#tag EndGetter
		Right As Expression
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
