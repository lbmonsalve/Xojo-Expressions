#tag Class
Protected Class MethodCallExpression
Inherits EXS.Expressions.Expression
	#tag Method, Flags = &h0
		Function Accept(visitor As EXS.Expressions.IVisitor) As Variant
		  Return visitor.VisitMethodCall(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Arguments() As Expression()
		  Return mArguments
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ArgumentsTypes() As Introspection.TypeInfo()
		  Return mArgumentsTypes
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(instance As Object, typeExpr As Introspection.TypeInfo, methodName As String, typeArguments() As Introspection.TypeInfo, arguments() As Expression)
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  mNodeType= ExpressionType.Call_
		  If Not (instance Is Nil) Then mObj= Expression.Constant(instance)
		  mType= typeExpr
		  mMethod= typeExpr.GetMethodInfo(methodName)
		  mArgumentsTypes= typeArguments
		  mArguments= arguments
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Dim bs As New BinaryStream(New MemoryBlock(0))
		  bs.Write mType.Name
		  bs.Write "."+ mMethod.Name
		  If mArguments.LastIdx> -1 Then
		    bs.Write "("
		    For i As Integer= 0 To mArguments.LastIdx
		      bs.Write mArguments(i).ToString
		      If i< mArguments.LastIdx Then bs.Write ","
		    Next
		    bs.Write ")"
		  End If
		  bs.Position= 0
		  
		  Return bs.Read(bs.Length, Encodings.UTF8)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mArguments() As Expression
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mArgumentsTypes() As Introspection.TypeInfo
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mMethod
			End Get
		#tag EndGetter
		Method As Introspection.MethodInfo
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mMethod As Introspection.MethodInfo
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mObj As Expression
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mObj
			End Get
		#tag EndGetter
		Obj As Expression
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
