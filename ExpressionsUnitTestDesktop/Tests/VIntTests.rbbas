#tag Class
Protected Class VIntTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub Byte1Test()
		  Dim nbytes As Integer= 1
		  Assert.Message "nbytes= "+ Str(nbytes)
		  
		  Dim rangeMin As Integer= 0
		  Dim rangeMax As Integer= 2^(8*1-1)
		  rangeMax= rangeMax- 1
		  
		  Dim exp As UInt8= rangeMin
		  Dim mb As MemoryBlock= EXS.GetVUint64(exp)
		  Dim act As UInt8= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		  
		  exp= rangeMax
		  mb= EXS.GetVUint64(exp)
		  act= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		  
		  exp= EXS.System.Random.InRange(rangeMin, rangeMax)
		  mb= EXS.GetVUint64(exp)
		  act= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Byte2Test()
		  Dim nbytes As Integer= 2
		  Assert.Message "nbytes= "+ Str(nbytes)
		  
		  Dim rangeMin As Integer= 2^(8*1-1)
		  Dim rangeMax As Integer= 2^(8*2-2)
		  rangeMax= rangeMax- 1
		  
		  Dim exp As UInt16= rangeMin
		  Dim mb As MemoryBlock= EXS.GetVUint64(exp)
		  Dim act As UInt16= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		  
		  exp= rangeMax
		  mb= EXS.GetVUint64(exp)
		  act= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		  
		  exp= EXS.System.Random.InRange(rangeMin, rangeMax)
		  mb= EXS.GetVUint64(exp)
		  act= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Byte3Test()
		  Dim nbytes As Integer= 3
		  Assert.Message "nbytes= "+ Str(nbytes)
		  
		  Dim rangeMin As Integer= 2^(8*2-2)
		  Dim rangeMax As Integer= 2^(8*3-3)
		  rangeMax= rangeMax- 1
		  
		  Dim exp As UInt32= rangeMin
		  Dim mb As MemoryBlock= EXS.GetVUint64(exp)
		  Dim act As UInt32= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		  
		  exp= rangeMax
		  mb= EXS.GetVUint64(exp)
		  act= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		  
		  exp= EXS.System.Random.InRange(rangeMin, rangeMax)
		  mb= EXS.GetVUint64(exp)
		  act= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Byte4Test()
		  Dim nbytes As Integer= 4
		  Assert.Message "nbytes= "+ Str(nbytes)
		  
		  Dim rangeMin As UInt32= 2^(8*3-3)
		  Dim rangeMax As UInt32= 2^(8*4-4)
		  rangeMax= rangeMax- 1
		  
		  Dim exp As UInt32= rangeMin
		  Dim mb As MemoryBlock= EXS.GetVUint64(exp)
		  Dim act As UInt32= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		  
		  exp= rangeMax
		  mb= EXS.GetVUint64(exp)
		  act= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		  
		  exp= EXS.System.Random.InRange(rangeMin, rangeMax)
		  mb= EXS.GetVUint64(exp)
		  act= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Byte5Test()
		  Dim nbytes As Integer= 5
		  Assert.Message "nbytes= "+ Str(nbytes)
		  
		  Dim rangeMin As UInt64= 2^(8*4-4)
		  Dim rangeMax As UInt64= 2^(8*5-5)
		  rangeMax= rangeMax- 1
		  
		  Dim exp As UInt64= rangeMin
		  Dim mb As MemoryBlock= EXS.GetVUint64(exp)
		  Dim act As UInt64= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		  
		  exp= rangeMax
		  mb= EXS.GetVUint64(exp)
		  act= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		  
		  Dim rangeRnd As UInt64= (rangeMax- rangeMin)
		  rangeRnd= rangeRnd* EXS.System.Random.Number
		  rangeRnd= rangeMin+ rangeRnd
		  exp= rangeRnd
		  mb= EXS.GetVUint64(exp)
		  act= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Byte6Test()
		  Dim nbytes As Integer= 6
		  Assert.Message "nbytes= "+ Str(nbytes)
		  
		  Dim rangeMin As UInt64= 2^(8*5-5)
		  Dim rangeMax As UInt64= 2^(8*6-6)
		  rangeMax= rangeMax- 1
		  
		  Dim exp As UInt64= rangeMin
		  Dim mb As MemoryBlock= EXS.GetVUint64(exp)
		  Dim act As UInt64= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		  
		  exp= rangeMax
		  mb= EXS.GetVUint64(exp)
		  act= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		  
		  Dim rangeRnd As UInt64= (rangeMax- rangeMin)
		  rangeRnd= rangeRnd* EXS.System.Random.Number
		  rangeRnd= rangeMin+ rangeRnd
		  exp= rangeRnd
		  mb= EXS.GetVUint64(exp)
		  act= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Byte7Test()
		  Dim nbytes As Integer= 7
		  Assert.Message "nbytes= "+ Str(nbytes)
		  
		  Dim rangeMin As UInt64= 2^(8*6-6)
		  Dim rangeMax As UInt64= 2^(8*7-7)
		  rangeMax= rangeMax- 1
		  
		  Dim exp As UInt64= rangeMin
		  Dim mb As MemoryBlock= EXS.GetVUint64(exp)
		  Dim act As UInt64= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		  
		  exp= rangeMax
		  mb= EXS.GetVUint64(exp)
		  act= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		  
		  Dim rangeRnd As UInt64= (rangeMax- rangeMin)
		  rangeRnd= rangeRnd* EXS.System.Random.Number
		  rangeRnd= rangeMin+ rangeRnd
		  exp= rangeRnd
		  mb= EXS.GetVUint64(exp)
		  act= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Byte8Test()
		  Dim nbytes As Integer= 8
		  Assert.Message "nbytes= "+ Str(nbytes)
		  
		  Dim rangeMin As UInt64= 2^(8*7-7)
		  Dim rangeMax As UInt64= 2^(8*7)
		  rangeMax= rangeMax- 1
		  
		  Dim exp As UInt64= rangeMin
		  Dim mb As MemoryBlock= EXS.GetVUint64(exp)
		  Dim act As UInt64= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		  
		  exp= rangeMax
		  mb= EXS.GetVUint64(exp)
		  act= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		  
		  Dim rangeRnd As UInt64= (rangeMax- rangeMin)
		  rangeRnd= rangeRnd* EXS.System.Random.Number
		  rangeRnd= rangeMin+ rangeRnd
		  exp= rangeRnd
		  mb= EXS.GetVUint64(exp)
		  act= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Byte9Test()
		  Dim nbytes As Integer= 9
		  Assert.Message "nbytes= "+ Str(nbytes)
		  
		  Dim rangeMin As UInt64= 2^(8*7)
		  Dim rangeMax As UInt64= &hFFFFFFFFFFFFFFFF
		  
		  Dim exp As UInt64= rangeMin
		  Dim mb As MemoryBlock= EXS.GetVUint64(exp)
		  Dim act As UInt64= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		  
		  exp= rangeMax
		  mb= EXS.GetVUint64(exp)
		  act= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		  
		  Dim rangeRnd As UInt64= (rangeMax- rangeMin)
		  rangeRnd= rangeRnd* EXS.System.Random.Number
		  rangeRnd= rangeMin+ rangeRnd
		  exp= rangeRnd
		  mb= EXS.GetVUint64(exp)
		  act= EXS.GetVUint64Value(mb)
		  Assert.AreEqual nbytes, mb.Size, "AreEqual nbytes, mb.Size"
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DefaultTest()
		  Dim exp As Integer= 10
		  Dim mb As MemoryBlock= EXS.GetVUint64(exp)
		  Dim act As Integer= EXS.GetVUint64Value(mb)
		  Assert.AreEqual exp, act, "AreEqual exp, act"
		  Assert.Message Str(act)+ " encode: &h"+ EncodeHex(mb)
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Group="Behavior"
			Type="Double"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsRunning"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="TestGroup"
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
			Name="NotImplementedCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StopTestOnFail"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TestCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
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
