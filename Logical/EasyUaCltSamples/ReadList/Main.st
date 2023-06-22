PROGRAM _INIT
	VarA;
	VarB;
	VarC;
	EasyUaReadList_0.ServerEndpointUrl := 'opc.tcp://localhost:4841';
	
	EasyUaReadList_0.NodeIDs[0].NamespaceIndex := 6;
	EasyUaReadList_0.NodeIDs[0].Identifier := '::ServerTask:VarX';
	EasyUaReadList_0.NodeIDs[0].IdentifierType := UAIdentifierType_String;
	
	EasyUaReadList_0.NodeIDs[1].NamespaceIndex := 6;
	EasyUaReadList_0.NodeIDs[1].Identifier := '::ServerTask:VarY';
	EasyUaReadList_0.NodeIDs[1].IdentifierType := UAIdentifierType_String;
	
	
	EasyUaReadList_0.NodeIDs[2].NamespaceIndex := 6;
	EasyUaReadList_0.NodeIDs[2].Identifier := '::ServerTask:VarZ';
	EasyUaReadList_0.NodeIDs[2].IdentifierType := UAIdentifierType_String;
	
	EasyUaReadList_0.Variables[0] := '::ReadList:VarA';
	EasyUaReadList_0.Variables[1] := '::ReadList:VarB';
	EasyUaReadList_0.Variables[2] := '::ReadList:VarC';
END_PROGRAM

PROGRAM _CYCLIC
	EasyUaReadList_0(NodeIDCount := 3, NodeErrorIDs := NodeErrorIDs_0, TimeStamps := TimeStamps_0);
END_PROGRAM

PROGRAM _EXIT
END_PROGRAM
