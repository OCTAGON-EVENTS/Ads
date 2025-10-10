@ECHO OFF

SETLOCAL ENABLEDELAYEDEXPANSION

FOR /f "skip=1" %%x IN ('wmic os get localdatetime') DO IF NOT DEFINED CurrentDate SET CurrentDate=%%x
SET year=%CurrentDate:~0,4%
SET month=%CurrentDate:~4,2%
SET day=%CurrentDate:~6,2%

IF NOT EXIST "Remove\" MKDIR "Remove"

FOR /F "delims=" %%f IN ('DIR /B') DO (
	IF EXIST "%%f\" (
		IF "%%f" NEQ "Remove" (
			IF EXIST "%%f\%%f.txt" DEL "%%f\%%f.txt"
			
			FOR /F "delims=" %%a IN ('DIR /B "%%f"') DO (
				SET filename=%%a
				IF /I "!filename:~0,1!" NEQ "X" (
					
					FOR /F "tokens=1-6 delims=-_" %%g IN ("%%a") DO (
						SET adYear=%%g
						SET adMonth=%%h
						SET adDay=%%i
						
						IF "!adMonth:~0,1!" NEQ "0" (
							SET /a adMonth+=100
							SET adMonth=!adMonth:~1,2!
						)
						IF "!adDay:~0,1!" NEQ "0" (
							SET /a adDay+=100
							SET adDay=!adDay:~1,2!
						)

						SET /a keep=!adYear!!adMonth!!adDay! - %year%%month%%day%
						IF !keep! GTR 0 (
							ECHO %%a >> "%%f\%%f.txt"
						) ELSE (
							MOVE "%%f\%%a" "Remove"
						)
					)
				) ELSE (
					ECHO %%a >> "%%f\%%f.txt"
				)
			)
		)
	)
)