# RoRo

RoRo is a CLI for building, managing environment variables for, running continuous integration tests on, and deploying your containerized applications. It aims to:

1. Roll out a greenfield, fully containerized app. 
2. Roll it off your container and onto your development machine. 
3. Roll it off your development machine and onto source control.
4. Roll it off source control and onto ci/cd.
5. Roll it off ci/cd and onto your image repository.
6. Roll it off your image repository and onto your production servers.

## Demo

[Here you go](https://nrlng-com.s3.amazonaws.com/roro_promo.mov)

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

1. Make a new directory and navigate into it:

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

