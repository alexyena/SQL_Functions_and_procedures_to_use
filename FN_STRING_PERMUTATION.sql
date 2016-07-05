CREATE FUNCTION "FN_STRING_PERMUTATION"(ip_InputString NVARCHAR(5000),ip_SEPARATOR NVARCHAR(1))

/*
============================================================================================                    
Author: 		Oleksii Iena
Create date: 	12/28/2015
Description: 	Used to replace string elements separated with "ip_SEPARATOR" and output them in alphabetic order
Input:			Parameters are to be in NVARCHAR format.
					ip_InputString	- string contains some namber of characters that contain separator. 
					ip_SEPARATOR	- 
History:                    
-- =========================================================================================                                           
--		Date				Author							Description                                                                    
--------------------------------------------------------------------------------------------                                                       
----	12/28/2015			Oleksii Iena					Created

-- =========================================================================================
*/

RETURNS result NVARCHAR(5000) 

LANGUAGE SQLSCRIPT 
SQL SECURITY INVOKER
AS

BEGIN
	DECLARE v_Counter INT := 0;
	DECLARE v_Counter2 INT := 0;
	DECLARE v_ElementsNumber INT := 0;
	DECLARE v_Separator_Position INT;
	DECLARE v_ElementsString NVARCHAR(5000) := :ip_InputString;
	DECLARE a_String_Array NVARCHAR(5000) ARRAY;
	
	result := '';	
	v_Separator_Position := LOCATE(:v_ElementsString, :ip_SEPARATOR);
	
	IF :v_Separator_Position != 0 THEN


--	STEP 1. Split string to array
		WHILE :v_Separator_Position > 0 DO
			v_Counter := :v_Counter + 1;
			a_String_Array[:v_Counter] := LEFT(:v_ElementsString, :v_Separator_Position -1);
			v_ElementsString := RIGHT(:v_ElementsString, LENGTH(:v_ElementsString) - LENGTH(:a_String_Array[:v_Counter]) -1);
			v_Separator_Position := LOCATE(:v_ElementsString, :ip_SEPARATOR);
		END WHILE;
	
		v_Counter := :v_Counter + 1; 
		a_String_Array[:v_Counter] := :v_ElementsString;
		v_ElementsString := '';	
		v_ElementsNumber := :v_Counter;
		v_Counter := 1;

--	STEP 2. Sort array.
		FOR v_Counter IN 1 .. v_ElementsNumber - 1 DO
			IF :v_Counter < :v_ElementsNumber THEN
				IF	ASCII(:a_String_Array[:v_Counter + 1]) < ASCII(:a_String_Array[:v_Counter]) THEN
					v_ElementsString := :a_String_Array[:v_Counter + 1];
					v_Counter2 := :v_Counter;
				
					WHILE ASCII(:a_String_Array[:v_Counter2]) > ASCII(:v_ElementsString) DO
						a_String_Array[(:v_Counter2 + 1)] := :a_String_Array[:v_Counter2];
						a_String_Array[:v_Counter2] := :v_ElementsString;
						IF :v_Counter2 = 1 THEN
							BREAK;
						ELSE 
							v_Counter2 := :v_Counter2 - 1;
						END IF;
					END WHILE;
				END IF;
			END IF; 
		END FOR;	

		
		v_Counter := 1;
		v_ElementsString := '';
		
		WHILE :v_Counter < :v_ElementsNumber DO
			v_ElementsString := CONCAT(CONCAT(:v_ElementsString, :a_String_Array[:v_Counter]), :ip_SEPARATOR) ;
			v_Counter := :v_Counter + 1;
		END WHILE;	
	
	ELSE 
		v_Counter := 1;
		a_String_Array[:v_Counter] := '';
	END IF
	;		
	result := CONCAT(:v_ElementsString, :a_String_Array[:v_Counter]);
END
