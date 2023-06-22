ACTION EasyUaSubscriptionList_CheckParameters:
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
	Internal.UA_NodeGetHandleList_0.NodeIDs := NodeIDs;
	IF ADR(pNodeAddInfos) = 0 THEN
		FOR Internal.Idx := 0 TO MAX_INDEX_MONITORLIST DO
			Internal.UA_MonitoredItemAddList_0.NodeAddInfos[Internal.Idx].AttributeId := UAAI_Value;
			Internal.UA_MonitoredItemAddList_0.NodeAddInfos[Internal.Idx].IndexRangeCount := 0;	
		END_FOR;
	ELSE
		Internal.UA_MonitoredItemAddList_0.NodeAddInfos := pNodeAddInfos;
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
		FOR Internal.Idx := 0 TO MAX_INDEX_MONITORLIST DO
			Internal.MonitoringSettings[Internal.Idx].SamplingInterval := T#10ms;
		END_FOR;
	ELSE
		Internal.MonitoringSettings := pMonitoringSettings;
	END_IF;
	FOR Internal.Idx := 0 TO MAX_INDEX_MONITORLIST DO
		Internal.MonitoringSettings[Internal.Idx].QueueSize := 0;
	END_FOR;
	Internal.Variables := Variables;
	Internal.NodeIDCount := 0;
	FOR Internal.Idx := 0 TO MAX_INDEX_NODELIST DO
		IF NodeIDs[Internal.Idx].Identifier <> '' THEN
			Internal.NodeIDCount := Internal.NodeIDCount + 1;
		ELSE
			EXIT;
		END_IF;
	END_FOR;
	IF NodeIDCount <= Internal.NodeIDCount THEN
		Internal.NodeIDCount := NodeIDCount;
	END_IF;
	Internal.UA_NodeGetHandleList_0.NodeIDCount := Internal.NodeIDCount;
	Internal.UA_MonitoredItemAddList_0.NodeHdlCount := Internal.NodeIDCount;
//	Internal.UA_MonitoredItemOperateList_0.MonitoredItemHdlCount := Internal.NodeIDCount;
	Internal.UA_MonitoredItemRemoveList_0.MonitoredItemHdlCount := Internal.NodeIDCount;
	Internal.UA_NodeReleaseHandleList_0.NodeHdlCount := Internal.NodeIDCount;
	Active := TRUE;
	Error := FALSE;
	StatusID := 0;		
	Internal.ParametersValid := TRUE;	
END_ACTION

ACTION EasyUaSubscriptionList_CyclicCode:
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
					Internal.StatusID:= 0;
					FOR Internal.Idx := 0 TO MAX_INDEX_NODELIST DO
						Internal.UA_NodeGetHandleList_0.NodeIDs[Internal.Idx].NamespaceIndex := Internal.UA_GetNamespaceIndex_0.NamespaceIndex;
					END_FOR;
					Internal.Step := 2;
				END_IF
				IF (Internal.UA_GetNamespaceIndex_0.Error = 1) THEN
					Internal.StatusID:= Internal.UA_GetNamespaceIndex_0.ErrorID;
					Internal.Step := 251;
				END_IF
				Internal.UA_GetNamespaceIndex_0(Execute := FALSE);
			END_IF
		2:
			Internal.UA_NodeGetHandleList_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_NodeGetHandleList_0.Busy = 0) THEN
				NodeErrorIDs := Internal.UA_NodeGetHandleList_0.NodeErrorIDs;
				IF (Internal.UA_NodeGetHandleList_0.Done = 1) THEN
					Internal.StatusID:= 0;
					Internal.NodeHdls := Internal.UA_NodeGetHandleList_0.NodeHdls;
					Internal.Step := 3;
				END_IF
				IF (Internal.UA_NodeGetHandleList_0.Error = 1) THEN
					Internal.StatusID:= Internal.UA_NodeGetHandleList_0.ErrorID;
					brsmemset(ADR(Internal.NodeHdls),0,SIZEOF(Internal.NodeHdls));
					Internal.Step := 251;
				END_IF
				Internal.UA_NodeGetHandleList_0(Execute := FALSE);
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
			Internal.UA_MonitoredItemAddList_0(Execute := TRUE, SubscriptionHdl := Internal.SubscriptionHdl, NodeHdls := Internal.NodeHdls, Timeout := EASYUA_EXECUTE_TIMEOUT, Variables := Variables, MonitoringSettings := Internal.MonitoringSettings,
			ValuesChanged := ValuesChanged, RemainingValueCount := RemainingValueCount, TimeStamps := TimeStamps, NodeQualityIDs := NodeQualityIDs);
			IF (Internal.UA_MonitoredItemAddList_0.Busy = 0) THEN
				NodeErrorIDs := Internal.UA_MonitoredItemAddList_0.NodeErrorIDs;
				IF (Internal.UA_MonitoredItemAddList_0.Done = 1) THEN
					Internal.StatusID := 0;
					Internal.MonitoredItemHdls := Internal.UA_MonitoredItemAddList_0.MonitoredItemHdls;
					Internal.Step := 5;
				END_IF
				IF (Internal.UA_MonitoredItemAddList_0.Error = 1) THEN
					Internal.StatusID := Internal.UA_MonitoredItemAddList_0.ErrorID;
					brsmemset(ADR(Internal.MonitoredItemHdls),0,SIZEOF(Internal.MonitoredItemHdls));
					Internal.Step := 251;
				END_IF
				Internal.UA_MonitoredItemAddList_0(Execute := FALSE, Variables := Internal.Variables, MonitoringSettings := Internal.MonitoringSettings,
				ValuesChanged := ValuesChanged, RemainingValueCount := RemainingValueCount, TimeStamps := TimeStamps, NodeQualityIDs := NodeQualityIDs); 
			END_IF
		5:			
			SubscriptionListActive := TRUE;
//			Internal.UA_MonitoredItemOperateList_0(Execute := TRUE, SubscriptionHdl := Internal.SubscriptionHdl, MonitoredItemHdls := Internal.MonitoredItemHdls);
//			IF (Internal.UA_MonitoredItemOperateList_0.Busy = 0) THEN
//				NodeErrorIDs := Internal.UA_MonitoredItemOperateList_0.NodeErrorIDs;
//				IF (Internal.UA_MonitoredItemOperateList_0.Done = 1) THEN
//					Internal.StatusID := 0;
//				END_IF
//				IF (Internal.UA_MonitoredItemOperateList_0.Error = 1 AND Internal.UA_MonitoredItemOperateList_0.ErrorID <> 0) THEN
////					brsmemset(ADR(ValuesChanged),0,SIZEOF(ValuesChanged));
////					brsmemset(ADR(RemainingValueCount),0,SIZEOF(RemainingValueCount));
////					brsmemset(ADR(TimeStamps),0,SIZEOF(TimeStamps));
////					brsmemset(ADR(NodeQualityIDs),0,SIZEOF(NodeQualityIDs));
//					Internal.StatusID := Internal.UA_MonitoredItemOperateList_0.ErrorID;
//					Internal.Step := 251;
//				END_IF
//				Internal.UA_MonitoredItemOperateList_0(Execute := FALSE);
//			END_IF
			
		251:
			Internal.UA_MonitoredItemRemoveList_0(Execute := TRUE, SubscriptionHdl := Internal.SubscriptionHdl, MonitoredItemHdls := Internal.MonitoredItemHdls, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_MonitoredItemRemoveList_0.Busy = 0) THEN
				brsmemset(ADR(Internal.MonitoredItemHdls),0,SIZEOF(Internal.MonitoredItemHdls));
				Internal.Step := 252;
				Internal.UA_MonitoredItemRemoveList_0(Execute := FALSE);
			END_IF;
		252:
			Internal.UA_SubscriptionDelete_0(Execute := TRUE, SubscriptionHdl := Internal.SubscriptionHdl, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_SubscriptionDelete_0.Busy = 0) THEN
				Internal.SubscriptionHdl := 0;
				Internal.Step := 253;
				Internal.UA_SubscriptionDelete_0(Execute := FALSE);
			END_IF;
		253:
			Internal.UA_NodeReleaseHandleList_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, NodeHdls := Internal.NodeHdls, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_NodeReleaseHandleList_0.Busy = 0) THEN
				brsmemset(ADR(Internal.NodeHdls),0,SIZEOF(Internal.NodeHdls));
				Internal.Step := 254;
				Internal.UA_NodeReleaseHandleList_0(Execute := FALSE);
			END_IF;
		254:
			Internal.UA_Disconnect_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_Disconnect_0.Busy = 0) THEN
				Internal.ConnectionHdl := 0;
				Internal.Step := 255;
				Internal.UA_Disconnect_0(Execute := FALSE);
			END_IF;
		255:
			EasyUaSubscriptionList_SetError;
	END_CASE;	
END_ACTION

ACTION EasyUaSubscriptionList_SetError:
	Active := FALSE;
	Error := TRUE;
	StatusID := Internal.StatusID;
END_ACTION

ACTION EasyUaSubscriptionList_Disable:
	CASE Internal.Disable OF
		1:
			IF Internal.MonitoredItemHdls[0] <> 0 THEN
				Internal.UA_MonitoredItemRemoveList_0(Execute := TRUE, SubscriptionHdl := Internal.SubscriptionHdl, MonitoredItemHdls := Internal.MonitoredItemHdls, Timeout := T#100ms);
				IF Internal.UA_MonitoredItemRemoveList_0.Busy = 0 THEN
					Internal.Disable := 2;
					SubscriptionListActive := FALSE;
				END_IF;
			ELSE
				Internal.Disable := 2;
				SubscriptionListActive := FALSE;
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
			IF Internal.NodeHdls[0] <> 0 THEN
				Internal.UA_NodeReleaseHandleList_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, NodeHdls := Internal.NodeHdls, Timeout := T#100ms);
				IF Internal.UA_NodeReleaseHandleList_0.Busy = 0 THEN
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

ACTION EasyUaSubscriptionList_ResetInternal:
	Internal.EnableOld := FALSE;
	Internal.ParametersValid := FALSE;
	Internal.Step := 0;
	Internal.ConnectionHdl := 0;
	brsmemset(ADR(Internal.NodeHdls),0,SIZEOF(Internal.NodeHdls));
	brsmemset(ADR(Internal.Variables),0,SIZEOF(Internal.Variables));
	Internal.PublishingInterval := 0;
	Internal.SubscriptionHdl := 0;
	brsmemset(ADR(Internal.MonitoringSettings),0,SIZEOF(Internal.MonitoringSettings));
	brsmemset(ADR(Internal.MonitoredItemHdls),0,SIZEOF(Internal.MonitoredItemHdls));
	Internal.Idx := 0;
	Internal.NodeIDCount := 0;
	Internal.StatusID := 0;
	Internal.Disable := 0;
	Internal.UA_Connect_0(Execute:=FALSE);
	Internal.UA_GetNamespaceIndex_0(Execute:=FALSE);
	Internal.UA_NodeGetHandleList_0(Execute:=FALSE);
	Internal.UA_SubscriptionCreate_0(Execute := FALSE, PublishingInterval := Internal.PublishingInterval);
	Internal.UA_MonitoredItemAddList_0(Execute := FALSE, Variables := Internal.Variables, MonitoringSettings := Internal.MonitoringSettings,
	ValuesChanged := ValuesChanged, RemainingValueCount := RemainingValueCount, TimeStamps := TimeStamps, NodeQualityIDs := NodeQualityIDs);
	//	Internal.UA_MonitoredItemOperateList_0(Execute := FALSE);
	Internal.UA_MonitoredItemRemoveList_0(Execute:=FALSE);
	Internal.UA_SubscriptionDelete_0(Execute:=FALSE);
	Internal.UA_NodeReleaseHandleList_0(Execute:=FALSE);
	Internal.UA_Disconnect_0(Execute:=FALSE);
END_ACTION

ACTION EasyUaSubscriptionList_ResetOutputs:
	Active := FALSE;
	Error := FALSE;
	StatusID := 0;
	SubscriptionListActive := FALSE;
	brsmemset(ADR(ValuesChanged),0,SIZEOF(ValuesChanged));
	brsmemset(ADR(RemainingValueCount),0,SIZEOF(RemainingValueCount));
	brsmemset(ADR(TimeStamps),0,SIZEOF(TimeStamps));
	brsmemset(ADR(NodeErrorIDs),0,SIZEOF(NodeErrorIDs));
	brsmemset(ADR(NodeQualityIDs),0,SIZEOF(NodeQualityIDs));
END_ACTION

	
