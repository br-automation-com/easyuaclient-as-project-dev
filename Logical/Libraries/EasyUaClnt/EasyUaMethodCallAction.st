ACTION EasyUaMethodCall_CheckParameters:
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
	Internal.UA_MethodGetHandle_0.ObjectNodeID := ObjectNodeID;
	Internal.UA_MethodGetHandle_0.MethodNodeID := MethodNodeID;
	Internal.InputArguments := InputArguments;
	Internal.OutputArguments := OutputArguments;
	Active := TRUE;
	Busy := TRUE;
	Error := FALSE;
	StatusID := 0;		
	Internal.ParametersValid := TRUE;	
	Internal.Executing := TRUE;
END_ACTION

ACTION EasyUaMethodCall_CyclicCode:
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
					Internal.UA_MethodGetHandle_0.ObjectNodeID.NamespaceIndex := Internal.UA_GetNamespaceIndex_0.NamespaceIndex;
					Internal.UA_MethodGetHandle_0.MethodNodeID.NamespaceIndex := Internal.UA_GetNamespaceIndex_0.NamespaceIndex;
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
			Internal.UA_MethodGetHandle_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_MethodGetHandle_0.Busy = 0) THEN
				IF (Internal.UA_MethodGetHandle_0.Done = 1) THEN
					Internal.StatusID:= 0;
					Internal.MethodHdl := Internal.UA_MethodGetHandle_0.MethodHdl;
					Internal.Step := 3;
				END_IF
				IF (Internal.UA_MethodGetHandle_0.Error = 1) THEN
					Internal.StatusID:= Internal.UA_MethodGetHandle_0.ErrorID;
					Internal.MethodHdl := 0;
					Internal.Step := 253;
				END_IF
				Internal.UA_MethodGetHandle_0(Execute := FALSE);
			END_IF
		3:
			Internal.UA_MethodCall_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, MethodHdl := Internal.MethodHdl, Timeout := EASYUA_EXECUTE_TIMEOUT, 
			InputArguments := Internal.InputArguments, OutputArguments := Internal.OutputArguments);
			IF (Internal.UA_MethodCall_0.Busy = 0) THEN
				IF (Internal.UA_MethodCall_0.Done = 1) THEN
					Internal.StatusID:= 0;
					Internal.Step := 4;
				END_IF
				IF (Internal.UA_MethodCall_0.Error = 1) THEN
					Internal.StatusID:= Internal.UA_MethodCall_0.ErrorID;
					Internal.Step := 253;
				END_IF
				Internal.UA_MethodCall_0(Execute := FALSE, InputArguments := Internal.InputArguments, OutputArguments := Internal.OutputArguments);
			END_IF
		4:
			Internal.UA_MethodReleaseHandle_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, MethodHdl := Internal.MethodHdl, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_MethodReleaseHandle_0.Busy = 0) THEN
				IF (Internal.UA_MethodReleaseHandle_0.Done = 1) THEN
					Internal.StatusID:= 0;
					Internal.MethodHdl := 0;
					Internal.Step := 5;
				END_IF
				IF (Internal.UA_MethodReleaseHandle_0.Error = 1) THEN
					Internal.StatusID:= Internal.UA_MethodReleaseHandle_0.ErrorID;
					Internal.Step := 253;
				END_IF
				Internal.UA_MethodReleaseHandle_0(Execute := FALSE);
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
			EasyUaMethodCall_SetDone;
		253:
			Internal.UA_MethodReleaseHandle_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, MethodHdl := Internal.MethodHdl, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_MethodReleaseHandle_0.Busy = 0) THEN
				Internal.MethodHdl := 0;
				Internal.Step := 255;
				Internal.UA_MethodReleaseHandle_0(Execute := FALSE);
			END_IF;
		254:
			Internal.UA_Disconnect_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_Disconnect_0.Busy = 0) THEN
				Internal.ConnectionHdl := 0;
				Internal.Step := 255;
				Internal.UA_Disconnect_0(Execute := FALSE);
			END_IF;
		255:
			EasyUaMethodCall_SetError;
	END_CASE;
END_ACTION

ACTION EasyUaMethodCall_SetError:
	Internal.Executing := FALSE;
	Active := FALSE;
	Busy := FALSE;
	Done := FALSE;
	Error := TRUE;
	StatusID := Internal.StatusID;
END_ACTION

ACTION EasyUaMethodCall_SetDone:
	Internal.Executing := FALSE;
	Done := TRUE;
	Busy := FALSE;
	Active := FALSE;
END_ACTION

ACTION EasyUaMethodCall_ResetInternal:
	Internal.ExecuteOld := FALSE;
	Internal.Executing := FALSE;
	Internal.ParametersValid := FALSE;
	Internal.Step := 0;
	Internal.ConnectionHdl := 0;
	//	Internal.NamespaceIndex := 0;
	Internal.MethodHdl := 0;
	brsmemset(ADR(Internal.InputArguments),0,SIZEOF(Internal.InputArguments));
	brsmemset(ADR(Internal.OutputArguments),0,SIZEOF(Internal.OutputArguments));
	Internal.StatusID := 0;	
	Internal.UA_Connect_0(Execute:=FALSE);
	Internal.UA_GetNamespaceIndex_0(Execute:=FALSE);
	Internal.UA_MethodGetHandle_0(Execute := FALSE);
	Internal.UA_MethodCall_0(Execute := FALSE, InputArguments := Internal.InputArguments, OutputArguments := Internal.OutputArguments);
	Internal.UA_MethodReleaseHandle_0(Execute:=FALSE);
	Internal.UA_Disconnect_0(Execute:=FALSE);
END_ACTION

ACTION EasyUaMethodCall_ResetOutputs:
	Done := FALSE;
	Busy := FALSE;
	Active := FALSE;
	Error := FALSE;
	StatusID := 0;	
END_ACTION