
{REDUND_UNREPLICABLE} FUNCTION_BLOCK EasyUaConnectionGetStatus (*Queries connection information*)
	VAR_INPUT
		Execute : {REDUND_UNREPLICABLE} BOOL; (*Execute the function block*) (* *) (*#PAR*)
		ServerEndpointUrl : {REDUND_UNREPLICABLE} STRING[255]; (*Server endpoint URL specified in the syntax opc.tcp://IP address:Port*) (* *) (*#PAR*)
		pSessionConnectInfo : REFERENCE TO UASessionConnectInfo; (*Reference to structure UASessionConnectInfo *) (* *) (*#PAR#OPT*)
	END_VAR
	VAR_OUTPUT
		Done : {REDUND_UNREPLICABLE} BOOL; (*Execute is done*) (* *) (*#PAR*)
		Busy : {REDUND_UNREPLICABLE} BOOL; (*Function block is busy*) (* *) (*#PAR*)
		Active : {REDUND_UNREPLICABLE} BOOL; (*Function block is active*) (* *) (*#PAR*)
		Error : {REDUND_UNREPLICABLE} BOOL; (*Indicates an error*) (* *) (*#PAR*)
		StatusID : {REDUND_UNREPLICABLE} DWORD; (*Status information*) (* *) (*#PAR*)
		ConnectionStatus : {REDUND_UNREPLICABLE} UAConnectionStatus; (*Status of the connection, see UAConnectionStatus. Outputs "ServerState" and "ServiceLevel" are only valid if ConnectionStatus = UACS_Connected.*) (* *) (*#PAR*)
		ServerState : {REDUND_UNREPLICABLE} UAServerState; (*Status of the server, see UAServerState.*) (* *) (*#PAR*)
		ServiceLevel : {REDUND_UNREPLICABLE} BYTE; (*ServiceLevel" describes the server's ability to provide the client with data.*) (* *) (*#PAR*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} EasyUaConnGetStatusInternalType; (*Data for internal use*) (* *) (*#OMIT*)
	END_VAR
END_FUNCTION_BLOCK

{REDUND_UNREPLICABLE} FUNCTION_BLOCK EasyUaRead (*Reads the value of a variable on a single node on the OPC UA server*)
	VAR_INPUT
		Execute : {REDUND_UNREPLICABLE} BOOL; (*Execute the function block*) (* *) (*#PAR*)
		ServerEndpointUrl : {REDUND_UNREPLICABLE} STRING[255]; (*Server endpoint URL specified in the syntax opc.tcp://IP address:Port*) (* *) (*#PAR*)
		pSessionConnectInfo : REFERENCE TO UASessionConnectInfo; (*Reference to structure UASessionConnectInfo *) (* *) (*#PAR#OPT*)
		NamespaceUri : {REDUND_UNREPLICABLE} STRING[255]; (*Specifies the namespace URI. Example: "urn:B&R/pv/". If not specified the NodeID.NamespaceIndex is used*) (* *) (*#PAR#OPT*)
		NodeID : {REDUND_UNREPLICABLE} UANodeID; (*NodeID, identification of the node. For information about the structure, see UANodeID in AsOpcUac Automation Studio Help*) (* *) (*#PAR*)
		pNodeAddInfo : REFERENCE TO UANodeAdditionalInfo; (*Additional parameters for specifying the node.For information about the structure, see UANodeAdditionalInfo.*) (* *) (*#PAR#OPT*)
		Variable : {REDUND_UNREPLICABLE} STRING[255]; (* Name of the variable on the controller in the syntax Application module::Task:Variable.Element*) (* *) (*#PAR*)
	END_VAR
	VAR_OUTPUT
		Done : {REDUND_UNREPLICABLE} BOOL; (*Execute is done*) (* *) (*#PAR*)
		Busy : {REDUND_UNREPLICABLE} BOOL; (*Function block is busy*) (* *) (*#PAR*)
		Active : {REDUND_UNREPLICABLE} BOOL; (*Function block is active*) (* *) (*#PAR*)
		Error : {REDUND_UNREPLICABLE} BOOL; (*Indicates an error*) (* *) (*#PAR*)
		StatusID : {REDUND_UNREPLICABLE} DWORD; (*Status information*) (* *) (*#PAR*)
		TimeStamp : {REDUND_UNREPLICABLE} DATE_AND_TIME; (*Timestamp of the read node.*) (* *) (*#PAR*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} EasyUaReadInternalType; (*Data for internal use*) (* *) (*#OMIT*)
	END_VAR
END_FUNCTION_BLOCK

{REDUND_UNREPLICABLE} FUNCTION_BLOCK EasyUaReadList (*Reads the values of the variables on a list of nodes on the OPC UA server*)
	VAR_INPUT
		Execute : {REDUND_UNREPLICABLE} BOOL; (*Execute the function block*) (* *) (*#PAR*)
		ServerEndpointUrl : {REDUND_UNREPLICABLE} STRING[255]; (*Server endpoint URL specified in the syntax opc.tcp://IP address:Port*) (* *) (*#PAR*)
		pSessionConnectInfo : REFERENCE TO UASessionConnectInfo; (*Reference to structure UASessionConnectInfo *) (* *) (*#PAR#OPT*)
		NamespaceUri : {REDUND_UNREPLICABLE} STRING[255]; (*Specifies the namespace URI. Example: "urn:B&R/pv/". If not specified the NodeID[].NamespaceIndex is used*) (* *) (*#PAR#OPT*)
		NodeIDCount : {REDUND_UNREPLICABLE} UINT; (*Number of nodes in the list to be read. The maximum number is limited by the server limit. Only the number of configued NodeIDs must be used, otherwise, undefined behavior, access violations and a controller restart can occur*) (* *) (*#PAR*)
		NodeIDs : {REDUND_UNREPLICABLE} ARRAY[0..MAX_INDEX_NODELIST] OF UANodeID; (*List of NodeIDs for the identification of nodes. For information about the structure, see UANodeID  in AsOpcUac Automation Studio Help*)
		pNodeAddInfo : REFERENCE TO ARRAY[0..MAX_INDEX_NODELIST] OF UANodeAdditionalInfo; (*Additional parameters for specifying the node.For information about the structure, see UANodeAdditionalInfo in AsOpcUac Automation Studio Help*) (* *) (*#PAR#OPT*)
		Variables : {REDUND_UNREPLICABLE} ARRAY[0..MAX_INDEX_NODELIST] OF STRING[255]; (* Name of the variables on the controller in the syntax Application module::Task:Variable.Element*) (* *) (*#PAR*)
	END_VAR
	VAR_OUTPUT
		Done : {REDUND_UNREPLICABLE} BOOL; (*Execute is done*) (* *) (*#PAR*)
		Busy : {REDUND_UNREPLICABLE} BOOL; (*Function block is busy*) (* *) (*#PAR*)
		Active : {REDUND_UNREPLICABLE} BOOL; (*Function block is active*) (* *) (*#PAR*)
		Error : {REDUND_UNREPLICABLE} BOOL; (*At least one node of the list has an error or there was a fub execution error. If StatusID = 0 check NodeErrorIDs.*) (* *) (*#PAR*)
		StatusID : {REDUND_UNREPLICABLE} DWORD; (*Status information*) (* *) (*#PAR*)
	END_VAR
	VAR_IN_OUT
		NodeErrorIDs : ARRAY[0..MAX_INDEX_NODELIST] OF DWORD; (*Error codes the of nodes. See OPC UA StatusCode in AsOpcUac Automation Studio Help*) (* *) (*#PAR*)
		TimeStamps : ARRAY[0..MAX_INDEX_NODELIST] OF DATE_AND_TIME; (*Timestamp of the read nodes*) (* *) (*#PAR*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} EasyUaReadListInternalType; (*Data for internal use*) (* *) (*#OMIT*)
	END_VAR
END_FUNCTION_BLOCK

{REDUND_UNREPLICABLE} FUNCTION_BLOCK EasyUaWrite (*Writes the value of a variable to a single node on the OPC UA server*)
	VAR_INPUT
		Execute : {REDUND_UNREPLICABLE} BOOL; (*Execute the function block*) (* *) (*#PAR*)
		ServerEndpointUrl : {REDUND_UNREPLICABLE} STRING[255]; (*Server endpoint URL specified in the syntax opc.tcp://IP address:Port*) (* *) (*#PAR*)
		pSessionConnectInfo : REFERENCE TO UASessionConnectInfo; (*Reference to structure UASessionConnectInfo *) (* *) (*#PAR#OPT*)
		NamespaceUri : {REDUND_UNREPLICABLE} STRING[255]; (*Specifies the namespace URI. Example: "urn:B&R/pv/". If not specified the NodeID.NamespaceIndex is used*) (* *) (*#PAR#OPT*)
		NodeID : {REDUND_UNREPLICABLE} UANodeID; (*NodeID, identification of the node. For information about the structure, see UANodeID in AsOpcUac Automation Studio Help. *) (* *) (*#PAR*)
		pNodeAddInfo : REFERENCE TO UANodeAdditionalInfo; (*Additional parameters for specifying the node.For information about the structure, see UANodeAdditionalInfo.*) (* *) (*#PAR#OPT*)
		Variable : {REDUND_UNREPLICABLE} STRING[255]; (* Name of the variable on the controller in the syntax Application module::Task:Variable.Element*) (* *) (*#PAR*)
	END_VAR
	VAR_OUTPUT
		Done : {REDUND_UNREPLICABLE} BOOL; (*Execute is done*) (* *) (*#PAR*)
		Busy : {REDUND_UNREPLICABLE} BOOL; (*Function block is busy*) (* *) (*#PAR*)
		Active : {REDUND_UNREPLICABLE} BOOL; (*Function block is active*) (* *) (*#PAR*)
		Error : {REDUND_UNREPLICABLE} BOOL; (*Indicates an error*) (* *) (*#PAR*)
		StatusID : {REDUND_UNREPLICABLE} DWORD; (*Status information*) (* *) (*#PAR*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} EasyUaWriteInternalType; (*Data for internal use*) (* *) (*#OMIT*)
	END_VAR
END_FUNCTION_BLOCK

{REDUND_UNREPLICABLE} FUNCTION_BLOCK EasyUaWriteList (*Writes the values of variables to a list of nodes on the OPC UA server*)
	VAR_INPUT
		Execute : {REDUND_UNREPLICABLE} BOOL; (*Execute the function block*) (* *) (*#PAR*)
		ServerEndpointUrl : {REDUND_UNREPLICABLE} STRING[255]; (*Server endpoint URL specified in the syntax opc.tcp://IP address:Port*) (* *) (*#PAR*)
		pSessionConnectInfo : REFERENCE TO UASessionConnectInfo; (*Reference to structure UASessionConnectInfo *) (* *) (*#PAR#OPT*)
		NamespaceUri : {REDUND_UNREPLICABLE} STRING[255]; (*Specifies the namespace URI. Example: "urn:B&R/pv/". If not specified the NodeID[].NamespaceIndex is used*) (* *) (*#PAR#OPT*)
		NodeIDCount : {REDUND_UNREPLICABLE} UINT; (*Number of nodes in the list to be written. The maximum number is limited by the server limit.Only the number of configued NodeIDs must be used, otherwise, undefined behavior, access violations and a controller restart can occur*) (* *) (*#PAR*)
		NodeIDs : {REDUND_UNREPLICABLE} ARRAY[0..MAX_INDEX_NODELIST] OF UANodeID; (*List of NodeIDs for the identification of nodes. For information about the structure, see UANodeID  in AsOpcUac Automation Studio Help*) (* *) (*#PAR*)
		pNodeAddInfo : REFERENCE TO ARRAY[0..MAX_INDEX_NODELIST] OF UANodeAdditionalInfo; (*Additional parameters for specifying the node.For information about the structure, see UANodeAdditionalInfo.*) (* *) (*#PAR#OPT*)
		Variables : {REDUND_UNREPLICABLE} ARRAY[0..MAX_INDEX_NODELIST] OF STRING[255]; (* Name of the variables on the controller in the syntax Application module::Task:Variable.Element*) (* *) (*#PAR*)
	END_VAR
	VAR_OUTPUT
		Done : {REDUND_UNREPLICABLE} BOOL; (*Execute is done*) (* *) (*#PAR*)
		Busy : {REDUND_UNREPLICABLE} BOOL; (*Function block is busy*) (* *) (*#PAR*)
		Active : {REDUND_UNREPLICABLE} BOOL; (*Function block is active*) (* *) (*#PAR*)
		Error : {REDUND_UNREPLICABLE} BOOL; (*At least one node of the list has an error or there was a fub execution error. If StatusID = 0 check NodeErrorIDs.*) (* *) (*#PAR*)
		StatusID : {REDUND_UNREPLICABLE} DWORD; (*Status information*) (* *) (*#PAR*)
	END_VAR
	VAR_IN_OUT
		NodeErrorIDs : ARRAY[0..MAX_INDEX_NODELIST] OF DWORD; (*Error codes the of nodes. See OPC UA StatusCode in AsOpcUac Automation Studio Help*) (* *) (*#PAR*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} EasyUaWriteListInternalType; (*Data for internal use*) (* *) (*#OMIT*)
	END_VAR
END_FUNCTION_BLOCK

{REDUND_UNREPLICABLE} FUNCTION_BLOCK EasyUaSubscription (*Operates a simple subscription to a single node on the OPC UA server*)
	VAR_INPUT
		Enable : {REDUND_UNREPLICABLE} BOOL; (*Enable the function block*) (* *) (*#PAR*)
		ServerEndpointUrl : {REDUND_UNREPLICABLE} STRING[255]; (*Server endpoint URL specified in the syntax opc.tcp://IP address:Port*) (* *) (*#PAR*)
		pSessionConnectInfo : {REDUND_UNREPLICABLE} UASessionConnectInfo; (*Reference to structure UASessionConnectInfo *) (* *) (*#PAR#OPT*)
		NamespaceUri : {REDUND_UNREPLICABLE} STRING[255]; (*Specifies the namespace URI. Example: "urn:B&R/pv/". If not specified the NodeID.NamespaceIndex is used*) (* *) (*#PAR#OPT*)
		NodeID : {REDUND_UNREPLICABLE} UANodeID; (*NodeID, identification of the node. For information about the structure, see UANodeID in AsOpcUac Automation Studio Help. *) (* *) (*#PAR*)
		pNodeAddInfo : {REDUND_UNREPLICABLE} UANodeAdditionalInfo; (*Additional parameters for specifying the node.For information about the structure, see UANodeAdditionalInfo.*) (* *) (*#PAR#OPT*)
		Variable : {REDUND_UNREPLICABLE} STRING[255]; (* Name of the variable on the controller in the syntax Application module::Task:Variable.Element*) (* *) (*#PAR*)
		PublishingInterval : {REDUND_UNREPLICABLE} TIME; (*Interval at which data should be published to the client. Since the server does not have to accept every desired interval, the interval actually used by the server is returned on the output after the call. If not specified 10 seconds is used*) (* *) (*#PAR#OPT*)
		Priority : {REDUND_UNREPLICABLE} BYTE; (*Specifies the priority of the subscription on the server (with respect to other subscriptions from the same client)*) (* *) (*#PAR#OPT*)
		pMonitoringSettings : {REDUND_UNREPLICABLE} UAMonitoringSettings; (*Additional parameters for specifying monitoring. See UAMonitoringSettings in AsOpcUac Automation Studio Help*) (* *) (*#PAR#OPT*)
	END_VAR
	VAR_OUTPUT
		Active : {REDUND_UNREPLICABLE} BOOL; (*Function block is active*) (* *) (*#PAR*)
		Error : {REDUND_UNREPLICABLE} BOOL; (*Indicates an error*) (* *) (*#PAR*)
		StatusID : {REDUND_UNREPLICABLE} DWORD; (*Status information*) (* *) (*#PAR*)
		SubscriptionActive : {REDUND_UNREPLICABLE} BOOL; (*The subscription to the node is active without errors.*) (* *) (*#PAR*)
		ValueChanged : {REDUND_UNREPLICABLE} BOOL; (*The value of the monitored variable has changed. Only reamins for 1 cycle.*) (* *) (*#PAR*)
		TimeStamp : {REDUND_UNREPLICABLE} DATE_AND_TIME; (*Timestamp of the change.*) (* *) (*#PAR*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} EasyUaSubscriptionInternalType; (*Data for internal use*) (* *) (*#OMIT*)
	END_VAR
END_FUNCTION_BLOCK

{REDUND_UNREPLICABLE} FUNCTION_BLOCK EasyUaSubscriptionList (*Operates a simple subscription to a list of nodes on the OPC UA server*)
	VAR_INPUT
		Enable : {REDUND_UNREPLICABLE} BOOL; (*Enable the function block*) (* *) (*#PAR*)
		ServerEndpointUrl : {REDUND_UNREPLICABLE} STRING[255]; (*Server endpoint URL specified in the syntax opc.tcp://IP address:Port*) (* *) (*#PAR*)
		pSessionConnectInfo : REFERENCE TO UASessionConnectInfo; (*Reference to structure UASessionConnectInfo *) (* *) (*#PAR#OPT*)
		NamespaceUri : {REDUND_UNREPLICABLE} STRING[255]; (*Specifies the namespace URI. Example: "urn:B&R/pv/". If not specified the NodeID[].NamespaceIndex is used*) (* *) (*#PAR#OPT*)
		NodeIDCount : {REDUND_UNREPLICABLE} UINT; (*Number of nodes in the list to be subscripted. The maximum number is limited by the server limit.Only the number of configued NodeIDs must be used, otherwise, undefined behavior, access violations and a controller restart can occur*) (* *) (*#PAR*)
		NodeIDs : {REDUND_UNREPLICABLE} ARRAY[0..MAX_INDEX_NODELIST] OF UANodeID; (*List of NodeIDs for the identification of nodes. For information about the structure, see UANodeID  in AsOpcUac Automation Studio Help*) (* *) (*#PAR*)
		pNodeAddInfos : REFERENCE TO ARRAY[0..MAX_INDEX_MONITORLIST] OF UANodeAdditionalInfo; (*Additional parameters for specifying the node.For information about the structure, see UANodeAdditionalInfo.*) (* *) (*#PAR#OPT*)
		PublishingInterval : {REDUND_UNREPLICABLE} TIME; (*Interval at which data should be published to the client. Since the server does not have to accept every desired interval, the interval actually used by the server is returned on the output after the call. If not specified 10 seconds is used*) (* *) (*#PAR#OPT*)
		Priority : {REDUND_UNREPLICABLE} BYTE; (*Specifies the priority of the subscription on the server (with respect to other subscriptions from the same client)*) (* *) (*#PAR#OPT*)
		Variables : {REDUND_UNREPLICABLE} ARRAY[0..MAX_INDEX_MONITORLIST] OF STRING[255]; (*List of variable names on the controller in the following syntax: AppModul::Task:Variable.Element The connected variable must remain valid until the monitored items are freed up again by re-enabling the function block. After a task is transferred, the monitored items may have to be created again. See the description for connection NodeQualityIDs*) (* *) (*#PAR*)
		pMonitoringSettings : REFERENCE TO ARRAY[0..MAX_INDEX_MONITORLIST] OF UAMonitoringParameters; (*Additional parameters for specifying monitoring. See UAMonitoringSettings in AsOpcUac Automation Studio Help*) (* *) (*#PAR#OPT*)
	END_VAR
	VAR_OUTPUT
		Active : {REDUND_UNREPLICABLE} BOOL; (*Function block is active*) (* *) (*#PAR*)
		Error : {REDUND_UNREPLICABLE} BOOL; (*At least one node of the list has an error or there was a fub execution error. If StatusID = 0 check NodeErrorIDs.*) (* *) (*#PAR*)
		StatusID : {REDUND_UNREPLICABLE} DWORD; (*Status information*) (* *) (*#PAR*)
		SubscriptionListActive : {REDUND_UNREPLICABLE} BOOL; (*At least one node of the list has an active subscription without errors.*) (* *) (*#PAR*)
	END_VAR
	VAR_IN_OUT
		ValuesChanged : ARRAY[0..MAX_INDEX_MONITORLIST] OF BOOL; (*List for identifying value changes of the individual nodes. The number of list elements is defined by NodeHdlCount. 
In firmware sync mode, the user must set ValuesChanged to FALSE after the changes have been evaluated.
The connected variable must remain valid until the monitored items are freed up again by re-enabling the function block.*) (* *) (*#PAR*)
		RemainingValueCount : ARRAY[0..MAX_INDEX_MONITORLIST] OF UINT; (*List with the number of remaining value changes for each individual node. The number of list elements is defined by NodeHdlCount. This parameter is intended for diagnostic purposes of the monitored items. A high value may indicate a sampling rate that is too high.*) (* *) (*#PAR*)
		TimeStamps : ARRAY[0..MAX_INDEX_MONITORLIST] OF DATE_AND_TIME; (*List of timestamps that was returned with the last value changes. The number of list elements is defined by NodeHdlCount. 
The connected variable must remain valid until the monitored items are freed up again by re-enabling the function block.*) (* *) (*#PAR*)
		NodeErrorIDs : ARRAY[0..MAX_INDEX_NODELIST] OF DWORD; (*Error codes the of nodes. See OPC UA StatusCode in AsOpcUac Automation Studio Help*) (* *) (*#PAR*)
		NodeQualityIDs : ARRAY[0..MAX_INDEX_MONITORLIST] OF DWORD; (*List of error codes that was returned with the last value changes. The number of list elements is defined by NodeHdlCount. 
After a task is transferred, error 16#80040000 (BadResourceUnavailable) is output for the affected variables in the same index under NodeQualityIDs in input "Variables". The connected variable must remain valid until the monitored items are freed up again by re-enabling the function block.*) (* *) (*#PAR*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} EasyUaSubsListInternalType; (*Data for internal use*) (* *) (*#OMIT*)
	END_VAR
END_FUNCTION_BLOCK

{REDUND_UNREPLICABLE} FUNCTION_BLOCK EasyUaMethodCall (*Calls a method on the OPC UA server*)
	VAR_INPUT
		Execute : {REDUND_UNREPLICABLE} BOOL; (*Execute the function block*) (* *) (*#PAR*)
		ServerEndpointUrl : {REDUND_UNREPLICABLE} STRING[255]; (*Server endpoint URL specified in the syntax opc.tcp://IP address:Port*) (* *) (*#PAR*)
		pSessionConnectInfo : REFERENCE TO UASessionConnectInfo; (*Reference to structure UASessionConnectInfo *) (* *) (*#PAR#OPT*)
		NamespaceUri : {REDUND_UNREPLICABLE} STRING[255]; (*Specifies the namespace URI. Example: "urn:B&R/pv/". If not specified ObjectNodeID.NamespaceIndex and MethodNodeID.NamespaceIndex are used*) (* *) (*#PAR#OPT*)
		ObjectNodeID : {REDUND_UNREPLICABLE} UANodeID; (*Identification of the object that contains the method. For information about the structure, see UANodeID in AsOpcUac Automation Studio Help*) (* *) (*#PAR*)
		MethodNodeID : {REDUND_UNREPLICABLE} UANodeID; (*Identification of the method. For information about the structure, see UANodeID in AsOpcUac Automation Studio Help*) (* *) (*#PAR*)
		InputArguments : {REDUND_UNREPLICABLE} ARRAY[0..MAX_INDEX_ARGUMENTS] OF UAMethodArgument; (* Name of the variable on the controller in the syntax Application module::Task:Variable.Element*) (* *) (*#PAR*)
		OutputArguments : {REDUND_UNREPLICABLE} ARRAY[0..MAX_INDEX_ARGUMENTS] OF UAMethodArgument; (* Name of the variable on the controller in the syntax Application module::Task:Variable.Element*) (* *) (*#PAR*)
	END_VAR
	VAR_OUTPUT
		Done : {REDUND_UNREPLICABLE} BOOL; (*Execute is done*) (* *) (*#PAR*)
		Busy : {REDUND_UNREPLICABLE} BOOL; (*Function block is busy*) (* *) (*#PAR*)
		Active : {REDUND_UNREPLICABLE} BOOL; (*Function block is active*) (* *) (*#PAR*)
		Error : {REDUND_UNREPLICABLE} BOOL; (*Indicates an error*) (* *) (*#PAR*)
		StatusID : {REDUND_UNREPLICABLE} DWORD; (*Status information*) (* *) (*#PAR*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} EasyUaMethodCallInternalType; (*Data for internal use*) (* *) (*#OMIT*)
	END_VAR
END_FUNCTION_BLOCK

{REDUND_UNREPLICABLE} FUNCTION_BLOCK EasyUaReadBulk (*Improved performance for acyclic read requests with high data volume*)
	VAR_INPUT
		Execute : {REDUND_UNREPLICABLE} BOOL; (*Execute the function block*) (* *) (*#PAR*)
		ServerEndpointUrl : {REDUND_UNREPLICABLE} STRING[255]; (*Server endpoint URL specified in the syntax opc.tcp://IP address:Port*) (* *) (*#PAR*)
		pSessionConnectInfo : REFERENCE TO UASessionConnectInfo; (*Reference to structure UASessionConnectInfo *) (* *) (*#PAR#OPT*)
		NamespaceUri : {REDUND_UNREPLICABLE} STRING[255]; (*Specifies the namespace URI. Example: "urn:B&R/pv/"*) (* *) (*#PAR#OPT*)
		NodeIDCount : {REDUND_UNREPLICABLE} UINT; (*Number of nodes in the list to be read. The maximum number is limited by the server limit. Only the number of configued NodeIDs must be used, otherwise, undefined behavior, access violations and a controller restart can occur*) (* *) (*#PAR*)
		NodeIDs : {REDUND_UNREPLICABLE} UDINT; (*List of NodeIDs for the identification of nodes. For information about the structure, see UANodeID  in AsOpcUac Automation Studio Help*) (* *) (*#PAR*)
		NodeIDsLen : {REDUND_UNREPLICABLE} UDINT; (*Size of the variable conected to the input NodeIDs*) (* *) (*#PAR*)
		NodeAddInfo : {REDUND_UNREPLICABLE} UDINT; (*Additional parameters for specifying the node.For information about the structure, see UANodeAdditionalInfo.*)
		Variables : {REDUND_UNREPLICABLE} UDINT; (* Name of the variables on the controller in the syntax Application module::Task:Variable.Element*) (* *) (*#PAR*)
		NodeErrorIDs : {REDUND_UNREPLICABLE} UDINT; (*Address of a list of DWORD for returning the error codes for the read operations.*) (* *) (*#PAR#OPT*)
		TimeStamps : {REDUND_UNREPLICABLE} UDINT; (*Timestamp of the read node.*) (* *) (*#PAR#OPT*)
	END_VAR
	VAR_OUTPUT
		Done : {REDUND_UNREPLICABLE} BOOL; (*Execute is done*) (* *) (*#PAR*)
		Busy : {REDUND_UNREPLICABLE} BOOL; (*Function block is busy*) (* *) (*#PAR*)
		Active : {REDUND_UNREPLICABLE} BOOL; (*Function block is active*) (* *) (*#PAR*)
		Error : {REDUND_UNREPLICABLE} BOOL; (*At least one node of the list has an error or there was a fub execution error. If StatusID = 0 check NodeErrorIDs.*) (* *) (*#PAR*)
		StatusID : {REDUND_UNREPLICABLE} DWORD; (*Status information*) (* *) (*#PAR*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} EasyUaReadBulkInternalType; (*Data for internal use*) (* *) (*#OMIT*)
	END_VAR
END_FUNCTION_BLOCK

{REDUND_UNREPLICABLE} FUNCTION_BLOCK EasyUaWriteBulk (*Improved performance for acyclic write requests with high data volume*)
	VAR_INPUT
		Execute : {REDUND_UNREPLICABLE} BOOL; (*Execute the function block*) (* *) (*#PAR*)
		ServerEndpointUrl : {REDUND_UNREPLICABLE} STRING[255]; (*Server endpoint URL specified in the syntax opc.tcp://IP address:Port*) (* *) (*#PAR*)
		pSessionConnectInfo : REFERENCE TO UASessionConnectInfo; (*Reference to structure UASessionConnectInfo *) (* *) (*#PAR#OPT*)
		NamespaceUri : {REDUND_UNREPLICABLE} STRING[255]; (*Specifies the namespace URI. Example: "urn:B&R/pv/"*) (* *) (*#PAR#OPT*)
		NodeIDCount : {REDUND_UNREPLICABLE} UINT; (*Number of nodes in the list to be read. The maximum number is limited by the server limit. Only the number of configued NodeIDs must be used, otherwise, undefined behavior, access violations and a controller restart can occur*) (* *) (*#PAR*)
		NodeIDs : {REDUND_UNREPLICABLE} UDINT; (*List of NodeIDs for the identification of nodes. For information about the structure, see UANodeID  in AsOpcUac Automation Studio Help*) (* *) (*#PAR*)
		NodeIDsLen : {REDUND_UNREPLICABLE} UDINT; (*Size of the variable conected to the input NodeIDs*) (* *) (*#PAR*)
		NodeAddInfo : {REDUND_UNREPLICABLE} UDINT; (*Additional parameters for specifying the node.For information about the structure, see UANodeAdditionalInfo.*) (* *) (*#PAR#OPT*)
		Variables : {REDUND_UNREPLICABLE} UDINT; (* Name of the variables on the controller in the syntax Application module::Task:Variable.Element*) (* *) (*#PAR*)
		NodeErrorIDs : {REDUND_UNREPLICABLE} UDINT; (*Address of a list of DWORD for returning the error codes for the read operations.*) (* *) (*#PAR#OPT*)
	END_VAR
	VAR_OUTPUT
		Done : {REDUND_UNREPLICABLE} BOOL; (*Execute is done*) (* *) (*#PAR*)
		Busy : {REDUND_UNREPLICABLE} BOOL; (*Function block is busy*) (* *) (*#PAR*)
		Active : {REDUND_UNREPLICABLE} BOOL; (*Function block is active*) (* *) (*#PAR*)
		Error : {REDUND_UNREPLICABLE} BOOL; (*At least one node of the list has an error or there was a fub execution error. If StatusID = 0 check NodeErrorIDs.*) (* *) (*#PAR*)
		StatusID : {REDUND_UNREPLICABLE} DWORD; (*Status information*) (* *) (*#PAR*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} EasyUaWriteBulkInternalType; (*Data for internal use*) (* *) (*#OMIT*)
	END_VAR
END_FUNCTION_BLOCK
