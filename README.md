# RoRo

RoRo is a CLI that runs best in a container and which you can use to:

1. Roll your own greenfield app into a container. 
2. Roll it off your container and onto your dev box. 
3. Roll it off your dev box and onto source control.
4. Roll it off source control and onto ci/cd.
5. Roll it off ci/cd and onto your image repository.
6. Roll it off your image repository and onto your production servers.

You can also use it to safely manage and expose your environment variables in the containers and environmens that need them.

## Demo

[Here you go](https://www.youtube.com/watch?v=-BxJuUQk1XI)

## Getting started

### Check your Docker and Docker Compose Dependencies: 

You'll need [Docker](https://docs.docker.com/install/) and [Docker Compose](https://docs.docker.com/compose/install/). To confirm Docker is installed:

```bash
$ docker -v
Docker version 18.03.1-ce, build 9ee9f40
```

To confirm Docker Compose is installed:

```bash
$ docker-compose -v
docker-compose version 1.21.0, build 5920eb0
```

### Greenfield a new app:

1. Most RoRo adventures will copy files from their container and onto your host machine. To avoid making a mess, make a new directory and navigate into it:

```bash
$ mkdir -p greenfield
$ cd greenfield
```

2. Use the RoRo CLI to generate a greenfield app inside the RoRo container and then copy it onto your development machine: 

```shell
docker run \
  --name artifact \
  -v $PWD:/artifact \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -u 0 \
  -it handsomefencer/roro:latest roro rollon
```

### Note for Linux users
Once you've rolled your greenfielded app out of the RoRo container and onto your development machine, you'll want to establish ownership of them 

```bash
$ sudo chown <username><user group> -R .
```

## Contributing

I can definitely use some help and if you have any thoughts about this, please open an issue. 

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

