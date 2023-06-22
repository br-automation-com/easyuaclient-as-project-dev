FUNCTION_BLOCK EasyUaSubscription 

	IF Enable = TRUE AND Internal.Disable = 0 THEN     
		IF Internal.EnableOld = FALSE THEN 
			EasyUaSubscription_CheckParameters;
		END_IF;

		IF Internal.ParametersValid = TRUE THEN
			EasyUaSubscription_CyclicCode;
		END_IF;
		Internal.EnableOld := Enable;
	ELSE
		IF Internal.EnableOld = TRUE AND Internal.Disable = 0 THEN
			Internal.Disable := 1;
		END_IF;	
		IF Internal.Disable = 0 OR Internal.Disable = 5 THEN
			EasyUaSubscription_ResetInternal;
			EasyUaSubscription_ResetOutputs;
		ELSE
			EasyUaSubscription_Disable;
		END_IF;
	END_IF;
	
END_FUNCTION_BLOCK