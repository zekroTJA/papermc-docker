# PaperMC Docker Image

The [`Dockerfile`](Dockerfile) provided in this Repository creates a Docker Image to run a [PaperMC](https://papermc.io) server.

You can specify a `VERSION` and `BUILD` environment variable on startup to specify the used Minecraft version and Paper build. Both is defaultly set to `latest`, which will use the latest build on the latest Minecraft version.

This image is now based on the [minebase](https://github.com/zekroTJA/minebase). For further information how to use the included RCON CLI or the automatic backup system, please refer to the minebase documentation.

## How To Build

You need to build this Docker image by yourself. Just clone the repository to your server and build the image from there.

```
$ git clone https://github.com/zekroTJA/papermc-docker.git .
$ docker build . -t paper
```

## How To Run

You can use the provided [`docker-compose.yml`](docker-compose.yml) to jumpstart your server deployment.

```
$ docker-compose up -d --build
```

This will automatically build the docker image, set environment variables, bind the necessary ports and volumes.