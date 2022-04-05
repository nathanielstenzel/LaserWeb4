# LaserWeb (4.1.x) Docker Builds

Docker user targets:
- release
- dev

## Release
You can run the release version of the app in Docker using the commands below.
- build release image:
```
docker build --target release -t laserweb4:release .
```
- run image:
```
docker run -it --device=/dev/ttyUSB0 --rm -p 8000:8000 laserweb4:release
```
- connect to app: http://localhost:8000

## Dev (development snapshot)
You can run the current developement version of the app in Docker using the commands below.
- build development image:
```
docker build --target dev -t laserweb4:dev .
```
- run image:
```
docker run -it --device=/dev/ttyUSB0 --rm -p 8000:8000 laserweb4:release
```
- connect to app: http://localhost:8000

## Run in background
If you add `-d` to the docker run command it will start the container in detached mode.
You can use `docker logs -f <uuid>` to follow the output of this.

## Clean build
If you plan to release the docker build it is suggested you clean the dist folder first:
`rm dist/* && git checkout dist`
