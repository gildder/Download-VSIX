#!/bin/bash

# Este script descarga un archivo VSIX (extensión de VS Code) desde el Marketplace.
# Funciona de manera similar al script de batch original, pero para Linux y macOS.

# --- Verificación de dependencias ---
if ! command -v curl &> /dev/null; then
    echo "ERROR: La herramienta 'curl' es necesaria y no se encontró en el PATH." >&2
    echo "Por favor, instale curl para continuar." >&2
    exit 1
fi

# --- Funciones ---

# Función para mostrar cómo usar el script
show_usage() {
    echo "Uso: $0 [PUBLISHER EXTENSION_NAME VERSION]"
    echo "   o: $0 [PUBLISHER.EXTENSION_NAME]"
    echo "   o: $0 (para modo interactivo)"
}

# Función para manejar la salida con error
exit_with_error() {
    echo "" >&2
    echo "=========================================================" >&2
    echo "Script finalizado con errores." >&2
    echo "=========================================================" >&2
    exit 1
}

# --- Lógica principal de argumentos ---

# Si se proporcionan 3 argumentos, usarlos directamente
if [ "$#" -eq 3 ]; then
    PUBLISHER="$1"
    EXTENSION_NAME="$2"
    VERSION="$3"
# Si se proporciona 1 argumento (Unique Identifier), pedir la versión
elif [ "$#" -eq 1 ]; then
    UNIQUE_ID="$1"
    if [[ ! "$UNIQUE_ID" == *.* ]]; then
        echo "ERROR: El 'Unique Identifier' debe tener el formato 'Publisher.ExtensionName'." >&2
        show_usage >&2
        exit_with_error
    fi
    # Extraer publisher y extension name
    PUBLISHER=$(echo "$UNIQUE_ID" | cut -d. -f1)
    EXTENSION_NAME=$(echo "$UNIQUE_ID" | cut -d. -f2-)
    
    echo "Unique Identifier procesado:"
    echo "  - Publisher: $PUBLISHER"
    echo "  - Extension: $EXTENSION_NAME"
    echo ""
    # Pedir la versión al usuario
    read -p "Por favor, ingrese la versión de la extensión (ej: 1.3.2): " VERSION
    if [ -z "$VERSION" ]; then
        echo "ERROR: No se proporcionó la versión. Abortando." >&2
        exit_with_error
    fi
# Si no hay argumentos (o un número incorrecto), entrar en modo interactivo
elif [ "$#" -eq 0 ]; then
    echo "Modo interactivo."
    echo "Por favor, copie los valores desde la sección 'More Info' de la página de la extensión."
    echo ""
    read -p "Ingrese el 'Unique Identifier' (ej: ms-vscode.cpptools): " UNIQUE_ID
    
    if [[ ! "$UNIQUE_ID" == *.* ]]; then
        echo "ERROR: El 'Unique Identifier' debe tener el formato 'Publisher.ExtensionName'." >&2
        exit_with_error
    fi

    PUBLISHER=$(echo "$UNIQUE_ID" | cut -d. -f1)
    EXTENSION_NAME=$(echo "$UNIQUE_ID" | cut -d. -f2-)

    if [ -z "$PUBLISHER" ] || [ -z "$EXTENSION_NAME" ]; then
        echo "ERROR: No se pudo parsear el 'Unique Identifier'." >&2
        exit_with_error
    fi

    echo ""
    read -p "Ahora, ingrese la 'Version' (ej: 1.8.4): " VERSION
    if [ -z "$VERSION" ]; then
        echo "ERROR: No se proporcionó la versión. Abortando." >&2
        exit_with_error
    fi
else
    echo "ERROR: Número incorrecto de argumentos." >&2
    show_usage >&2
    exit_with_error
fi


# --- Construcción de la URL y nombre de archivo ---
URL="https://ms-vscode.gallery.vsassets.io/_apis/public/gallery/publisher/$PUBLISHER/extension/$EXTENSION_NAME/$VERSION/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
OUTPUT_FILENAME="$PUBLISHER.$EXTENSION_NAME-$VERSION.vsix"

# --- Proceso de descarga ---
echo ""
echo "========================================================="
echo "Descargando VSIX para: $PUBLISHER.$EXTENSION_NAME (v$VERSION)"
echo "URL de descarga: $URL"
echo "El archivo se guardará como: $OUTPUT_FILENAME"
echo "========================================================="

# Usar curl: 
# -L para seguir redirecciones
# -f para fallar en errores HTTP (4xx, 5xx) y devolver un código de salida distinto de cero
# -o para especificar el archivo de salida
curl -L -f "$URL" -o "$OUTPUT_FILENAME"

# Verificar si curl falló
if [ "$?" -ne 0 ]; then
    echo "" >&2
    echo "ERROR: La descarga falló." >&2
    echo "Verifique su conexión a internet y que los datos (publisher, nombre, versión) sean correctos." >&2
    exit_with_error
fi

# --- Éxito ---
echo ""
echo "Descarga completa: $OUTPUT_FILENAME"
echo "Puede instalar la extensión manualmente en VS Code o VSCodium."
echo ""
echo "========================================================="
echo "Fin del script."
echo "========================================================="

exit 0
