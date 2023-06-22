FUNCTION_BLOCK EasyUaWrite 

	IF Execute = TRUE AND Internal.ExecuteOld = FALSE THEN
		EasyUaWrite_CheckParameters;
		IF Internal.ParametersValid = TRUE THEN
			Internal.Executing := TRUE;
		END_IF;
	END_IF;
	
	Internal.ExecuteOld := Execute;
	
	IF Internal.Executing = TRUE THEN
		EasyUaWrite_CyclicCode;
	END_IF;
		
	IF (Done = TRUE OR Error = TRUE) AND Execute = FALSE THEN
		EasyUaWrite_ResetInternal;
		EasyUaWrite_ResetOutputs;
	END_IF;
	
END_FUNCTION_BLOCK