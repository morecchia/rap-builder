@ECHO off
REM --------------------------------------------------------------------
REM Description: Generates a rap for Relativity 9.2 and above based in
REM		a code repository. This script uses BuildHelper, MSBuild and
REM 	RAPBuilder to generate it. For more info https://wiki.nserio.com
REM Input parameters:
REM		%1 = Repository location (Location of Visual Studio projects)
REM		%2 = Repository Build location (Location of the build .exe and .xml)
REM		%3 = Build name .xml (the "Build.xml")
REM		%4 = Application Version in the new RAP
REM --------------------------------------------------------------------
IF %1.==. GOTO REPOANDVERSIONNEEDED
IF %2.==. GOTO REPOANDVERSIONNEEDED
IF %3.==. GOTO REPOANDVERSIONNEEDED
IF %4.==. GOTO REPOANDVERSIONNEEDED
SET ROOT_REPO_PATH=%1
SET REPO_PATH=%2
SET BUILD_FILE=%3
SET BUILD_VERSION=%4
IF EXIST "kCura.BuildHelper.exe" ( GOTO RUNBUILDHELPER ) ELSE ( GOTO BUILDHELPERNOTFOUND )
:RUNBUILDHELPER	
    ECHO Running BuildHelper tool %REPO_PATH%
	kCura.BuildHelper.exe /source:%REPO_PATH% /input:%REPO_PATH%\%BUILD_FILE% /output:%ROOT_REPO_PATH%\msbuild.targets /vs:16.0 /sign:false	
	GOTO BUILDSOLUTION
	GOTO END
:BUILDSOLUTION
	SET MSBUILDPATH=C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MsBuild.exe
	FOR /F "tokens=*" %%A IN ('DIR %ROOT_REPO_PATH%\*.sln /S /B') DO "%MSBUILDPATH%" "%%A" /p:CustomBeforeMicrosoftCSharpTargets=%ROOT_REPO_PATH%\msbuild.targets /p:Configuration=Release /p:VisualStudioVersion=16.0 /clp:ErrorsOnly /m:4
	IF %ERRORLEVEL% EQU 0 (
		IF EXIST "kCura.RAPBuilder.exe" ( GOTO BUILDRAP )
		ELSE ( GOTO RAPBUILDERNOTFOUND )
	)
	GOTO END
:BUILDRAP
	kCura.RAPBuilder.exe /source:%REPO_PATH% /input:%REPO_PATH%\%BUILD_FILE% /version:%BUILD_VERSION% /servertype:local /debug:false /sign:false
	REM REMOVE PUBLISHED FILES -- BEGIN
	FOR /D %%i IN (%ROOT_REPO_PATH%"\temporary publish"*) DO rd /S /Q "%%i"
	del /F /Q %ROOT_REPO_PATH%\msbuild.targets
	REM REMOVE PUBLISHED FILES -- END
	GOTO END
:BUILDHELPERNOTFOUND
	ECHO BuildHelper not found: Check 'kCura.BuildHelper.exe'
	GOTO END
:RAPBUILDERNOTFOUND
	ECHO RAPBuilder not found: Check 'kCura.RAPBuilder.exe'
	GOTO END
:REPOANDVERSIONNEEDED
	ECHO ROOT_REPO_PATH, REPO_PATH, BUILD_FILE, and BUILD_VERSION are required. Build syntax should be like 'Build.bat "Root Folder" "Source Folder" "Build XML file" "1.0.0.0"'
:END