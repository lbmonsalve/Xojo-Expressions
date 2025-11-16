#tag Class
Protected Class System
	#tag Method, Flags = &h0
		 Shared Sub Beep()
		  Beep
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub DebugLog(msg As String)
		  System.DebugLog msg
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ElapsedMicroseconds() As Double
		  Return Microseconds
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ElapsedTicks() As Integer
		  Return Ticks
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = TargetHasGUI
		 Shared Function FontAt(index As Integer) As String
		  Return Font(index)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetEnvironment(name As String) As String
		  Return System.EnvironmentVariable(name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = TargetHasGUI
		 Shared Sub GotoURL(url As String)
		  ShowURL url
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function IsFunctionAvailable(name As String, libraryName As String) As Boolean
		  Return System.IsFunctionAvailable(name, libraryName)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub Log(level As Integer, msg As String)
		  System.Log level, msg
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function NetworkInterface(index As Integer) As NetworkInterface
		  Return System.GetNetworkInterface(index)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Random() As Random
		  Static rnd As Random
		  If rnd Is Nil Then rnd= New Random
		  
		  Return rnd
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub SetEnvironment(name As String, Assigns value As String)
		  System.EnvironmentVariable(name)= value
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return System.CommandLine
			End Get
		#tag EndGetter
		Shared CommandLine As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, CompatibilityFlags =      TargetHasGUI
		#tag Getter
			Get
			  Return FontCount
			End Get
		#tag EndGetter
		Shared FontCount As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return System.Network
			End Get
		#tag EndGetter
		Shared Network As Network
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return System.NetworkInterfaceCount
			End Get
		#tag EndGetter
		Shared NetworkInterfaceCount As Integer
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
