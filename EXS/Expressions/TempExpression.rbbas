#tag Class
Protected Class TempExpression
Inherits EXS.Expressions.Expression
	#tag Method, Flags = &h1000
		Sub Constructor(retType As Introspection.TypeInfo)
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  mType= retType
		  
		  mCounter= mCounter+ 1
		  mId= mCounter
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub ResetCounter()
		  mCounter= 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Return "T"+ Str(Id)
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mId
			End Get
		#tag EndGetter
		Id As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private Shared mCounter As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mId As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Id"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
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
