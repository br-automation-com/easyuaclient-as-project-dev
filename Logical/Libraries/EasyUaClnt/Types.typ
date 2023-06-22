
TYPE
	EasyUaConnGetStatusInternalType : {REDUND_UNREPLICABLE} 	STRUCT  (*Internal structure.*) (* *) (*#OMIT*)
		ExecuteOld : {REDUND_UNREPLICABLE} BOOL;
		Executing : {REDUND_UNREPLICABLE} BOOL;
		ParametersValid : {REDUND_UNREPLICABLE} BOOL;
		Step : {REDUND_UNREPLICABLE} UDINT;
		ConnectionHdl : {REDUND_UNREPLICABLE} DWORD;
		StatusID : {REDUND_UNREPLICABLE} DWORD;
		UA_Connect_0 : {REDUND_UNREPLICABLE} UA_Connect;
		UA_ConnectionGetStatus_0 : {REDUND_UNREPLICABLE} UA_ConnectionGetStatus;
		UA_Disconnect_0 : {REDUND_UNREPLICABLE} UA_Disconnect;
	END_STRUCT;
	EasyUaMonSrvStatusInternalType : {REDUND_UNREPLICABLE} 	STRUCT  (*Internal structure.*) (* *) (*#OMIT*)
		EnableOld : {REDUND_UNREPLICABLE} BOOL; (*Variable to detect rising edge on Enable input*)
		ParametersValid : {REDUND_UNREPLICABLE} BOOL; (*All parameters valid flag*)
		Step : {REDUND_UNREPLICABLE} UDINT;
		MonitoringTime : {REDUND_UNREPLICABLE} TIME;
		EasyUaConnectionGetStatus : {REDUND_UNREPLICABLE} EasyUaConnectionGetStatus;
		TON_0 : {REDUND_UNREPLICABLE} TON;
	END_STRUCT;
	EasyUaReadInternalType : {REDUND_UNREPLICABLE} 	STRUCT  (*Internal structure.*) (* *) (*#OMIT*)
		ExecuteOld : {REDUND_UNREPLICABLE} BOOL; (*Variable to detect rising edge on Execute input*)
		Executing : {REDUND_UNREPLICABLE} BOOL; (*Executing flag*)
		ParametersValid : {REDUND_UNREPLICABLE} BOOL; (*All parameters valid flag *)
		Step : {REDUND_UNREPLICABLE} UDINT;
		ConnectionHdl : {REDUND_UNREPLICABLE} DWORD;
		NodeHdl : {REDUND_UNREPLICABLE} DWORD;
		Variable : {REDUND_UNREPLICABLE} STRING[255];
		StatusID : {REDUND_UNREPLICABLE} DWORD;
		UA_Connect_0 : {REDUND_UNREPLICABLE} UA_Connect;
		UA_GetNamespaceIndex_0 : {REDUND_UNREPLICABLE} UA_GetNamespaceIndex;
		UA_NodeGetHandle_0 : {REDUND_UNREPLICABLE} UA_NodeGetHandle;
		UA_Read_0 : {REDUND_UNREPLICABLE} UA_Read;
		UA_NodeReleaseHandle_0 : {REDUND_UNREPLICABLE} UA_NodeReleaseHandle;
		UA_Disconnect_0 : {REDUND_UNREPLICABLE} UA_Disconnect;
	END_STRUCT;
	EasyUaReadListInternalType : {REDUND_UNREPLICABLE} 	STRUCT  (*Internal structure.*) (* *) (*#OMIT*)
		ExecuteOld : {REDUND_UNREPLICABLE} BOOL; (*Variable to detect rising edge on Execute input*)
		Executing : {REDUND_UNREPLICABLE} BOOL; (*Executing flag*)
		ParametersValid : {REDUND_UNREPLICABLE} BOOL; (*All parameters valid flag *)
		Step : {REDUND_UNREPLICABLE} UDINT;
		ConnectionHdl : {REDUND_UNREPLICABLE} DWORD;
		NodeHdls : {REDUND_UNREPLICABLE} ARRAY[0..MAX_INDEX_NODELIST]OF DWORD;
		Variables : {REDUND_UNREPLICABLE} ARRAY[0..MAX_INDEX_NODELIST]OF STRING[255];
		Idx : {REDUND_UNREPLICABLE} UDINT;
		NodeIDCount : {REDUND_UNREPLICABLE} UINT;
		StatusID : {REDUND_UNREPLICABLE} DWORD;
		UA_Connect_0 : {REDUND_UNREPLICABLE} UA_Connect;
		UA_GetNamespaceIndex_0 : {REDUND_UNREPLICABLE} UA_GetNamespaceIndex;
		UA_NodeGetHandleList_0 : {REDUND_UNREPLICABLE} UA_NodeGetHandleList;
		UA_ReadList_0 : {REDUND_UNREPLICABLE} UA_ReadList;
		UA_NodeReleaseHandleList_0 : {REDUND_UNREPLICABLE} UA_NodeReleaseHandleList;
		UA_Disconnect_0 : {REDUND_UNREPLICABLE} UA_Disconnect;
	END_STRUCT;
	EasyUaReadBulkInternalType : {REDUND_UNREPLICABLE} 	STRUCT  (*Internal structure.*) (* *) (*#OMIT*)
		ExecuteOld : {REDUND_UNREPLICABLE} BOOL; (*Variable to detect rising edge on Execute input*)
		Executing : {REDUND_UNREPLICABLE} BOOL; (*Executing flag*)
		ParametersValid : {REDUND_UNREPLICABLE} BOOL; (*All parameters valid flag *)
		Step : {REDUND_UNREPLICABLE} UDINT;
		ConnectionHdl : {REDUND_UNREPLICABLE} DWORD;
		NamespaceIndex : {REDUND_UNREPLICABLE} UINT;
		Idx : {REDUND_UNREPLICABLE} UDINT;
		NodeIDsAdr : {REDUND_UNREPLICABLE} UDINT;
		NodeIDsLen : {REDUND_UNREPLICABLE} UDINT;
		StatusID : {REDUND_UNREPLICABLE} DWORD;
		UA_Connect_0 : {REDUND_UNREPLICABLE} UA_Connect;
		UA_GetNamespaceIndex_0 : {REDUND_UNREPLICABLE} UA_GetNamespaceIndex;
		UaClt_ReadBulk_0 : {REDUND_UNREPLICABLE} UaClt_ReadBulk;
		UA_Disconnect_0 : {REDUND_UNREPLICABLE} UA_Disconnect;
	END_STRUCT;
	EasyUaWriteInternalType : {REDUND_UNREPLICABLE} 	STRUCT  (*Internal structure.*) (* *) (*#OMIT*)
		ExecuteOld : {REDUND_UNREPLICABLE} BOOL; (*Variable to detect rising edge on Execute input*)
		Executing : {REDUND_UNREPLICABLE} BOOL; (*Executing flag*)
		ParametersValid : {REDUND_UNREPLICABLE} BOOL; (*All parameters valid flag *)
		Step : {REDUND_UNREPLICABLE} UDINT;
		ConnectionHdl : {REDUND_UNREPLICABLE} DWORD;
		NodeHdl : {REDUND_UNREPLICABLE} DWORD;
		Variable : {REDUND_UNREPLICABLE} STRING[255];
		StatusID : {REDUND_UNREPLICABLE} DWORD;
		UA_Connect_0 : {REDUND_UNREPLICABLE} UA_Connect;
		UA_GetNamespaceIndex_0 : {REDUND_UNREPLICABLE} UA_GetNamespaceIndex;
		UA_NodeGetHandle_0 : {REDUND_UNREPLICABLE} UA_NodeGetHandle;
		UA_Write_0 : {REDUND_UNREPLICABLE} UA_Write;
		UA_NodeReleaseHandle_0 : {REDUND_UNREPLICABLE} UA_NodeReleaseHandle;
		UA_Disconnect_0 : {REDUND_UNREPLICABLE} UA_Disconnect;
	END_STRUCT;
	EasyUaWriteListInternalType : {REDUND_UNREPLICABLE} 	STRUCT  (*Internal structure.*) (* *) (*#OMIT*)
		ExecuteOld : {REDUND_UNREPLICABLE} BOOL; (*Variable to detect rising edge on Execute input*)
		Executing : {REDUND_UNREPLICABLE} BOOL; (*Executing flag*)
		ParametersValid : {REDUND_UNREPLICABLE} BOOL; (*All parameters valid flag *)
		Step : {REDUND_UNREPLICABLE} UDINT;
		ConnectionHdl : {REDUND_UNREPLICABLE} DWORD;
		NodeHdls : {REDUND_UNREPLICABLE} ARRAY[0..MAX_INDEX_NODELIST]OF DWORD;
		Variables : {REDUND_UNREPLICABLE} ARRAY[0..MAX_INDEX_NODELIST]OF STRING[255];
		Idx : {REDUND_UNREPLICABLE} UDINT;
		NodeIDCount : {REDUND_UNREPLICABLE} UINT;
		StatusID : {REDUND_UNREPLICABLE} DWORD;
		UA_Connect_0 : {REDUND_UNREPLICABLE} UA_Connect;
		UA_GetNamespaceIndex_0 : {REDUND_UNREPLICABLE} UA_GetNamespaceIndex;
		UA_NodeGetHandleList_0 : {REDUND_UNREPLICABLE} UA_NodeGetHandleList;
		UA_WriteList_0 : {REDUND_UNREPLICABLE} UA_WriteList;
		UA_NodeReleaseHandleList_0 : {REDUND_UNREPLICABLE} UA_NodeReleaseHandleList;
		UA_Disconnect_0 : {REDUND_UNREPLICABLE} UA_Disconnect;
	END_STRUCT;
	EasyUaWriteBulkInternalType : {REDUND_UNREPLICABLE} 	STRUCT  (*Internal structure.*) (* *) (*#OMIT*)
		ExecuteOld : {REDUND_UNREPLICABLE} BOOL; (*Variable to detect rising edge on Execute input*)
		Executing : {REDUND_UNREPLICABLE} BOOL; (*Executing flag*)
		ParametersValid : {REDUND_UNREPLICABLE} BOOL; (*All parameters valid flag *)
		Step : {REDUND_UNREPLICABLE} UDINT;
		ConnectionHdl : {REDUND_UNREPLICABLE} DWORD;
		NamespaceIndex : {REDUND_UNREPLICABLE} UINT;
		Idx : {REDUND_UNREPLICABLE} UDINT;
		NodeIDsAdr : {REDUND_UNREPLICABLE} UDINT;
		NodeIDsLen : {REDUND_UNREPLICABLE} UDINT;
		StatusID : {REDUND_UNREPLICABLE} DWORD;
		UA_Connect_0 : {REDUND_UNREPLICABLE} UA_Connect;
		UA_GetNamespaceIndex_0 : {REDUND_UNREPLICABLE} UA_GetNamespaceIndex;
		UaClt_WriteBulk_0 : {REDUND_UNREPLICABLE} UaClt_WriteBulk;
		UA_Disconnect_0 : {REDUND_UNREPLICABLE} UA_Disconnect;
	END_STRUCT;
	EasyUaSubscriptionInternalType : {REDUND_UNREPLICABLE} 	STRUCT  (*Internal structure.*) (* *) (*#OMIT*)
		EnableOld : {REDUND_UNREPLICABLE} BOOL; (*Variable to detect rising edge on Enable input*)
		ParametersValid : {REDUND_UNREPLICABLE} BOOL; (*All parameters valid flag*)
		Step : {REDUND_UNREPLICABLE} UDINT;
		ConnectionHdl : {REDUND_UNREPLICABLE} DWORD;
		NodeHdl : {REDUND_UNREPLICABLE} DWORD;
		Variable : {REDUND_UNREPLICABLE} STRING[255];
		PublishingInterval : {REDUND_UNREPLICABLE} TIME;
		SubscriptionHdl : {REDUND_UNREPLICABLE} DWORD;
		MonitoringSettings : {REDUND_UNREPLICABLE} UAMonitoringSettings;
		MonitoredItemHdl : {REDUND_UNREPLICABLE} DWORD;
		StatusID : {REDUND_UNREPLICABLE} DWORD;
		Disable : {REDUND_UNREPLICABLE} UDINT;
		UA_Connect_0 : {REDUND_UNREPLICABLE} UA_Connect;
		UA_GetNamespaceIndex_0 : {REDUND_UNREPLICABLE} UA_GetNamespaceIndex;
		UA_NodeGetHandle_0 : {REDUND_UNREPLICABLE} UA_NodeGetHandle;
		UA_SubscriptionCreate_0 : {REDUND_UNREPLICABLE} UA_SubscriptionCreate;
		UA_MonitoredItemAdd_0 : {REDUND_UNREPLICABLE} UA_MonitoredItemAdd;
		UA_MonitoredItemOperate_0 : {REDUND_UNREPLICABLE} UA_MonitoredItemOperate;
		UA_MonitoredItemRemove_0 : {REDUND_UNREPLICABLE} UA_MonitoredItemRemove;
		UA_SubscriptionDelete_0 : {REDUND_UNREPLICABLE} UA_SubscriptionDelete;
		UA_NodeReleaseHandle_0 : {REDUND_UNREPLICABLE} UA_NodeReleaseHandle;
		UA_Disconnect_0 : {REDUND_UNREPLICABLE} UA_Disconnect;
	END_STRUCT;
	EasyUaSubsListInternalType : {REDUND_UNREPLICABLE} 	STRUCT  (*Internal structure.*) (* *) (*#OMIT*)
		EnableOld : {REDUND_UNREPLICABLE} BOOL; (*Variable to detect rising edge on Enable input*)
		ParametersValid : {REDUND_UNREPLICABLE} BOOL; (*All parameters valid flag*)
		Step : {REDUND_UNREPLICABLE} UDINT;
		ConnectionHdl : {REDUND_UNREPLICABLE} DWORD;
		NodeHdls : {REDUND_UNREPLICABLE} ARRAY[0..MAX_INDEX_NODELIST]OF DWORD;
		Variables : {REDUND_UNREPLICABLE} ARRAY[0..MAX_INDEX_MONITORLIST]OF STRING[255];
		PublishingInterval : {REDUND_UNREPLICABLE} TIME;
		SubscriptionHdl : {REDUND_UNREPLICABLE} DWORD;
		MonitoringSettings : {REDUND_UNREPLICABLE} ARRAY[0..MAX_INDEX_MONITORLIST]OF UAMonitoringParameters;
		MonitoredItemHdls : {REDUND_UNREPLICABLE} ARRAY[0..MAX_INDEX_MONITORLIST]OF DWORD;
		Idx : {REDUND_UNREPLICABLE} UDINT;
		NodeIDCount : {REDUND_UNREPLICABLE} UINT;
		StatusID : {REDUND_UNREPLICABLE} DWORD;
		Disable : {REDUND_UNREPLICABLE} UDINT;
		UA_Connect_0 : {REDUND_UNREPLICABLE} UA_Connect;
		UA_GetNamespaceIndex_0 : {REDUND_UNREPLICABLE} UA_GetNamespaceIndex;
		UA_NodeGetHandleList_0 : {REDUND_UNREPLICABLE} UA_NodeGetHandleList;
		UA_SubscriptionCreate_0 : {REDUND_UNREPLICABLE} UA_SubscriptionCreate;
		UA_MonitoredItemAddList_0 : {REDUND_UNREPLICABLE} UA_MonitoredItemAddList;
		UA_MonitoredItemRemoveList_0 : {REDUND_UNREPLICABLE} UA_MonitoredItemRemoveList;
		UA_SubscriptionDelete_0 : {REDUND_UNREPLICABLE} UA_SubscriptionDelete;
		UA_NodeReleaseHandleList_0 : {REDUND_UNREPLICABLE} UA_NodeReleaseHandleList;
		UA_Disconnect_0 : {REDUND_UNREPLICABLE} UA_Disconnect;
	END_STRUCT;
	EasyUaMethodCallInternalType : {REDUND_UNREPLICABLE} 	STRUCT  (*Internal structure.*) (* *) (*#OMIT*)
		ExecuteOld : {REDUND_UNREPLICABLE} BOOL; (*Variable to detect rising edge on Execute input*)
		Executing : {REDUND_UNREPLICABLE} BOOL; (*Executing flag*)
		ParametersValid : {REDUND_UNREPLICABLE} BOOL; (*All parameters valid flag *)
		Step : {REDUND_UNREPLICABLE} UDINT;
		ConnectionHdl : {REDUND_UNREPLICABLE} DWORD;
		MethodHdl : {REDUND_UNREPLICABLE} DWORD;
		InputArguments : {REDUND_UNREPLICABLE} ARRAY[0..MAX_INDEX_ARGUMENTS]OF UAMethodArgument;
		OutputArguments : {REDUND_UNREPLICABLE} ARRAY[0..MAX_INDEX_ARGUMENTS]OF UAMethodArgument;
		StatusID : {REDUND_UNREPLICABLE} DWORD;
		UA_Connect_0 : {REDUND_UNREPLICABLE} UA_Connect;
		UA_GetNamespaceIndex_0 : {REDUND_UNREPLICABLE} UA_GetNamespaceIndex;
		UA_MethodGetHandle_0 : {REDUND_UNREPLICABLE} UA_MethodGetHandle;
		UA_MethodCall_0 : {REDUND_UNREPLICABLE} UA_MethodCall;
		UA_MethodReleaseHandle_0 : {REDUND_UNREPLICABLE} UA_MethodReleaseHandle;
		UA_Disconnect_0 : {REDUND_UNREPLICABLE} UA_Disconnect;
	END_STRUCT;
END_TYPE
