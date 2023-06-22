PROGRAM _INIT
	VarA;
	VarB;
	VarC;
	EasyUaMethodCall_0.ServerEndpointUrl := 'opc.tcp://localhost:4841';
	
	EasyUaMethodCall_0.ObjectNodeID.NamespaceIndex := 6;
	EasyUaMethodCall_0.ObjectNodeID.Identifier := '::ServerTask';
	EasyUaMethodCall_0.ObjectNodeID.IdentifierType := UAIdentifierType_String;
	
	EasyUaMethodCall_0.MethodNodeID.NamespaceIndex := 6;
	EasyUaMethodCall_0.MethodNodeID.Identifier := '::ServerTask:Multiply';
	EasyUaMethodCall_0.MethodNodeID.IdentifierType := UAIdentifierType_String;
	
	EasyUaMethodCall_0.InputArguments[0].Name := 'Input1';
	EasyUaMethodCall_0.InputArguments[0].Value := '::MethodCall:VarA';
	EasyUaMethodCall_0.InputArguments[1].Name := 'Input2';
	EasyUaMethodCall_0.InputArguments[1].Value := '::MethodCall:VarB';
	
	EasyUaMethodCall_0.OutputArguments[0].Name := 'Result';
	EasyUaMethodCall_0.OutputArguments[0].Value := '::MethodCall:VarC';
END_PROGRAM

PROGRAM _CYCLIC
	EasyUaMethodCall_0();
END_PROGRAM

PROGRAM _EXIT
END_PROGRAM

