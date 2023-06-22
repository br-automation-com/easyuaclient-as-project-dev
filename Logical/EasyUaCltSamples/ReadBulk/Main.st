PROGRAM _INIT
	VarA;
	VarB;
	VarC;
	EasyUaReadBulk_0.ServerEndpointUrl := 'opc.tcp://localhost:4841';
	
	NodeIDs_0[0].NamespaceIndex := 6;
	NodeIDs_0[0].Identifier := '::ServerTask:VarX';
	NodeIDs_0[0].IdentifierType := UAIdentifierType_String;
	
	NodeIDs_0[1].NamespaceIndex := 6;
	NodeIDs_0[1].Identifier := '::ServerTask:VarY';
	NodeIDs_0[1].IdentifierType := UAIdentifierType_String;
	
	
	NodeIDs_0[2].NamespaceIndex := 6;
	NodeIDs_0[2].Identifier := '::ServerTask:VarZ';
	NodeIDs_0[2].IdentifierType := UAIdentifierType_String;
	
	Variables_0[0] := '::ReadBulk:VarA';
	Variables_0[1] := '::ReadBulk:VarB';
	Variables_0[2] := '::ReadBulk:VarC';
END_PROGRAM

PROGRAM _CYCLIC
	EasyUaReadBulk_0(NodeIDCount := 3, NodeIDs := ADR(NodeIDs_0), NodeIDsLen := SIZEOF(NodeIDs_0), Variables := ADR(Variables_0), NodeErrorIDs := ADR(NodeErrorIDs_0), TimeStamps := ADR(TimeStamps_0));
END_PROGRAM

PROGRAM _EXIT
END_PROGRAM

