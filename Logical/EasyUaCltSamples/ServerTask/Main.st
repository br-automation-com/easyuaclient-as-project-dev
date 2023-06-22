
PROGRAM _INIT
	(* Server variables *)
	TestStructA;
END_PROGRAM

PROGRAM _CYCLIC
	VarX := VarX + 1;
	VarY := VarY + 1;
	VarZ := VarZ + 1;	
	
	CASE Step OF
		0:
			UaSrv_MethodOperate_0.Action  := UaMoa_CheckIsCalled; 
			UaSrv_MethodOperate_0.MethodName := 'Multiply';
			UaSrv_MethodOperate_0.Execute := TRUE;
			Step := 1;
		1:
			UaSrv_MethodOperate_0();
			IF UaSrv_MethodOperate_0.Busy THEN
				UaSrv_MethodOperate_0.Execute := FALSE;
			ELSE
				IF UaSrv_MethodOperate_0.Done THEN
					IF UaSrv_MethodOperate_0.IsCalled THEN
						Step := 2;
					END_IF
					UaSrv_MethodOperate_0.Execute := TRUE;
				END_IF
				IF UaSrv_MethodOperate_0.Error THEN
					Step := 0;
				END_IF
			END_IF
		2:
			VarResult := VarA * VarB;
			Step := 3;
		3:
			UaSrv_MethodOperate_0.Action  := UaMoa_Finished;
			UaSrv_MethodOperate_0.MethodName := 'Multiply';
			UaSrv_MethodOperate_0.Execute := TRUE;
			Step := 4;
		4:
			UaSrv_MethodOperate_0();
			IF UaSrv_MethodOperate_0.Busy THEN
				UaSrv_MethodOperate_0.Execute := FALSE;
			ELSE
				IF UaSrv_MethodOperate_0.Done THEN
					Step := 0;
				END_IF
				IF UaSrv_MethodOperate_0.Error THEN
					Step := 0;
				END_IF
			END_IF
	END_CASE;		
END_PROGRAM

PROGRAM _EXIT
END_PROGRAM

