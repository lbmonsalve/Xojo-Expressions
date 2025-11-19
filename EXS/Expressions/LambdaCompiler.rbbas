#tag Class
Protected Class LambdaCompiler
Implements ILambdaCompiler
	#tag Method, Flags = &h0
		Sub Constructor(expr As LambdaExpression)
		  mExpr= expr
		  mCompiler= New Compiler
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EmitLambdaBody()
		  mCompiler.Compile mExpr
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Run(values() As Variant) As Variant
		  Dim runner As New Runner(mCompiler.BinaryCode)
		  
		  Return runner.Run(values)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Save(file As FolderItem)
		  mCompiler.BinaryCode.Save file
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mCompiler As Compiler
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mExpr As LambdaExpression
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
