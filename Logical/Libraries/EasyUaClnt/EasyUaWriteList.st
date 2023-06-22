FUNCTION_BLOCK EasyUaWriteList 

	IF Execute = TRUE AND Internal.ExecuteOld = FALSE THEN
		EasyUaWriteList_CheckParameters;
		IF Internal.ParametersValid = TRUE THEN
			Internal.Executing := TRUE;
		END_IF;
	END_IF;
	
	Internal.ExecuteOld := Execute;
	
	IF Internal.Executing = TRUE THEN
		EasyUaWriteList_CyclicCode;
	END_IF;
		
	IF (Done = TRUE OR Error = TRUE) AND Execute = FALSE THEN
		EasyUaWriteList_ResetInternal;
		EasyUaWriteList_ResetOutputs;
	END_IF;
	
END_FUNCTION_BLOCK