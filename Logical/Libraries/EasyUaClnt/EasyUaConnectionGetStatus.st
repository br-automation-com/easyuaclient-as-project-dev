FUNCTION_BLOCK EasyUaConnectionGetStatus 

	IF Execute = TRUE AND Internal.ExecuteOld = FALSE THEN
		EasyUaConnectionGetStatus_CheckParameters;
		IF Internal.ParametersValid = TRUE THEN
			Internal.Executing := TRUE;
		END_IF;
	END_IF;
	
	Internal.ExecuteOld := Execute;
	
	IF Internal.Executing = TRUE THEN
		EasyUaConnectionGetStatus_CyclicCode;
	END_IF;
		
	IF (Done = TRUE OR Error = TRUE) AND Execute = FALSE THEN
		EasyUaConnectionGetStatus_ResetInternal;
		EasyUaConnectionGetStatus_ResetOutputs;
	END_IF;
	
END_FUNCTION_BLOCK
