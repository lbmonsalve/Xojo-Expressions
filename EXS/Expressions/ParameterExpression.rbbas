#tag Class
Protected Class ParameterExpression
Inherits EXS.Expressions.Expression
	#tag Method, Flags = &h1001
		Protected Sub Constructor(name As String)
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  mNodeType= ExpressionType.Parameter
		  mName= name
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Make(typeParam As Introspection.TypeInfo, name As String, isByRef As Boolean) As ParameterExpression
		  If IsByRef Then Return New ByRefParameterExpression(typeParam, name)
		  
		  Return New TypedParameterExpression(typeParam, name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Return mName
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return False
			End Get
		#tag EndGetter
		IsByRef As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected mName As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mName
			End Get
		#tag EndGetter
		Name As String
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
			Name="IsByRef"
			Group="Behavior"
			Type="Boolean"
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
