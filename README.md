# General information

**Description**<br>
The EasyUaClnt is a simplicity wrapper library based on AsOpcUac. Anyone who has tried to program a functionality (node read, node write, subscription...) with the AsOpcUac library knows that for each functionality, several function block (FUB) calls are required. The idea behind this library is to provide a clear interface to the user and encapsulate each functionality in *one* function block (FUB).

**Minimum versions**<br>
Minimum version requirements are:
* Automation Studio: 4.2
* Automation Runtime: C4.25

**Functionalities**<br>
The functionalities of this library exhibit no constraints when compared with the AsOpcUac library ones. It allows the user to perform the following actions in OPC UA as a client in a easier way:
* Read
* ReadList
* ReadBluk
* Write
* WriteList
* WriteBulk
* Subscription
* SubscriptionList
* MethodCall
* ConnectionGetStatus

**Library help**<br>
The library has its own help that comes with samples for each of the functionalities listed before. From AS can be accessed by pressing F1 over the library.<br>
![image](https://github.com/br-automation-com/easyuaclient-as-project-dev/assets/59730058/c75d8375-6240-4e5f-9ea4-7ca79acdbb9d)

# Example

**EasyUaRead - Read an OPC UA node**<br> 
In the following example is shown how an OPC UA node can be read from an OPC UA Server using just 1 FUB. To achieve the same result using AsOpcUac is necessary the usage of 6 FUBs.
* AsOpcUac: UA_Connect -> UA_GetNamespaceIndex -> UA_NodeGetHandle -> UA_Read -> UA_NodeReleaseHandle -> UA_Disconnect
* EasyUaClint: EasyUaRead

The PLC1 (192.168.0.105) works as OPC UA Client and implements the function EasyUaRead from the library EasyUaClnt. The value of the variable read from the server is copied to the local variable "VarA" of the task "Read".

The PLC2  (192.168.0.106) works as OPC UA Server. In the PLC2 the name of the variable is "VarX" and it is a local variables of the task "ServerTask" and it is Enabled in the OPC UA Default View configuration.

*PLC1 code - Task Read*
```
PROGRAM _INIT
	VarA;
	EasyUaRead_0.ServerEndpointUrl := 'opc.tcp://192.168.0.106:4840';
	EasyUaRead_0.NodeID.NamespaceIndex := 6;
	EasyUaRead_0.NodeID.Identifier := '::ServerTask:VarX';
	EasyUaRead_0.NodeID.IdentifierType := UAIdentifierType_String;
	EasyUaRead_0.Variable := '::Read:VarA';
END_PROGRAM

PROGRAM _CYCLIC
	EasyUaRead_0();
END_PROGRAM
```

*Execution of the FUB*<br>
![image](https://github.com/br-automation-com/easyuaclient-as-project-dev/assets/59730058/ce07ed60-3dcf-492c-94e0-e269ec59737d)
