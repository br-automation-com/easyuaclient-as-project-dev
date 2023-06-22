PROGRAM _INIT
	EasyUaConnectionGetStatus_0.ServerEndpointUrl := 'opc.tcp://localhost:4841';
END_PROGRAM

PROGRAM _CYCLIC
	EasyUaConnectionGetStatus_0();
END_PROGRAM

PROGRAM _EXIT
END_PROGRAM

