FUNCTION_BLOCK EasyUaReadBulk

	IF Execute = TRUE AND Internal.ExecuteOld = FALSE THEN
		EasyUaReadBulk_CheckParameters;
		IF Internal.ParametersValid = TRUE THEN
			Internal.Executing := TRUE;
		END_IF;
	END_IF;
	
	Internal.ExecuteOld := Execute;
	
	IF Internal.Executing = TRUE THEN
		EasyUaReadBulk_CyclicCode;
	END_IF;
		
	IF (Done = TRUE OR Error = TRUE) AND Execute = FALSE THEN
		EasyUaReadBulk_ResetInternal;
		EasyUaReadBulk_ResetOutputs;
	END_IF;
	
END_FUNCTION_BLOCK