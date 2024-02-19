#tag Class
Protected Class ObjectWithBinaryExprMethod
	#tag Method, Flags = &h0
		 Shared Function Add(lhs As ObjectWithBinaryExprMethod, rhs As ObjectWithBinaryExprMethod) As ObjectWithBinaryExprMethod
		  Return New ObjectWithBinaryExprMethod(lhs+ rhs)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(value As Variant)
		  Self.Value= value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LeftShift(shift As Integer) As ObjectWithBinaryExprMethod
		  Return New ObjectWithBinaryExprMethod(Bitwise.ShiftLeft(Self.Value.UInt64Value, shift))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Add(rhs As ObjectWithBinaryExprMethod) As ObjectWithBinaryExprMethod
		  Return New ObjectWithBinaryExprMethod(Self.Value+ rhs.Value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_And(rhs As ObjectWithBinaryExprMethod) As ObjectWithBinaryExprMethod
		  Return New ObjectWithBinaryExprMethod(Self.Value And rhs.Value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Divide(rhs As ObjectWithBinaryExprMethod) As ObjectWithBinaryExprMethod
		  Return New ObjectWithBinaryExprMethod(Self.Value/ rhs.Value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Modulo(rhs As ObjectWithBinaryExprMethod) As ObjectWithBinaryExprMethod
		  Return New ObjectWithBinaryExprMethod(Self.Value Mod rhs.Value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Multiply(rhs As ObjectWithBinaryExprMethod) As ObjectWithBinaryExprMethod
		  Return New ObjectWithBinaryExprMethod(Self.Value* rhs.Value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Or(rhs As ObjectWithBinaryExprMethod) As ObjectWithBinaryExprMethod
		  Return New ObjectWithBinaryExprMethod(Self.Value Or rhs.Value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Power(rhs As ObjectWithBinaryExprMethod) As ObjectWithBinaryExprMethod
		  Return New ObjectWithBinaryExprMethod(Self.Value ^ rhs.Value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Subscript(index As Integer) As Variant
		  Return New ObjectWithBinaryExprMethod(index) // dump
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Subtract(rhs As ObjectWithBinaryExprMethod) As ObjectWithBinaryExprMethod
		  Return New ObjectWithBinaryExprMethod(Self.Value- rhs.Value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_XOr(rhs As ObjectWithBinaryExprMethod) As ObjectWithBinaryExprMethod
		  Return New ObjectWithBinaryExprMethod(Self.Value XOr rhs.Value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RightShift(shift As Integer) As ObjectWithBinaryExprMethod
		  Return New ObjectWithBinaryExprMethod(Bitwise.ShiftRight(Self.Value.UInt64Value, shift))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Return Value.StringValue
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Value As Variant
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
