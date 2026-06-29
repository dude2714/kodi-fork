@ECHO OFF

IF "%1"=="" (
  ECHO ERROR! vswhere.bat: architecture not specified
  EXIT /B 1
)

REM running vcvars more than once can cause problems; exit early if using the same configuration, error if different
IF "%VSWHERE_SET%"=="%*" (
  ECHO vswhere.bat: VC vars already configured for %VSWHERE_SET%
  GOTO :EOF
)
IF "%VSWHERE_SET%" NEQ "" (
  ECHO ERROR! vswhere.bat: VC vars are configured for %VSWHERE_SET%
  EXIT /B 1
)

SET arch=%1
SET vcarch=amd64
SET vcstore=%2
SET sdkver=
SET vcvars=
SET vsver=

REM Current tools are only using x86/win32
SET toolsdir=win32

IF "%arch%" NEQ "x64" (
  SET vcarch=%vcarch%_%arch%
)

REM Prefer direct Build Tools locations first.
IF EXIST "C:\PROGRA~2\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" (
  SET vcvars=C:\PROGRA~2\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat
  SET vsver=17 2022
)

IF NOT DEFINED vcvars IF EXIST "C:\Program Files\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" (
  SET vcvars=C:\Program Files\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat
  SET vsver=17 2022
)

REM Fallback: query with vswhere when direct paths are not present.
IF NOT DEFINED vcvars (
  IF EXIST "C:\PROGRA~2\Microsoft Visual Studio\Installer\vswhere.exe" (
    FOR /f "usebackq tokens=1* delims=" %%i in (`"C:\PROGRA~2\Microsoft Visual Studio\Installer\vswhere.exe" -latest -property installationPath`) do (
      IF EXIST "%%i\VC\Auxiliary\Build\vcvarsall.bat" (
        SET vcvars=%%i\VC\Auxiliary\Build\vcvarsall.bat
        SET vsver=17 2022
      )
    )
  )
)

IF NOT DEFINED vcvars (
  ECHO ERROR! Could not find vcvarsall.bat
  EXIT /B 1
)

REM vcvars changes the cwd so we need to store it and restore it
PUSHD %~dp0
CALL "%vcvars%" %vcarch% %vcstore% %sdkver%
POPD

IF ERRORLEVEL 1 (
  ECHO ERROR! something went wrong when calling
  ECHO "%vcvars%" %vcarch% %vcstore% %sdkver%
  EXIT /B 1
)

SET VSWHERE_SET=%*
