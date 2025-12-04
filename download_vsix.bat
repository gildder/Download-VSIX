@echo off
SETLOCAL
cls

REM Batch es un shell en Windows [4].
REM Note: La sintaxis de Batch es notoriamente difícil y su documentación es pésima, según las fuentes [4].

REM --- Verificación de dependencias ---
where curl >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: La herramienta 'curl' es necesaria y no se encontro en el PATH.
    echo Por favor, instale curl o asegurese de que este en las variables de entorno del sistema.
    GOTO:error_exit
)

REM --- Verificación de argumentos ---
REM ---- Verificación y entrada interactiva de argumentos ----
REM Soporte para entrada interactiva desde el campo "More Info".
REM - Si el script recibe los 3 argumentos posicionales, los usa tal cual.
REM - Si no se recibe la version (%3), pedimos los valores al usuario con instrucciones.
REM - Si el primer argumento contiene "Publisher.Extension" (Unique Identifier), lo parseamos.
IF "%3"=="" (
    REM No se proporcionó la versión: entra en modo interactivo/parsing.
    IF NOT "%1"=="" IF "%2"=="" (
        SET "UNIQUE_ID=%1"
        GOTO:parse_unique
    )
    GOTO:interactive_input
)

REM Si llegaron 3 argumentos, usarlos directamente
SET "PUBLISHER=%1"
SET "EXTENSION_NAME=%2"
SET "VERSION=%3"
GOTO:args_done

REM --- Construcción de la URL y nombre de archivo ---
SET URL=https://ms-vscode.gallery.vsassets.io/_apis/public/gallery/publisher/%PUBLISHER%/extension/%EXTENSION_NAME%/%VERSION%/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage
SET OUTPUT_FILENAME=%PUBLISHER%.%EXTENSION_NAME%-%VERSION%.vsix

REM --- Proceso de descarga ---
echo =========================================================
echo Descargando VSIX para: %PUBLISHER%.%EXTENSION_NAME% (v%VERSION%)
echo URL de descarga construida: %URL%
echo El archivo se guardara como: %OUTPUT_FILENAME%
echo =========================================================

REM Usar curl: -L para seguir redirecciones, -o para el archivo de salida, -f para fallar en errores HTTP (4xx, 5xx)
curl -L "%URL%" -o "%OUTPUT_FILENAME%"

IF ERRORLEVEL 1 GOTO:download_error

REM --- Éxito ---
echo.
echo Descarga completa: %OUTPUT_FILENAME%
echo Puede instalar la extension manualmente en VS Code.
GOTO:success_exit

REM --- Secciones de error y salida ---
:missing_args
REM --- Entrada interactiva: instrucciones y lectura ---
:interactive_input
echo.
echo Por favor, copia los campos desde la seccion "More Info" de la extension.
echo 1) Campo "Unique Identifier" (ejemplo: PeterSchmalfeldt.explorer-exclude)
echo    - Para el autor: copie SOLO hasta el PRIMER PUNTO (ej: PeterSchmalfeldt)
echo    - Para el nombre de la extension: copie lo que sigue DESPUES del primer punto (ej: explorer-exclude)
set /p UNIQUE_ID=Unique Identifier: 

:parse_unique
for /f "tokens=1* delims=." %%A in ("%UNIQUE_ID%") do (
    set "PUBLISHER=%%A"
    set "EXTENSION_NAME=%%B"
)
if "%PUBLISHER%"=="" (
    echo ERROR: no se pudo determinar el autor (publisher). Asegurese de copiar hasta el primer punto.
    GOTO:error_exit
)
if "%EXTENSION_NAME%"=="" (
    echo ERROR: no se pudo determinar el nombre de la extension. Asegurese de copiar lo que sigue despues del primer punto.
    GOTO:error_exit
)
echo.
echo Ahora, copie el valor completo del campo "Version" desde "More Info" (ejemplo: 1.3.2)
set /p VERSION=Version: 
if "%VERSION%"=="" (
    echo ERROR: No se proporciono la version. Abortando.
    GOTO:error_exit
)

:args_done
REM Variables listas: PUBLISHER, EXTENSION_NAME, VERSION

:download_error
echo.
echo ERROR: La descarga fallo.
echo Verifique su conexion a internet y que los datos (publisher, nombre, version) sean correctos.
GOTO:error_exit

:success_exit
    echo.
    echo =========================================================
    echo Fin del script.
    echo =========================================================
    ENDLOCAL
    exit /b 0

:error_exit
    echo.
    echo =========================================================
    echo Script finalizado con errores.
    echo =========================================================
    ENDLOCAL
    exit /b 1