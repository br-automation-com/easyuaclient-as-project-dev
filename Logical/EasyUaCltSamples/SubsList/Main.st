PROGRAM _INIT
	VarA;
	VarB;
	VarC;
	EasyUaSubscriptionList_0.ServerEndpointUrl := 'opc.tcp://192.168.0.102:4840';
	
	EasyUaSubscriptionList_0.NodeIDs[0].NamespaceIndex := 6;
	EasyUaSubscriptionList_0.NodeIDs[0].Identifier := '::ServerTask:VarX';
	EasyUaSubscriptionList_0.NodeIDs[0].IdentifierType := UAIdentifierType_String;
	
	EasyUaSubscriptionList_0.NodeIDs[1].NamespaceIndex := 6;
	EasyUaSubscriptionList_0.NodeIDs[1].Identifier := '::ServerTask:VarY';
	EasyUaSubscriptionList_0.NodeIDs[1].IdentifierType := UAIdentifierType_String;
	
	
	EasyUaSubscriptionList_0.NodeIDs[2].NamespaceIndex := 6;
	EasyUaSubscriptionList_0.NodeIDs[2].Identifier := '::ServerTask:VarZ';
	EasyUaSubscriptionList_0.NodeIDs[2].IdentifierType := UAIdentifierType_String;
	
	EasyUaSubscriptionList_0.Variables[0] := '::SubsList:VarA';
	EasyUaSubscriptionList_0.Variables[1] := '::SubsList:VarB';
	EasyUaSubscriptionList_0.Variables[2] := '::SubsList:VarC';
	
	EasyUaSubscriptionList_0.PublishingInterval := T#500ms;
	EasyUaSubscriptionList_0.Enable := TRUE;
END_PROGRAM

PROGRAM _CYCLIC
	EasyUaSubscriptionList_0(NodeIDCount := 3, NodeErrorIDs := NodeErrorIDs_0, TimeStamps := TimeStamps_0, ValuesChanged := ValuesChange_0, RemainingValueCount := RemainingValueCount_0, NodeQualityIDs := NodeQualityIDs_0);
END_PROGRAM

PROGRAM _EXIT
	REPEAT
		EasyUaSubscriptionList_0(Enable:= FALSE, NodeErrorIDs := NodeErrorIDs_0, TimeStamps := TimeStamps_0, ValuesChanged := ValuesChange_0, RemainingValueCount := RemainingValueCount_0, NodeQualityIDs := NodeQualityIDs_0);
		UNTIL EasyUaSubscriptionList_0.Active = FALSE 
	END_REPEAT;
END_PROGRAM
