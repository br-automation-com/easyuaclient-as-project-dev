ACTION EasyUaConnectionGetStatus_CheckParameters:
	IF ADR(pSessionConnectInfo) = 0 THEN
		Internal.UA_Connect_0.SessionConnectInfo.SecurityMsgMode := UASecurityMsgMode_None;
		Internal.UA_Connect_0.SessionConnectInfo.SecurityPolicy := UASecurityPolicy_None;
		Internal.UA_Connect_0.SessionConnectInfo.TransportProfile := UATP_UATcp;
		Internal.UA_Connect_0.SessionConnectInfo.UserIdentityToken.UserIdentityTokenType := UAUITT_Anonymous;
		Internal.UA_Connect_0.SessionConnectInfo.SessionTimeout := T#1m;			
		Internal.UA_Connect_0.SessionConnectInfo.MonitorConnection := T#10s;
	ELSE
		Internal.UA_Connect_0.SessionConnectInfo.SecurityMsgMode := pSessionConnectInfo.SecurityMsgMode;
		Internal.UA_Connect_0.SessionConnectInfo.SecurityPolicy := pSessionConnectInfo.SecurityPolicy;
		Internal.UA_Connect_0.SessionConnectInfo.TransportProfile := pSessionConnectInfo.TransportProfile;
		Internal.UA_Connect_0.SessionConnectInfo.UserIdentityToken.UserIdentityTokenType := pSessionConnectInfo.UserIdentityToken.UserIdentityTokenType;
		Internal.UA_Connect_0.SessionConnectInfo.SessionTimeout := pSessionConnectInfo.SessionTimeout;			
		Internal.UA_Connect_0.SessionConnectInfo.MonitorConnection := pSessionConnectInfo.MonitorConnection;
	END_IF;
	Internal.UA_Connect_0.ServerEndpointUrl := ServerEndpointUrl;
	Internal.ParametersValid := TRUE;
	Active := TRUE;
	Busy := TRUE;
	Error := FALSE;
	StatusID := 0;		
	Internal.ParametersValid := TRUE;	
	Internal.Executing := TRUE;
END_ACTION

ACTION EasyUaConnectionGetStatus_CyclicCode:
	CASE Internal.Step OF
		0:
			Internal.UA_Connect_0(Execute := TRUE, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_Connect_0.Busy = 0) THEN
				IF (Internal.UA_Connect_0.Done = 1) THEN
					Internal.StatusID:= 0;
					Internal.ConnectionHdl := Internal.UA_Connect_0.ConnectionHdl;
					Internal.Step := 1;
				END_IF;
				IF (Internal.UA_Connect_0.Error = 1) THEN
					Internal.StatusID := Internal.UA_Connect_0.ErrorID;
					Internal.ConnectionHdl := 0;
					ConnectionStatus := UACS_ConnectionError;
					ServerState := UASS_Unknown;
					ServiceLevel := 0;
					Internal.Step := 254;
				END_IF;
				Internal.UA_Connect_0(Execute := FALSE);
			END_IF;
		1:
			Internal.UA_ConnectionGetStatus_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_ConnectionGetStatus_0.Busy = 0) THEN
				IF (Internal.UA_ConnectionGetStatus_0.Done = 1) THEN
					Internal.StatusID := 0;
					ConnectionStatus := Internal.UA_ConnectionGetStatus_0.ConnectionStatus;
					ServerState := Internal.UA_ConnectionGetStatus_0.ServerState;
					ServiceLevel := Internal.UA_ConnectionGetStatus_0.ServiceLevel;
					Internal.Step := 2;
				END_IF;
				IF (Internal.UA_ConnectionGetStatus_0.Error = 1) THEN
					Internal.StatusID := Internal.UA_ConnectionGetStatus_0.ErrorID;
					ConnectionStatus := UACS_ConnectionError;
					ServerState := UASS_Unknown;
					ServiceLevel := 0;
					Internal.Step := 254;
				END_IF;
				Internal.UA_ConnectionGetStatus_0(Execute := FALSE);
			END_IF;
		2:
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
			EasyUaConnectionGetStatus_SetDone;
			
		254:
			Internal.UA_Disconnect_0(Execute := TRUE, ConnectionHdl := Internal.ConnectionHdl, Timeout := EASYUA_EXECUTE_TIMEOUT);
			IF (Internal.UA_Disconnect_0.Busy = 0) THEN
				Internal.ConnectionHdl := 0;
				Internal.Step := 255;
				Internal.UA_Disconnect_0(Execute := FALSE);
			END_IF;
		
		255:
			EasyUaConnectionGetStatus_SetError;
	END_CASE;
END_ACTION

ACTION EasyUaConnectionGetStatus_SetError:
	Internal.Executing := FALSE;
	Active := FALSE;
	Busy := FALSE;
	Done := FALSE;
	Error := TRUE;
	StatusID := Internal.StatusID;
END_ACTION

ACTION EasyUaConnectionGetStatus_SetDone:
	Internal.Executing := FALSE;
	Done := TRUE;
	Busy := FALSE;
	Active := FALSE;			
END_ACTION

ACTION EasyUaConnectionGetStatus_ResetInternal:
	Internal.ConnectionHdl := 0;
	Internal.ExecuteOld := FALSE;
	Internal.Executing := FALSE;
	Internal.ParametersValid := FALSE;
	Internal.Step := 0;
	Internal.StatusID := 0;
	Internal.UA_ConnectionGetStatus_0(Execute:=FALSE);
	Internal.UA_Connect_0(Execute:=FALSE);
	Internal.UA_Disconnect_0(Execute:=FALSE);
END_ACTION

ACTION EasyUaConnectionGetStatus_ResetOutputs:
	Done := FALSE;
	Busy := FALSE;
	Active := FALSE;
	Error := FALSE;
	StatusID := 0;
	ConnectionStatus := UACS_ConnectionError;
	ServerState := UASS_Unknown;
	ServiceLevel := 0;
END_ACTION