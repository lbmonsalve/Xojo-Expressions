#tag Module
Protected Module TypesUtils
	#tag Method, Flags = &h1
		Protected Function Get(name As String) As Introspection.TypeInfo
		  If name= "" Then Return Nil
		  
		  If mRegisteredTypes Is Nil Then mRegisteredTypes= New Dictionary
		  
		  If mRegisteredTypes.HasKey(name) Then Return mRegisteredTypes.Value(name)
		  
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Register(ti As Introspection.TypeInfo, name As String = "")
		  If ti Is Nil Then Return
		  If mRegisteredTypes Is Nil Then mRegisteredTypes= New Dictionary
		  
		  If name= "" Then name= ti.Name
		  
		  mRegisteredTypes.Value(name)= ti
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Registered(name As String) As Boolean
		  If name= "" Then Return False
		  
		  If mRegisteredTypes Is Nil Then mRegisteredTypes= New Dictionary
		  
		  Return mRegisteredTypes.HasKey(name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Release()
		  If mRegisteredTypes= Nil Then Return
		  
		  For i As Integer= 0 To mRegisteredTypes.Count- 1
		    Dim key As String= mRegisteredTypes.Key(i)
		    Dim tmp As Introspection.TypeInfo= mRegisteredTypes.Value(key)
		    tmp= Nil
		    mRegisteredTypes.Value(key)= Nil
		  Next
		  
		  mRegisteredTypes= Nil
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h1
		Attributes( Hidden ) Protected mRegisteredTypes As Dictionary
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
End Module
#tag EndModule
