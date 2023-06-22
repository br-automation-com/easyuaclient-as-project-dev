
PROGRAM _INIT
	VarA;
	EasyUaRead_0.ServerEndpointUrl := 'opc.tcp://localhost:4841';
	EasyUaRead_0.NodeID.NamespaceIndex := 6;
	EasyUaRead_0.NodeID.Identifier := '::ServerTask:VarX';
	EasyUaRead_0.NodeID.IdentifierType := UAIdentifierType_String;
	EasyUaRead_0.Variable := '::Read:VarA';
END_PROGRAM

PROGRAM _CYCLIC
	EasyUaRead_0();
END_PROGRAM

PROGRAM _EXIT
END_PROGRAM

