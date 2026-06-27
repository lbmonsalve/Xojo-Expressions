#tag Class
Protected Class DisassembleTests
Inherits TestGroup
	#tag Event
		Sub Setup()
		  Dim dirDebug As FolderItem= SpecialFolder.Documents.Child("Debug")
		  If Not dirDebug.Exists Then dirDebug.CreateAsFolder
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AddTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim bs As BinaryStream= GetWriter
		  
		  Dim nParam As EXS.Expressions.ParameterExpression= expr.Parameter(EXS.GetType("Double"), "n")
		  Dim lambda As EXS.Expressions.LambdaExpression= expr.Lambda(_
		  expr.Add(nParam, expr.Constant(1)), nParam)
		  
		  Dim str1 As String= lambda.ToString
		  
		  bs.WriteLn str1+ EndOfLine.UNIX
		  
		  Dim compiler As New EXS.Expressions.Compiler(lambda)
		  compiler.BinaryCode.Disassemble bs
		  
		  Dim actual As String= ReplaceLineEndings(kDisassembleAddCompile, EndOfLine.UNIX)
		  
		  bs.Position= 0
		  str1= ReplaceLineEndings(bs.Read(bs.Length, Encodings.UTF8), EndOfLine.UNIX)
		  Assert.AreSame actual, str1, "AreSame actual, str1"
		  Dim runner As New EXS.Expressions.Runner(compiler, bs)
		  
		  bs.WriteLn ""
		  Dim bsPosition As UInt64= bs.Position
		  
		  Dim result As Variant= runner.Run(1)
		  Assert.AreSame "2", result.StringValue, "AreSame ""2"", result.StringValue"
		  
		  actual= ReplaceLineEndings(kDisassembleAddRun, EndOfLine.UNIX)
		  
		  bs.Position= bsPosition
		  str1= ReplaceLineEndings(bs.Read(bs.Length, Encodings.UTF8), EndOfLine.UNIX)
		  Assert.AreSame actual, str1, "AreSame actual, str1"
		  
		  // save
		  Dim tOut As TextOutputStream= TextOutputStream.Create(_
		  SpecialFolder.Documents.Child("Debug").Child("DisassembleAdd.txt"))
		  
		  bs.Position= 0
		  
		  tOut.Write bs.Read(bs.Length, Encodings.UTF8)
		  tOut.Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConstantTest()
		  Dim expr As EXS.Expressions.Expression
		  
		  Dim bs As BinaryStream= GetWriter
		  
		  Dim constantExpr As EXS.Expressions.ConstantExpression= expr.Constant(42)
		  Dim str1 As String= constantExpr.ToString
		  Assert.AreSame "42", str1, "AreSame ""42"", str1"
		  
		  bs.WriteLn str1+ EndOfLine.UNIX
		  
		  Dim compiler As New EXS.Expressions.Compiler(constantExpr)
		  compiler.BinaryCode.Disassemble bs
		  
		  Dim actual As String= ReplaceLineEndings(kDisassembleConstantCompile, EndOfLine.UNIX)
		  
		  bs.Position= 0
		  str1= ReplaceLineEndings(bs.Read(bs.Length, Encodings.UTF8), EndOfLine.UNIX)
		  Assert.AreSame actual, str1, "AreSame actual, str1"
		  
		  Dim runner As New EXS.Expressions.Runner(compiler, bs)
		  
		  bs.WriteLn ""
		  Dim bsPosition As UInt64= bs.Position
		  
		  Dim result As Variant= runner.Run
		  Assert.AreSame "42", result.StringValue, "AreSame ""42"", result.StringValue"
		  
		  actual= ReplaceLineEndings(kDisassembleConstantRun, EndOfLine.UNIX)
		  
		  bs.Position= bsPosition
		  str1= ReplaceLineEndings(bs.Read(bs.Length, Encodings.UTF8), EndOfLine.UNIX)
		  Assert.AreSame actual, str1, "AreSame actual, str1"
		  
		  // save
		  Dim tOut As TextOutputStream= TextOutputStream.Create(_
		  SpecialFolder.Documents.Child("Debug").Child("DisassembleConstant.txt"))
		  
		  bs.Position= 0
		  
		  tOut.Write bs.Read(bs.Length, Encodings.UTF8)
		  tOut.Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetWriter() As BinaryStream
		  Dim mb As New MemoryBlock(12)
		  Dim bs As New BinaryStream(mb)
		  
		  Return bs
		End Function
	#tag EndMethod


	#tag Constant, Name = kDisassembleAddCompile, Type = String, Dynamic = False, Default = \"(n) -> n + 1\r\r# Header\roffset size name    value\r00000  4    magic   0xBEBECAFE\r00004  1    version 0\r00005  2    minor   1\r00007  1    flags   0\r00008  4    ioffset 28\r# Symbols\roffset type    idx  value\r00014  str(13) [0] \"n\"\r00017  str(13) [1] \"Double\"\r00024  prm(15) [2] [0] [1] \r00027   u8(01) [3] 1\r# Instructions\roffset opcode\r00000  Load [2] \r00002  Store [0] \r00004  Local [0] \r00006  Load [3] \r00008  Add\r# HEX view 37 Bytes\raddress  0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F dump\r0000000 BE BE CA FE 00 00 01 80 00 00 00 1C 0D 01 6E 0D \xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7n\xC2\xB7\r0000010 06 44 6F 75 62 6C 65 0F 80 81 01 01 01 82 02 80 \xC2\xB7Double\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\r0000020 03 80 01 83 0D                                  \xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\r", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kDisassembleAddRun, Type = String, Dynamic = False, Default = \"# Load [2] \r00000 1\r# Store [0] \r00000 1\r# Local [0] \r00001 1\r00000 1\r# Load [3] \r00002 1\r00001 1\r00000 1\r# Add 1 1\r00001 2\r00000 1\r", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kDisassembleConstantCompile, Type = String, Dynamic = False, Default = \"42\r\r# Header\roffset size name    value\r00000  4    magic   0xBEBECAFE\r00004  1    version 0\r00005  2    minor   1\r00007  1    flags   0\r00008  4    ioffset 14\r# Symbols\roffset type    idx  value\r00013   u8(01) [0] 42\r# Instructions\roffset opcode\r00000  Load [0] \r# HEX view 16 Bytes\raddress  0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F dump\r0000000 BE BE CA FE 00 00 01 80 00 00 00 0E 01 2A 01 80 \xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7\xC2\xB7*\xC2\xB7\xC2\xB7\r", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kDisassembleConstantRun, Type = String, Dynamic = False, Default = \"# Load [0] \r00000 42\r", Scope = Private
	#tag EndConstant


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
