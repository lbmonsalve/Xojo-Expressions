#tag Class
Protected Class LambdaResolver
Implements EXS.Expressions.ILambdaCompiler
	#tag Method, Flags = &h0
		Sub Constructor(expr As EXS.Expressions.LambdaExpression)
		  mExpr= expr
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EmitLambdaBody()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Run(values() As Variant) As Variant
		  Dim resolver As New EXS.Misc.Resolver(values)
		  
		  Return resolver.Resolve(mExpr)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Save(file As FolderItem)
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mExpr As EXS.Expressions.LambdaExpression
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
