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
```

You should now be able to see the Rails welcome screen upon clicking [http://localhost:3000/](http://localhost:3000/). 

## Rolling onto an existing app:

Using your own app or one generated using the 'greenfield' instructions above, first shut down any running docker images: 

```bash
$ docker-compose down
```

Roll roro onto the app:

```bash
$ roro rollon
```

If you're on a linux machine, make sure the host user owns the generated files:

```bash
$ sudo chown <username><user group> -R .
```

And spin it up:

```bash
$ docker-compose up --build
``` 

Relax for a few minutes while You should now be able to see the Rails welcome screen upon clicking [http://localhost:3000/](http://localhost:3000/). 

## Guard:

From another terminal: 

```bash
$ docker-compose exec app bundle exec guard
```

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

### Port in use 

Sometimes the port specified in your docker-compose.yml file is already in use by the host. This could be because you have a server running on your host from normal rails development, or because another Docker container is running a server and piping it to your host. To shut down a server running in Docker, do:

```
$ docker-compose down 
``` 

Sometimes shutting down all servers isn't enough, because Rails sees a .pid file for a server somewhere. you can usually remove it with: 

```bash
$ rm /tmp/pids/server.pid
```

### Mismatched rubies 

Sometimes your Gemfile will specify a ruby version that doesn't match the ruby image Docker is using. There are two ways to fix this. The first is to change the line at the top of your app's Dockerfile to specify the correct ruby image and the second is to change the line at the top of your app's Gemfile. 

To use the Dockerfile method, change:

```
FROM ruby:2.5
```

to:

```
FROM ruby:2.5.x
```
where 2.5.x is the ruby specified in your Gemfile.

To use the Gemfile method, comment out or remove the ruby specification in your Gemfile:

```ruby 
# ruby '2.5.3'
``` 

Which will cause your app to use the ruby version in the app container's Dockerfile.


### Last resort

Sometimes you just need a fresh start. To remove all images, containers, and volumes from your system and start over:

```bash
$ docker system prune -af --volumes
```

## Contributing

This gem and the associated practices are just a way of deploying your application, not the canonical or best way. If you have suggestions on how to make it easier, more secure, quicker or better, please share them. If you have specific ideas, please fork the repo, make your changes, write your tests, and send me a pull request.    

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


 should get you pointed in the right direction. , you may need to prepend 'sudo' to the above command, or chown newly created files:

```bash
$ sudo chown <username><user group> -R .
```

If that doesn't work, Docker's [documentation](https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user) should get you pointed in the right direction.
