
#Docker

## dockerd

Este es el demonio de docker que está corriendo en la maquina, para poder acceder a las funcionalidades de docker.

1. Verificar estado de docker en la maquina

`systemctl status docker`

2. Verificar que esté habilitado el startup de docker con el equipo

`systemctl enable docker`

Lista de comandos

https://docs.docker.com/engine/reference/commandline/dockerd/

### Probar la ejecución de docker

Ejecutar

`docker run hello-world`

Esto nos mostrara un mensaje de que se creo el contenedor correctamente.

### 1. Contenedores

#### Comandos docker

1. `docker ps` - Listar containers que esten en ejecucion
2. `docker run xxx --name xyz` - Ejecuta la imagen 'xxx' y lo crea como contenedor con el nombre xyz
3. `docker images` - Lista las imagenes disponibles en local
4. `docker image prune` - Elimina todas las imagenes que ya no se usan localmente
5. `docker ps -a` Listar containers en cualquier estado
6. `docker ps -l` Lista el ultimo contenedor ejecutado
7. `docker ps -n x` Lista los ultimos x contenedores ejecutados
8. `docker run -it xxx` Ejecuta la imagen 'xxx' y crea un contenedor en modo interactivo [`-i`] y con una terminal activa [`-t`], osea, ejecutaré directamente dentro de la imagen.
9. `docker run -it --rm xxx` Ejecuta la imagen 'xxx' y crea un contenedor en modo interactivo [`-i`] y con una terminal activa [`-t`], osea, ejecutaré directamente dentro de la imagen. y una vez terminado se eliminará de inmediato `--rm`
9. `docker start -i xxx` Arranca la imagen con id xxx en modo interactivo.
10. `docker run -d xxx` Ejecuta la imagen xxx, creando un contenedor y dejandolo funcionando en background [`-d`] (detached)
11. `docker rm xxx` Elimina el contenedor con el id xxx
12. `docker rmi xxx` Elimina la imagen con el id xxx
13. `docker exec xxx ` Ejecuta un comando sobre el contenedor xxx

        P.E. `docker exec -it xxx bash` 
        Ejecuto en modo interactivo en el contenedor xxx una terminal bash

14. `docker logs xxx` Obtiene toda la salida de la consola del contenedor xxx
15. `docker logs xxx --tail 100` Obtiene las ultimas lineas de la salida de la consola del contenedor xxx
16. `docker logs xxx -f` Obtiene las lineas de salida de la consola en tiempo real del contenedor xxx
17. `docker kill xxx` Mata el proceso del contenedor xxx
18. `docker top xxx` Ver los procesos del contenedor xxx
19. `docker stats xxx` Ver el uso de un contenedor dentro del equipo
20. `docker inspect xxx > container1.json` JSON con toda la información del contenedor / image xxx
21. `docker run -d -P xxx` Creo un contenedor en base a la imagen xxx y todos los puertos del contenedor xxx serán publicos de acceso y se le asignaran puertos automaticamente de la maquina local.
22. `docker run -d -p 9090:80 xxx` Creo un contenedor en base a la imagen xxx y a traves del puerto local 9090 podré acceder al puerto 80 del contenedor xxx.



*   `docker run` crea un contenedor nuevo
*   Si quiero levantar un contenedor ya creado, debo usar `docker start`

### 2. Puertos

Por defecto si dejamos publicos los puertos, docker asignará automaticamente los puertos del contenedor a nuestra maquina. Si quiero especificar los puertos debo indicarlo con `-p <puerto-local>:<puerto-contenedor>`

Si vemos el listado de contenedores disponibles (`docker ps`). Al redireccionar un puerto dentro del contenedor, nos dirá que desde que IP por que puerto se accede al contenedor

```bash
... PORTS                   NAMES
... 0.0.0.0:49153->80/tcp   agitated_jennings
```
En el ejemplo anterior se puede acceder desde cualquier IP que tenga la maquina principal (`0.0.0.0`) y a traves desde el puerto `49153`.

Esto es, por ejemplo, que puedes acceder desde:

    localhost:49153
    192.168.0.1:49153
    127.0.0.1:49153
 
### 3. Redes

1. Tipos de drivers de red
    1.  bridge -> Comparten la red (default)
    2.  host -> No pueden verse entre si
    3.  null -> Sin driver

#### Comandos

1. `docker network ls` | Nos muestra las redes disponibles
2. `docker insepect xxx` | Nos entrega la informacion de las redes de tipo xxx [bridge, host, overlay, null] o la red con nombre xxx
3. `docker network create xxx` | Se crea la red xxx, por defecto de tipo bridge.
4. `docker network create --subnet=155.168.0.0/16 xxx` | Se crea la red xxx, con el rango de subnet 152.168.0.0/16
5. `docker run -it --network xxx ubuntu` | Se crea un contenedor con la imagen 'ubuntu' en la red xxx
6. `docker network connect xxx yyy` | Conectar el contenedor yyy a la red xxx
7. `docker network disconnect xxx yyy` | Desconectar el contenedor yyy a la red xxx
8. `docker network rm xxx` | Elimina la red xxx


### 4. Volumenes

Sirve para almacenar información dentro del contenedor y persistirla entre el equipo y el contenedor por defecto en `/var/lib/docker/volumes/`.

`-v <dir-local>:<dir-contenedor>`

#### Comandos

1. `docker run -it -v /datos --name name_xxx yyy bash` | Crea un contenedor con el nombre name_xxx en base a la imagen yyy con un volumen llamado datos ubicado en la raiz `-v /datos`
2. `docker volume ls` | Listar volumenes disponibles
3. `docker volume inspect xxx` | Inspeccionar el volumen xxx
4. `docker run -it -v /dir/origin:/test_data --name name_xxx yyy bash` | Crea un contenedor con el nombre name_xxx en base a la imagen yyy con un volumen llamado test_data ubicado en la raiz `-v /test_data` que está mapeado con la direccion local `/dir/origin` (Usar path completo)
5. `docker volume create xxx` | Crea un volumen con el nombre xxx , en vez de el hash por defecto, pero en la ubicacion por defecto de los volumes.


### 3. Imagenes

Imagenes o plantillas personalizadas con nuestras propias configuraciones.

#### Comandos

1. `docker commit xxx yyy` | Creo una nueva imagen llamada yyy en base al contenedor xxx
2. `docker build -t xxx .` | Construye una imagen con el nombre xxx en base al archivo Dockerfile ubicado en la carpeta actual (`.`)
3. `docker image history xxx` | Muestra el historial de ejecución/cambios de la imagen xxx
4. `docker run --it --env GOOGLE_KEY=123456789 --rm first_image:v4` | Con el comando `--env` agregamos la variable de entorno llamada `GOOGLE_KEY` con el valor `123456789`.

#### Comandos dentro de las imagenes

1. `FROM` ubuntu | La imagen ubuntu será la base de la nueva imagen a crear.
2. `RUN` apt-get update | Al momento de construir la imagen, se ejecutará el comando `apt-get update`
3. `CMD ["echo","Welcome"]` | Comando por defecto al terminar de construir el contenedor, solo debe haber 1 `CMD` definido dentro de la imagen, ya que si hay mas, solo ejecutará el último definido. 
                                Los comandos a ejecutar van como un parametro dentro de la lista [].
4. `ENTRYPOINT` | Este comando siempre se ejecutará, independiente la cantidad de veces declarado o reemplazado
5. `WORKDIR` /tmp/data | Este será el directorio incial una vez creado el contenedor.
6. `COPY` index.html . | Copia archivos / directorios dentro del contenedor, en este caso copia el archivo index.html en el WORKDIR actual.
7. `ADD`  index.html | Copia archivos / directorios dentro del contenedor, en este caso copia el archivo index.html en el WORKDIR actual. La ventaja de usar `ADD` es que soporta archivos `.tar` y urls remotas. Dado estas ventajas, se recomienda usar `ADD` ya que tiene mas caracteristicas.
8. `ENV` GOOGLE_KEY=123456789 AWS_KEY=987654321 | Sirve para crear variables de entorno dentro de nuestra imagen. Crea la variable GOOGLE_KEY y AWS_KEY. Ademas es valido solo en el contexto de creacion del contenedor.
9. `ARG` FACEBOOK_KEY | Al momento de construir la imagen, se debe pasar el valor para la variable FACEBOOK_KEY. `docker build -t image_test:v6 --build-arg FACEBOOK_KEY=785623892 .` Ademas es valido solo en el contexto de creacion de imagen.
10. `EXPOSE` 80 | Sirve para exponer un puerto publicamente, igualmente se debe usar `-p 8080:80` para enlazar el puerto del contenedor con la maquina.
11. `VOLUME` ["/var/www/html"] | Sirve para declarar un volumen dentro de la imagen. Se mapeara la carpeta del contenedor `/var/www/html`


### DockerHub

#### Comandos

1. `docker login`
2. `docker image tag <imagen-local>:<tag> <docker-username>/<imagen-remota>:<tag>` se crea una nueva imagen en base a una existente


### DockerCompose

Se usa para enlazar varios contenedores y compartan servicios, redes, etc. Se hacen en base a una imagen publica o custom.

Son los mismos comandos de docker, pero a traves del compose es un orquestador

#### Comandos

1. `docker-compose config` | Validar el archivo docker-compose.yml

#### Volumes

#####Hay 2 tipos de volumes, "bind" o "volume".

1.  Bind linkea una carpeta existente al contenedor
2.  Volume, crea una carpeta en `/var/lib/docker/volumes/` y la linkea con el contenedor.


### Docker Registry

Es para tener un registro de imagenes privado, sin subirlo a DockerHub o cualquier pagina publica.


Se basa en una imagen del docker-hub donde se almacenan los registros

#### Comandos

1. `docker run -d -p 5000:5000 --name docker_registry_1 registry` | Iniciar el docker registry

##### Subir y bajar imagenes al registro

1. `docker tag first_image localhost:5000/primera_imagen` | Crear el tag de la imagen local first_image para el destino localhost:5000 en el registro primera_imagen, solo queda en local
2. `docker push localhost:5000/primera_imagen` | Sube todas las versiones de la imagen al registro remoto localhost:5000, push de los cambios del punto `1`
3. `docker rmi localhost:5000/primera_imagen` | Borra las imagenes primera_imagen del registro en mi local
4. `docker pull localhost:5000/primera_imagen` | Vuelve a descargar las imagenes del registro primera_imagen

##### Cambiar destino almacenamiento

1. `docker run -d -p 5001:5000 -v /home/elias.vargas/Proyectos/Elias/docker_curso/reg_docker:/var/lib/registry --name docker_registry_vol registry`


### Docker SWARM

Cluster de imagenes dockers, tiene un gestor conocido como manager, pueden haber 1...n encargado de orquestar las solicitudes.

Estan los workers, que son nodos fisicos o virtual donde tienen alojada la imagen.

Se tienen N cantidad de nodos/workers donde cada manager resuelve las solicitudes a cualquier nodo/worker.


#### Comandos

1. `docker swarm init` | Iniciar la maquina como manager de docker swarm, al crearlo te dará un token que es necesario para asociar los nodos.
    P.E.
        `docker swarm join --token SWMTKN-1-53ervldgmt9cyearwwv3yfit0erhn9adpfsqotq4yrkqzaco0d-012gj6yy36tpja1oykmksider 192.168.0.13:2377`
2. aca
