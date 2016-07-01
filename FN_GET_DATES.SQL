CREATE FUNCTION "FN_SELECT_DATES"(ip_START_DATE DATE, ip_DAYS_NUMBER INT)

/*
============================================================================================                    
Author: 		Oleksii Iena
Create date: 	12/03/2015                    
Description: 	Used to generate the brach of dates starting from given one and containing given number of days
Input:			ip_START_DATE - date starting from wich generated branch
				ip_DAYS_NUMBER - number of days that we need sequence for 	
History:                    
-- =========================================================================================                                           
--		Date				Author							Description                                                                    
----------------------------------------------------------------------------------                                                       
----	12/03/2015			Oleksii Iena					Created  

-- =========================================================================================
*/

RETURNS 
	TABLE
		("DATES" DATE)
		
LANGUAGE SQLSCRIPT   
SQL SECURITY INVOKER 
AS  

BEGIN
	DECLARE v_ITTERATOR INT := 2;
	
	IF :ip_DAYS_NUMBER = 1 THEN 
		tv_RESULT = 
		SELECT :ip_START_DATE AS "DATES"
		FROM DUMMY
		;
	ELSE 
		
		tv_RESULT = 
		SELECT :ip_START_DATE AS "DATES" FROM DUMMY
		UNION
		SELECT ADD_DAYS(:ip_START_DATE, 1) AS "DATES" 
		FROM DUMMY
		;
		
		IF :ip_DAYS_NUMBER > 2 THEN
				
			WHILE :v_ITTERATOR < ip_DAYS_NUMBER DO
				
				tv_RESULT =
				SELECT "DATES" FROM :tv_RESULT
				UNION 
				SELECT ADD_DAYS("DATES", :v_ITTERATOR) FROM :tv_RESULT
				;
		
				SELECT COUNT(*) INTO v_ITTERATOR FROM :tv_RESULT;
	
			END WHILE
			;	
		END IF
		;
	END IF
	;
	
RETURN
	
	SELECT TOP :ip_DAYS_NUMBER "DATES" 
	FROM :tv_RESULT
	;
END
