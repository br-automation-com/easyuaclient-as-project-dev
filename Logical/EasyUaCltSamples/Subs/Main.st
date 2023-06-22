
PROGRAM _INIT
	VarA;
	EasyUaSubscription_0.ServerEndpointUrl := 'opc.tcp://192.168.0.102:4840';
	EasyUaSubscription_0.NodeID.NamespaceIndex := 6;
	EasyUaSubscription_0.NodeID.Identifier := '::ServerTask:VarX';
	EasyUaSubscription_0.NodeID.IdentifierType := UAIdentifierType_String;
	EasyUaSubscription_0.Variable := '::Subs:VarA';
	EasyUaSubscription_0.PublishingInterval := T#500ms;
	EasyUaSubscription_0.Enable := TRUE;
END_PROGRAM

PROGRAM _CYCLIC
	EasyUaSubscription_0();
END_PROGRAM

PROGRAM _EXIT
	REPEAT
		EasyUaSubscription_0(Enable:=FALSE);
		UNTIL EasyUaSubscription_0.Active = FALSE 
	END_REPEAT;
END_PROGRAM

