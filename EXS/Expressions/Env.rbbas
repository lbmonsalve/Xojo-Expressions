#tag Class
Protected Class Env
	#tag Method, Flags = &h0
		Sub Assign(name As String, value As Variant)
		  If mLocals.HasKey(name) Then
		    mLocals.Value(name)= value
		    Return
		  End If
		  
		  If Not (mEnclosing Is Nil) Then
		    mEnclosing.Assign name, value
		    Return
		  End If
		  
		  Raise GetRuntimeExc("undefined variable """+ name+ """")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  mLocals= New Dictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(enclosing As Env)
		  Constructor
		  
		  mEnclosing= enclosing
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Define(name As String, value As Variant)
		  mLocals.Value(name)= value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Get(name As String) As Variant
		  If mLocals.HasKey(name) Then Return mLocals.Value(name)
		  If Not (mEnclosing Is Nil) Then Return mEnclosing.Get(name)
		  
		  Raise GetRuntimeExc("undefined variable """+ name+ """")
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mEnclosing As Env
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLocals As Dictionary
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
