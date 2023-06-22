FUNCTION_BLOCK EasyUaSubscriptionList 

	IF Enable = TRUE AND Internal.Disable = 0 THEN     
		IF Internal.EnableOld = FALSE THEN 
			EasyUaSubscriptionList_CheckParameters;
		END_IF;

		IF Internal.ParametersValid = TRUE THEN
			EasyUaSubscriptionList_CyclicCode;
		END_IF;
		Internal.EnableOld := Enable;
	ELSE
		IF Internal.EnableOld = TRUE AND Internal.Disable = 0 THEN
			Internal.Disable := 1;
		END_IF;	
		IF Internal.Disable = 0 OR Internal.Disable = 5 THEN
			EasyUaSubscriptionList_ResetInternal;
			EasyUaSubscriptionList_ResetOutputs;
		ELSE
			EasyUaSubscriptionList_Disable;
		END_IF;	
	END_IF;
	
END_FUNCTION_BLOCK