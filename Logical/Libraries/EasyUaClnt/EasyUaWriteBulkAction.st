ACTION EasyUaWriteBulk_CheckParameters:
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
	Internal.UaClt_WriteBulk_0.NodeIDCount := NodeIDCount;
	Internal.UaClt_WriteBulk_0.NodeIDs := NodeIDs;
	IF ADR(NodeAddInfo) <> 0 THEN
		Internal.UaClt_WriteBulk_0.NodeAddInfo := NodeAddInfo;
	END_IF;
	Internal.UaClt_WriteBulk_0.Variables := Variables;
	Internal.UaClt_WriteBulk_0.NodeErrorIDs := NodeErrorIDs;
	Internal.NodeIDsAdr := NodeIDs;
	Internal.NodeIDsLen := NodeIDsLen;
	Active := TRUE;
	Busy := TRUE;
	Error := FALSE;
	StatusID := 0;		
	Internal.ParametersValid := TRUE;	
	Internal.Executing := TRUE;
END_ACTION

ACTION EasyUaWriteBulk_CyclicCode:
	CASE Internal.Step OF
		0:
			Internal.UA_Connect_0(Execute := TRUE, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_Connect_0.Busy = 0) THEN
				IF (Internal.UA_Connect_0.Done = 1) THEN
					Internal.StatusID:= 0;
					Internal.ConnectionHdl := Internal.UA_Connect_0.ConnectionHdl;
					IF NamespaceUri = '' THEN
						Internal.Step := 3;
					ELSE
						Internal.Step := 1;		
					END_IF;
				END_IF;
				IF (Internal.UA_Connect_0.Error = 1) THEN
					Internal.StatusID := Internal.UA_Connect_0.ErrorID;
					Internal.ConnectionHdl := 0;
					Internal.Step := 254;
				END_IF;
				Internal.UA_Connect_0(Execute := FALSE);
			END_IF;
		1:
			Internal.UA_GetNamespaceIndex_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_GetNamespaceIndex_0.Busy = 0) THEN
				IF (Internal.UA_GetNamespaceIndex_0.Done = 1) THEN
					Internal.StatusID:= 0;
					Internal.NamespaceIndex := Internal.UA_GetNamespaceIndex_0.NamespaceIndex;
					Internal.Step := 2;
				END_IF
				IF (Internal.UA_GetNamespaceIndex_0.Error = 1) THEN
					Internal.StatusID:= Internal.UA_GetNamespaceIndex_0.ErrorID;
					Internal.NamespaceIndex := 0;
					Internal.Step := 254;
				END_IF
				Internal.UA_GetNamespaceIndex_0(Execute := FALSE);
			END_IF
		2:
			IF Internal.UaClt_WriteBulk_0.NodeIDCount = 0 OR Internal.UaClt_WriteBulk_0.NodeIDs = 0 THEN
				Internal.Step := 3;
			ELSE
				IF Internal.NodeIDsLen <> 0 AND Internal.NodeIDsAdr <> 0 THEN
					IF  (Internal.NodeIDsLen/SIZEOF(UANodeID)) >= Internal.UaClt_WriteBulk_0.NodeIDCount THEN
						FOR Internal.Idx := 0 TO Internal.UaClt_WriteBulk_0.NodeIDCount - 1 DO
							brsmemcpy(Internal.NodeIDsAdr+Internal.Idx*SIZEOF(UANodeID), ADR(Internal.NamespaceIndex), SIZEOF(Internal.NamespaceIndex));
						END_FOR;
					ELSE
						Internal.UaClt_WriteBulk_0.NodeIDCount := UDINT_TO_UINT(Internal.NodeIDsLen/SIZEOF(UANodeID));
						FOR Internal.Idx := 0 TO ((Internal.NodeIDsLen/SIZEOF(UANodeID))-1) DO
							brsmemcpy(Internal.NodeIDsAdr+Internal.Idx*SIZEOF(UANodeID), ADR(Internal.NamespaceIndex), SIZEOF(Internal.NamespaceIndex));
						END_FOR;
					END_IF;
				END_IF;
				Internal.Step := 3;
			END_IF;
		
		3:
			Internal.UaClt_WriteBulk_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UaClt_WriteBulk_0.Busy = 0) THEN
				IF (Internal.UaClt_WriteBulk_0.Done = 1) THEN
					Internal.StatusID:= 0;
					Internal.Step := 4;
				END_IF
				IF (Internal.UaClt_WriteBulk_0.Error = 1) THEN
					Internal.StatusID:= Internal.UaClt_WriteBulk_0.ErrorID;
					Internal.Step := 254;
				END_IF
				Internal.UaClt_WriteBulk_0(Execute := FALSE);
			END_IF;
		4:
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
			EasyUaWriteBulk_SetDone;
		254:
			Internal.UA_Disconnect_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_Disconnect_0.Busy = 0) THEN
				Internal.ConnectionHdl := 0;
				Internal.Step := 255;
				Internal.UA_Disconnect_0(Execute := FALSE);
			END_IF;
		255:
			EasyUaWriteBulk_SetError;
	END_CASE;
END_ACTION

ACTION EasyUaWriteBulk_SetError:
	Internal.Executing := FALSE;
	Active := FALSE;
	Busy := FALSE;
	Done := FALSE;
	Error := TRUE;
	StatusID := Internal.StatusID;
END_ACTION

ACTION EasyUaWriteBulk_SetDone:
	Internal.Executing := FALSE;
	Done := TRUE;
	Busy := FALSE;
	Active := FALSE;
END_ACTION

ACTION EasyUaWriteBulk_ResetInternal:
	Internal.ExecuteOld := FALSE;
	Internal.Executing := FALSE;
	Internal.ParametersValid := FALSE;
	Internal.Step := 0;
	Internal.ConnectionHdl := 0;
	Internal.NamespaceIndex := 0;
	Internal.Idx := 0;
	Internal.NodeIDsAdr := 0;
	Internal.NodeIDsLen := 0;
	Internal.StatusID := 0;
	Internal.UA_Connect_0(Execute:=FALSE);
	Internal.UA_GetNamespaceIndex_0(Execute:=FALSE);
	Internal.UaClt_WriteBulk_0(Execute:=FALSE);
	Internal.UA_Disconnect_0(Execute:=FALSE);
END_ACTION

ACTION EasyUaWriteBulk_ResetOutputs:
	Done := FALSE;
	Busy := FALSE;
	Active := FALSE;
	Error := FALSE;
	StatusID := 0;
END_ACTION