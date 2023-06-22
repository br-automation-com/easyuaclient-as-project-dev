FUNCTION_BLOCK EasyUaRead 

	IF Execute = TRUE AND Internal.ExecuteOld = FALSE THEN
		EasyUaRead_CheckParameters;
		IF Internal.ParametersValid = TRUE THEN
			Internal.Executing := TRUE;
		END_IF;
	END_IF;
	
	Internal.ExecuteOld := Execute;
	
	IF Internal.Executing = TRUE THEN
		EasyUaRead_CyclicCode;
	END_IF;
		
	IF (Done = TRUE OR Error = TRUE) AND Execute = FALSE THEN
		EasyUaRead_ResetInternal;
		EasyUaRead_ResetOutputs;
	END_IF;
	
END_FUNCTION_BLOCK