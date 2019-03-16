# Roro

Roro gives developers a handsome way to create, test, integrate, and deploy Ruby on Rails applications using Guard, CircleCI, Docker, Docker Compose.

## Installation

```bash
$ gem install roro
```

## Usage

Once installed, Roro provides a CLI:

```bash
$ roro --help
Commands:
  roro expose          # Expose encrypted files
  roro generate_key    # Generate a key for each environment
  roro generate_keys   # Generates keys for all environments. If you have .en...
  roro greenfield      # Greenfield a brand new rails app using Docker's inst...
  roro help [COMMAND]  # Describe available commands or one specific command
  roro obfuscate       # obfuscates any files matching the pattern ./docker/*...
  roro rollon          # Generates files necessary to greenfield a new app wi...
  roro ruby_gem        # Generate files for containerized gem testing, Circle...
```

## Installing Docker and Docker Compose 

Before using Roro's 'greenfield' and 'rollon' commands, you'll need Docker and Docker Compose. To see if Docker is installed:

```bash
$ docker -v
Docker version 18.03.1-ce, build 9ee9f40
```

Instructions for installing [Docker](https://docs.docker.com/install/). To see if Docker Compose is installed:

```bash
$ docker-compose -v
docker-compose version 1.21.0, build 5920eb0
```

Instructions for installing [Docker Compose](https://docs.docker.com/compose/install/).

## Greenfielding a dockerized app:

```bash
$ mkdir -p handsome_app
$ cd handsome_app
$ roro greenfield
$ docker-compose up
```

You should now be able to see the Rails welcome screen upon clicking [http://localhost:3000/](http://localhost:3000/). 

If you're on a linux machine and run into issues, please see the
[linux notes](#linux-notes).


### Rolling onto an existing app:

Using your own app or one generated using the 'greenfield' instructions above: 

```bash
$ docker-compose down
$ roro rollon
$ docker-compose up
```

You should now be able to see the Rails welcome screen upon clicking [http://localhost:3000/](http://localhost:3000/). 

## Securing environment files 

Roro gives provides conventions for securing your environment files. To store a variable for use in your development environment, create a file with that variable, name it "development.env," and store it in docker/env_files like so:

```bash 
$ echo "export export EXplace to put environment files for use in dockerized environments. AMPLE_KEY=example_value" > docker/env_files/development.env
$ roro generate_key development
$ roro obfuscate development
```

You should now see an environment file and its encrypted counterpart in docker/env_files: 

```bash 
$ ls docker/env_files
development.env  development.env.enc
```

To expose a previously obfuscated file:

```bash 
$ mv docker/env_files/development.env docker/env_files/backup.env
$ roro expose development
```

To verify the newly decrypted file contents match its backup:

```bash 
$ diff docker/env_files/development.env docker/env_files/backup.env 
```

## Linux notes

If you're on a linux machine, you may need to change ownership of the newly created files:

```bash
$ sudo chown <username><user group> -R .
```

If that doesn't work, Docker's [documentation](https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user) should get you pointed in the right direction.

## Troubleshooting 

Sometimes the port is in use. This could be because you have a server running on your host machine, or because Docker is running a server and piping it to the host. To shut down a server running in Docker, do:

```
$ docker-compose down 
``` 

Sometimes shutting down all servers doesn't work, because Rails still thinks a server is already running, which is usuall because there's a .pid file somewhere. 

$ rm /tmp/pids/server.pid

Sometimes you just need a fresh start. To remove all images, containers, and volumes from your system:

$ docker system prune -af --volumes

## Contributing

This gem and the associated practices are just a way of deploying your application, not the canonical or best way. If you have suggestions on how to make it easier, more secure, quicker or better, please share them. If you have specific ideas, please fork the repo, make your changes, write your tests, and send me a pull request.    

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


 should get you pointed in the right direction. , you may need to prepend 'sudo' to the above command, or chown newly created files:

```bash
$ sudo chown <username><user group> -R .
```

If that doesn't work, Docker's [documentation](https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user) should get you pointed in the right direction.
