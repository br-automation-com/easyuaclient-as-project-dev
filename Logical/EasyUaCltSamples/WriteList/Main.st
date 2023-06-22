PROGRAM _INIT
	VarA;
	VarB;
	VarC;
	EasyUaWriteList_0.ServerEndpointUrl := 'opc.tcp://localhost:4841';
	
	EasyUaWriteList_0.NodeIDs[0].NamespaceIndex := 6;
	EasyUaWriteList_0.NodeIDs[0].Identifier := '::ServerTask:VarX';
	EasyUaWriteList_0.NodeIDs[0].IdentifierType := UAIdentifierType_String;
	
	EasyUaWriteList_0.NodeIDs[1].NamespaceIndex := 6;
	EasyUaWriteList_0.NodeIDs[1].Identifier := '::ServerTask:VarY';
	EasyUaWriteList_0.NodeIDs[1].IdentifierType := UAIdentifierType_String;
	
	
	EasyUaWriteList_0.NodeIDs[2].NamespaceIndex := 6;
	EasyUaWriteList_0.NodeIDs[2].Identifier := '::ServerTask:VarZ';
	EasyUaWriteList_0.NodeIDs[2].IdentifierType := UAIdentifierType_String;
	
	EasyUaWriteList_0.Variables[0] := '::WriteList:VarA';
	EasyUaWriteList_0.Variables[1] := '::WriteList:VarB';
	EasyUaWriteList_0.Variables[2] := '::WriteList:VarC';
END_PROGRAM

PROGRAM _CYCLIC
	EasyUaWriteList_0(NodeIDCount := 3, NodeErrorIDs := NodeErrorIDs_0);
END_PROGRAM

PROGRAM _EXIT
END_PROGRAM
