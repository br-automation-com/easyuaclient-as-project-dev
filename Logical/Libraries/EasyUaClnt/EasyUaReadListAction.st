ACTION EasyUaReadList_CheckParameters:
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
	IF ADR(pNodeAddInfo) = 0 THEN
		FOR Internal.Idx := 0 TO MAX_INDEX_MONITORLIST DO
			Internal.UA_ReadList_0.NodeAddInfo[Internal.Idx].AttributeId := UAAI_Value;
			Internal.UA_ReadList_0.NodeAddInfo[Internal.Idx].IndexRangeCount := 0;	
		END_FOR;
	ELSE
		Internal.UA_ReadList_0.NodeAddInfo := pNodeAddInfo;
	END_IF;
	Internal.Variables := Variables;
	(* Test *)
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
	Internal.UA_ReadList_0.NodeHdlCount := Internal.NodeIDCount;
	Internal.UA_NodeReleaseHandleList_0.NodeHdlCount := Internal.NodeIDCount;
	(* Test *)
	Active := TRUE;
	Busy := TRUE;
	Error := FALSE;
	StatusID := 0;		
	Internal.ParametersValid := TRUE;	
	Internal.Executing := TRUE;
END_ACTION

ACTION EasyUaReadList_CyclicCode:
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
					Internal.Step := 253;
				END_IF;
				Internal.UA_Connect_0(Execute := FALSE);
			END_IF;
		1:
			Internal.UA_GetNamespaceIndex_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_GetNamespaceIndex_0.Busy = 0) THEN
				IF (Internal.UA_GetNamespaceIndex_0.Done = 1) THEN
					Internal.StatusID:= 0;
					//					Internal.NamespaceIndex := Internal.UA_GetNamespaceIndex_0.NamespaceIndex;
					FOR Internal.Idx := 0 TO MAX_INDEX_NODELIST DO
						Internal.UA_NodeGetHandleList_0.NodeIDs[Internal.Idx].NamespaceIndex := Internal.UA_GetNamespaceIndex_0.NamespaceIndex;
					END_FOR;
					Internal.Step := 2;
				END_IF
				IF (Internal.UA_GetNamespaceIndex_0.Error = 1) THEN
					Internal.StatusID:= Internal.UA_GetNamespaceIndex_0.ErrorID;
					//					Internal.NamespaceIndex := 0;
					Internal.Step := 253;
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
					Internal.Step := 253;
				END_IF
				Internal.UA_NodeGetHandleList_0(Execute := FALSE);
			END_IF
		3:
			Internal.UA_ReadList_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, NodeHdls := Internal.NodeHdls, Timeout := EASYUA_EXECUTE_TIMEOUT, Variables := Internal.Variables);
			IF (Internal.UA_ReadList_0.Busy = 0) THEN
				NodeErrorIDs := Internal.UA_ReadList_0.NodeErrorIDs;
				IF (Internal.UA_ReadList_0.Done = 1) THEN
					Internal.StatusID:= 0;
					TimeStamps := Internal.UA_ReadList_0.TimeStamps;
					Internal.Step := 4;
				END_IF
				IF (Internal.UA_ReadList_0.Error = 1) THEN
					Internal.StatusID:= Internal.UA_ReadList_0.ErrorID;
					Internal.Step := 253;
				END_IF
				Internal.UA_ReadList_0(Execute := FALSE, Variables := Internal.Variables);
			END_IF
		4:
			Internal.UA_NodeReleaseHandleList_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, NodeHdls := Internal.NodeHdls, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_NodeReleaseHandleList_0.Busy = 0) THEN
				IF (Internal.UA_NodeReleaseHandleList_0.Done = 1) THEN
					Internal.StatusID:= 0;
					brsmemset(ADR(Internal.NodeHdls),0,SIZEOF(Internal.NodeHdls));
					Internal.Step := 5;
				END_IF
				IF (Internal.UA_NodeReleaseHandleList_0.Error = 1) THEN
					Internal.StatusID:= Internal.UA_NodeReleaseHandleList_0.ErrorID;
					Internal.Step := 253;
				END_IF
				Internal.UA_NodeReleaseHandleList_0(Execute := FALSE);
			END_IF
		5:
			Internal.UA_Disconnect_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_Disconnect_0.Busy = 0) THEN
				//				IF (Internal.UA_Disconnect_0.Done = 1) THEN
				Internal.StatusID := 0;
				Internal.ConnectionHdl := 0;
				Internal.Step := 100;
				//				END_IF;
				//				IF (Internal.UA_Disconnect_0.Error = 1) THEN 
				//					Internal.StatusID := Internal.UA_Disconnect_0.ErrorID;
				//				END_IF;
				Internal.UA_Disconnect_0(Execute := FALSE);
			END_IF;
		100:
			EasyUaReadList_SetDone;
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
			EasyUaReadList_SetError;
	END_CASE;
END_ACTION

ACTION EasyUaReadList_SetError:
	Internal.Executing := FALSE;
	Active := FALSE;
	Busy := FALSE;
	Done := FALSE;
	Error := TRUE;	
	StatusID := Internal.StatusID;
END_ACTION

ACTION EasyUaReadList_SetDone:
	Internal.Executing := FALSE;
	Done := TRUE;
	Busy := FALSE;
	Active := FALSE;
END_ACTION

ACTION EasyUaReadList_ResetInternal:
	Internal.ExecuteOld := FALSE;
	Internal.Executing := FALSE;
	Internal.ParametersValid := FALSE;
	Internal.Step := 0;
	Internal.ConnectionHdl := 0;
	//	Internal.NamespaceIndex := 0;
	brsmemset(ADR(Internal.NodeHdls),0,SIZEOF(Internal.NodeHdls));
	brsmemset(ADR(Internal.Variables),0,SIZEOF(Internal.Variables));
	Internal.Idx := 0;
	Internal.NodeIDCount := 0;
	Internal.StatusID := 0;
	Internal.UA_Connect_0(Execute:=FALSE);
	Internal.UA_GetNamespaceIndex_0(Execute:=FALSE);
	Internal.UA_NodeGetHandleList_0(Execute:=FALSE);
	Internal.UA_ReadList_0(Execute:=FALSE, Variables:=Internal.Variables);
	Internal.UA_NodeReleaseHandleList_0(Execute:=FALSE);
	Internal.UA_Disconnect_0(Execute:=FALSE);
END_ACTION

ACTION EasyUaReadList_ResetOutputs:
	Done := FALSE;
	Busy := FALSE;
	Active := FALSE;
	Error := FALSE;
	StatusID := 0;
	brsmemset(ADR(NodeErrorIDs),0,SIZEOF(NodeErrorIDs));
	brsmemset(ADR(TimeStamps),0,SIZEOF(TimeStamps));
END_ACTION