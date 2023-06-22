ACTION EasyUaSubscription_CheckParameters:
	IF ADR(pSessionConnectInfo) = 0 THEN
		Internal.UA_Connect_0.SessionConnectInfo.SecurityMsgMode := UASecurityMsgMode_None;
		Internal.UA_Connect_0.SessionConnectInfo.SecurityPolicy := UASecurityPolicy_None;
		Internal.UA_Connect_0.SessionConnectInfo.TransportProfile := UATP_UATcp;
		Internal.UA_Connect_0.SessionConnectInfo.UserIdentityToken.UserIdentityTokenType := UAUITT_Anonymous;
		Internal.UA_Connect_0.SessionConnectInfo.SessionTimeout := T#1m;			
		Internal.UA_Connect_0.SessionConnectInfo.MonitorConnection := T#10s;
	ELSE
		Internal.UA_Connect_0.SessionConnectInfo := pSessionConnectInfo;
	END_IF;
	Internal.UA_Connect_0.ServerEndpointUrl := ServerEndpointUrl;
	Internal.UA_GetNamespaceIndex_0.NamespaceUri := NamespaceUri;
	Internal.UA_NodeGetHandle_0.NodeID := NodeID;
	IF ADR(pNodeAddInfo) = 0 THEN
		Internal.UA_MonitoredItemAdd_0.NodeAddInfo.AttributeId := UAAI_Value;
		Internal.UA_MonitoredItemAdd_0.NodeAddInfo.IndexRangeCount := 0;
	ELSE
		Internal.UA_MonitoredItemAdd_0.NodeAddInfo := pNodeAddInfo;
	END_IF;
	IF PublishingInterval = 0 THEN
		Internal.PublishingInterval := T#10ms;
	ELSE
		Internal.PublishingInterval := PublishingInterval;
	END_IF;
	IF Priority = 0 THEN
		Internal.UA_SubscriptionCreate_0.Priority := 10;
	ELSE
		Internal.UA_SubscriptionCreate_0.Priority := Priority;
	END_IF;
	IF ADR(pMonitoringSettings) = 0 THEN
		Internal.MonitoringSettings.SamplingInterval := T#10ms;
	ELSE
		Internal.MonitoringSettings := pMonitoringSettings;
	END_IF;
	Internal.Variable := Variable;
	Active := TRUE;
	Error := FALSE;
	StatusID := 0;		
	Internal.ParametersValid := TRUE;	
END_ACTION

ACTION EasyUaSubscription_CyclicCode:
	CASE Internal.Step OF
		0:
			Internal.UA_Connect_0(Execute := TRUE, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_Connect_0.Busy = 0) THEN
				IF (Internal.UA_Connect_0.Done = 1) THEN
					Internal.StatusID:= 0;
					Internal.ConnectionHdl := Internal.UA_Connect_0.ConnectionHdl;
					IF NamespaceUri = '' THEN
						Internal.Step := 2;
					ELSE
						Internal.Step := 1;
					END_IF;
				END_IF;
				IF (Internal.UA_Connect_0.Error = 1) THEN
					Internal.StatusID := Internal.UA_Connect_0.ErrorID;
					Internal.ConnectionHdl := 0;
					Internal.Step := 251;
				END_IF;
				Internal.UA_Connect_0(Execute := FALSE);
			END_IF;
		1:
			Internal.UA_GetNamespaceIndex_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_GetNamespaceIndex_0.Busy = 0) THEN
				IF (Internal.UA_GetNamespaceIndex_0.Done = 1) THEN
					Internal.StatusID := 0;
					Internal.UA_NodeGetHandle_0.NodeID.NamespaceIndex := Internal.UA_GetNamespaceIndex_0.NamespaceIndex;
					Internal.Step := 2;
				END_IF
				IF (Internal.UA_GetNamespaceIndex_0.Error = 1) THEN
					Internal.StatusID:= Internal.UA_GetNamespaceIndex_0.ErrorID;
					Internal.Step := 251;
				END_IF
				Internal.UA_GetNamespaceIndex_0(Execute := FALSE);
			END_IF
		2:
			Internal.UA_NodeGetHandle_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_NodeGetHandle_0.Busy = 0) THEN
				IF (Internal.UA_NodeGetHandle_0.Done = 1) THEN
					Internal.StatusID := 0;
					Internal.NodeHdl := Internal.UA_NodeGetHandle_0.NodeHdl;
					Internal.Step := 3;
				END_IF
				IF (Internal.UA_NodeGetHandle_0.Error = 1) THEN
					Internal.StatusID:= Internal.UA_NodeGetHandle_0.ErrorID;
					Internal.NodeHdl := 0;
					Internal.Step := 251;
				END_IF
				Internal.UA_NodeGetHandle_0(Execute := FALSE);
			END_IF
		3:
			Internal.UA_SubscriptionCreate_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, PublishingEnable := TRUE, Timeout := EASYUA_EXECUTE_TIMEOUT, PublishingInterval := Internal.PublishingInterval);
			IF (Internal.UA_SubscriptionCreate_0.Busy = 0) THEN
				IF (Internal.UA_SubscriptionCreate_0.Done = 1) THEN
					Internal.StatusID := 0;
					Internal.SubscriptionHdl := Internal.UA_SubscriptionCreate_0.SubscriptionHdl;
					Internal.Step := 4;
				END_IF
				IF (Internal.UA_SubscriptionCreate_0.Error = 1) THEN
					Internal.StatusID := Internal.UA_SubscriptionCreate_0.ErrorID;
					Internal.SubscriptionHdl := 0;
					Internal.Step := 251;
				END_IF
				Internal.UA_SubscriptionCreate_0(Execute := FALSE, PublishingInterval := Internal.PublishingInterval);
			END_IF
		4:
			Internal.UA_MonitoredItemAdd_0(Execute := TRUE, SubscriptionHdl := Internal.SubscriptionHdl, NodeHdl := Internal.NodeHdl, Timeout := EASYUA_EXECUTE_TIMEOUT, Variable := Internal.Variable, MonitoringSettings := Internal.MonitoringSettings);
			IF (Internal.UA_MonitoredItemAdd_0.Busy = 0) THEN
				IF (Internal.UA_MonitoredItemAdd_0.Done = 1) THEN
					Internal.StatusID := 0;
					Internal.MonitoredItemHdl := Internal.UA_MonitoredItemAdd_0.MonitoredItemHdl;
					Internal.Step := 5;
				END_IF
				IF (Internal.UA_MonitoredItemAdd_0.Error = 1) THEN
					Internal.StatusID := Internal.UA_MonitoredItemAdd_0.ErrorID;
					Internal.MonitoredItemHdl := 0;
					Internal.Step := 251;
				END_IF
				Internal.UA_MonitoredItemAdd_0(Execute := FALSE, Variable := Internal.Variable, MonitoringSettings := Internal.MonitoringSettings); 
			END_IF
		5:
			SubscriptionActive := TRUE;
			Internal.UA_MonitoredItemOperate_0(Execute := TRUE, MonitoredItemHdl := Internal.MonitoredItemHdl, Timeout := EASYUA_EXECUTE_TIMEOUT, MonitoringSettings := Internal.MonitoringSettings);
			IF (Internal.UA_MonitoredItemOperate_0.Busy = 0) THEN
				IF (Internal.UA_MonitoredItemOperate_0.Done = 1) THEN
					ValueChanged := Internal.UA_MonitoredItemOperate_0.ValueChanged;
					TimeStamp := Internal.UA_MonitoredItemOperate_0.TimeStamp;
					Internal.StatusID := 0;
				END_IF
				IF (Internal.UA_MonitoredItemOperate_0.Error = 1) THEN
					ValueChanged := FALSE;
					TimeStamp := 0;
					Internal.StatusID := Internal.UA_MonitoredItemOperate_0.ErrorID;
					Internal.Step := 251;
				END_IF
				Internal.UA_MonitoredItemOperate_0(Execute := FALSE, MonitoringSettings := Internal.MonitoringSettings);
			END_IF			
		251:
			Internal.UA_MonitoredItemRemove_0(Execute := TRUE, MonitoredItemHdl := Internal.MonitoredItemHdl, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_MonitoredItemRemove_0.Busy = 0) THEN
				Internal.MonitoredItemHdl := 0;
				Internal.Step := 252;
				Internal.UA_MonitoredItemRemove_0(Execute := FALSE);
			END_IF;
		252:
			Internal.UA_SubscriptionDelete_0(Execute := TRUE, SubscriptionHdl := Internal.SubscriptionHdl, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_SubscriptionDelete_0.Busy = 0) THEN
				Internal.SubscriptionHdl := 0;
				Internal.Step := 253;
				Internal.UA_SubscriptionDelete_0(Execute := FALSE);
			END_IF;
		253:
			Internal.UA_NodeReleaseHandle_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, NodeHdl := Internal.NodeHdl, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_NodeReleaseHandle_0.Busy = 0) THEN
				Internal.NodeHdl := 0;
				Internal.Step := 254;
				Internal.UA_NodeReleaseHandle_0(Execute := FALSE);
			END_IF;
		254:
			Internal.UA_Disconnect_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_Disconnect_0.Busy = 0) THEN
				Internal.ConnectionHdl := 0;
				Internal.Step := 255;
				Internal.UA_Disconnect_0(Execute := FALSE);				
			END_IF;

		255:
			EasyUaSubscription_SetError;

	END_CASE;
END_ACTION

ACTION EasyUaSubscription_SetError:
	Active := FALSE;
	Error := TRUE;	
	StatusID := Internal.StatusID;
END_ACTION

ACTION EasyUaSubscription_Disable:
	CASE Internal.Disable OF
		1:
			IF Internal.MonitoredItemHdl <> 0 THEN
				Internal.UA_MonitoredItemRemove_0(Execute := TRUE, MonitoredItemHdl := Internal.MonitoredItemHdl, Timeout := T#100ms);
				IF Internal.UA_MonitoredItemRemove_0.Busy = 0 THEN
					Internal.Disable := 2;
					SubscriptionActive := FALSE;
				END_IF;
			ELSE
				Internal.Disable := 2;
				SubscriptionActive := FALSE;
			END_IF;

		2:
			IF Internal.SubscriptionHdl <> 0 THEN
				Internal.UA_SubscriptionDelete_0(Execute := TRUE, SubscriptionHdl := Internal.SubscriptionHdl, Timeout := T#100ms);
				IF Internal.UA_SubscriptionDelete_0.Busy = 0 THEN
					Internal.Disable := 3; 
				END_IF;
			ELSE
				Internal.Disable := 3;
			END_IF;
		3:
			IF Internal.NodeHdl <> 0 THEN
				Internal.UA_NodeReleaseHandle_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, NodeHdl := Internal.NodeHdl, Timeout := T#100ms);
				IF Internal.UA_NodeReleaseHandle_0.Busy = 0 THEN
					Internal.Disable := 4;
				END_IF;
			ELSE
				Internal.Disable := 4;
			END_IF;
		4:
			IF Internal.ConnectionHdl <> 0 THEN
				Internal.UA_Disconnect_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, Timeout := T#100ms);
				IF Internal.UA_Disconnect_0.Busy = 0 THEN
					Internal.Disable := 5;
				END_IF;
			ELSE
				Internal.Disable := 5;
			END_IF;
	END_CASE;	  
END_ACTION

ACTION EasyUaSubscription_ResetInternal:
	Internal.EnableOld := FALSE;
	Internal.ParametersValid := FALSE;
	Internal.Step := 0;
	Internal.ConnectionHdl := 0;
	Internal.NodeHdl := 0;
	Internal.Variable := '';
	Internal.PublishingInterval := 0;
	Internal.SubscriptionHdl := 0;
	Internal.MonitoringSettings.Deadband := 0.0;
	Internal.MonitoringSettings.DeadbandType := UADeadbandType_None;
	Internal.MonitoringSettings.SamplingInterval := 0;
	Internal.MonitoredItemHdl := 0;
	Internal.StatusID := 0;
	Internal.Disable := 0;
	Internal.UA_Connect_0(Execute:=FALSE);
	Internal.UA_GetNamespaceIndex_0(Execute:=FALSE);
	Internal.UA_NodeGetHandle_0(Execute:=FALSE);
	Internal.UA_SubscriptionCreate_0(Execute := FALSE, PublishingInterval := Internal.PublishingInterval);
	Internal.UA_MonitoredItemAdd_0(Execute := FALSE, Variable := Internal.Variable, MonitoringSettings := Internal.MonitoringSettings);
	Internal.UA_MonitoredItemOperate_0(Execute := FALSE, MonitoringSettings := Internal.MonitoringSettings);
	Internal.UA_MonitoredItemRemove_0(Execute:=FALSE);
	Internal.UA_SubscriptionDelete_0(Execute:=FALSE);
	Internal.UA_NodeReleaseHandle_0(Execute:=FALSE);
	Internal.UA_Disconnect_0(Execute:=FALSE);
END_ACTION

ACTION EasyUaSubscription_ResetOutputs:
	Active := FALSE;
	Error := FALSE;
	StatusID := 0;
	SubscriptionActive := FALSE;
	ValueChanged := FALSE;
	TimeStamp := 0;
END_ACTION

	
