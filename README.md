<div align="center" id="top"> 

  <!-- <a href="https://downloadvsix.netlify.app">Demo</a> -->
</div>

<h1 align="center">Download VSIX</h1>

<p align="center">
  <a href="#dart-about">About</a> &#xa0; | &#xa0; 
  <a href="#rocket-technologies">Technologies</a> &#xa0; | &#xa0;
  <a href="#white_check_mark-requirements">Requirements</a> &#xa0; | &#xa0;
  <a href="#checkered_flag-starting">Starting</a> &#xa0; | &#xa0;
  <a href="#memo-license">License</a> &#xa0; | &#xa0;
  <a href="https://github.com/gildder" target="_blank">Author</a>
</p>

<br>

## :dart: About ##

Este repositorio contiene scripts para descargar paquetes de extensión VSIX directamente desde el Marketplace de Visual Studio Code, lo cual es útil para instalaciones offline o para archivar versiones específicas de una extensión.

El script puede usarse con argumentos (`publisher`, `extension_name`, `version`) o en modo interactivo, pegando los valores que aparecen en la sección **More Info** de la página de una extensión.

![image 1.png](image%201.png)

## :rocket: Technologies ##

Tecnologías y herramientas utilizadas en los scripts:

- **Windows:** `Windows Batch (.bat)`
- **Linux & macOS:** `Bash (.sh)`
- `curl` — herramienta universal usada para realizar las descargas.

## :white_check_mark: Requirements ##

Antes de usar los scripts, asegúrate de tener:

- `curl` disponible en el `PATH` de tu sistema. Los scripts verificarán su existencia.
- El sistema operativo correspondiente para el script que deseas usar.

## :checkered_flag: Starting ##

No es necesario instalar dependencias adicionales. Simplemente clona el repositorio y ejecuta el script adecuado para tu sistema operativo.

### Para Windows

Usa el script `download_vsix.bat`. Puedes ejecutarlo desde una terminal como `PowerShell` o `Git Bash`.

```powershell
# Modo interactivo (el script te pedirá los datos):
./download_vsix.bat

# Modo por argumentos (proporcionando publisher, nombre y versión):
./download_vsix.bat PeterSchmalfeldt explorer-exclude 1.3.2

# Modo con 'Unique Identifier' (el script pedirá la versión):
./download_vsix.bat PeterSchmalfeldt.explorer-exclude
```

### Para Linux y macOS

Usa el script `download_vsix.sh`. Primero, necesitarás darle permisos de ejecución.

```bash
# 1. Dar permisos de ejecución al script (solo la primera vez)
chmod +x download_vsix.sh

# 2. Ejecutar el script
# Modo interactivo:
./download_vsix.sh

# Modo por argumentos:
./download_vsix.sh PeterSchmalfeldt explorer-exclude 1.3.2

# Modo con 'Unique Identifier':
./download_vsix.sh PeterSchmalfeldt.explorer-exclude
```

En ambos sistemas, el modo interactivo te guiará para copiar y pegar la información necesaria desde la página de la extensión en el Marketplace.

## :memo: License ##

This project is under license from MIT. For more details, see the [LICENSE](LICENSE.md) file.


Made with :heart: by <a href="https://github.com/gildder" target="_blank">Gildder</a>

&#xa0;

<a href="#top">Back to top</a>