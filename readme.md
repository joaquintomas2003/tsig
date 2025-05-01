## Setup en Mac:

### Instalar Java
```
brew install openjdk
sudo ln -sfn /usr/local/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
echo 'export PATH="/usr/local/opt/openjdk/bin:$PATH"' >> ~/.zshrc
export CPPFLAGS="-I/usr/local/opt/openjdk/include"
```

### Instalar GeoServer
- Descargar geoserver (Platform Independent Binary) de https://geoserver.org/release/stable/
- Para iniciar y detener geoserver los scripts estan en `tu_ruta/geoserver-2.27.0-bin/bin/`
- Opcional: agregar alias para iniciar detener geoserver, agregar a `~/.zshrc`:
```
export GEOSERVER_HOME="tu_ruta/geoserver-2.27.0-bin"
alias geoserverstart="$GEOSERVER_HOME/bin/startup.sh"
alias geoserverstop="$GEOSERVER_HOME/bin/shutdown.sh"
```
