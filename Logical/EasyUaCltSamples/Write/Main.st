
PROGRAM _INIT
	VarA;
	EasyUaWrite_0.ServerEndpointUrl := 'opc.tcp://localhost:4841';
	EasyUaWrite_0.NodeID.NamespaceIndex := 6;
	EasyUaWrite_0.NodeID.Identifier := '::ServerTask:VarX';
	EasyUaWrite_0.NodeID.IdentifierType := UAIdentifierType_String;
	EasyUaWrite_0.Variable := '::Write:VarA';
END_PROGRAM

PROGRAM _CYCLIC
	EasyUaWrite_0();
END_PROGRAM

PROGRAM _EXIT
END_PROGRAM

