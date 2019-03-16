# Roro

Roro is a containerization and continuous integration framework for Ruby on Rails applications. Like Rails, it favors convention over configuration "...for programmer happiness and sustainable productivity." 

## Docker and Docker Compose 

You'll need [Docker](https://docs.docker.com/install/) and [Docker Compose](https://docs.docker.com/compose/install/). To see if Docker is installed:

```bash
$ docker -v
Docker version 18.03.1-ce, build 9ee9f40
```

To see if Docker Compose is installed:

```bash
$ docker-compose -v
docker-compose version 1.21.0, build 5920eb0
```

## Install

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

## Getting started

### Greenfielding a dockerized app

```bash
$ mkdir -p handsome_app
$ cd handsome_app
$ roro greenfield
```

You should now be able to see the Rails welcome screen upon clicking [http://localhost:3000/](http://localhost:3000/). 

### Rolling onto an existing app

Whether using your own app or one greenfielded using instructions above, first shut down any running docker containers: 

```bash
$ docker-compose down
```

Then, roll roro on:

```bash
$ roro rollon
```

If your host machine runs a flavor of linux, ensure its logged in user owns the generated files:

```bash
$ sudo chown <username><user group> -R .
```

And spin it up:

```bash
$ docker-compose up --build
``` 

It will take a few minutes for Docker to download your images, copy your files, and build your application. Afterward you should see the Rails welcome screen at [http://localhost:3000/](http://localhost:3000/). 

## Guard

From another terminal: 

```bash
$ docker-compose exec app bundle exec guard
```

To use LiveReoload with Guard, install the [Chrome extension](https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei?hl=en):


## Securing environment files 

Roro provides conventions for securing sensitive variables between docker containers and environments. To store a variable for use in development, create a file with that variable inside, name it "development.env," and store it in docker/env_files. Here's a one-liner:

```bash 
$ echo "export EXAMPLE_KEY=example_value" > docker/env_files/development.env
```

Next, generate a key for the development environment:

```bash 
$ roro generate_key development
```

Then encrypt the development.env file using the previously generated development key:

```bash 
$ roro obfuscate development
```

You should now have the environment file and its encrypted counterpart: 

```bash 
$ ls docker/env_files
development.env  development.env.enc
```

To see how decryption works, first back up a copy of your development.env file:


```bash 
$ mv docker/env_files/development.env docker/env_files/backup.env
```

Then expose its encrypted counterpart:

```bash 
$ roro expose development
```

You should now have three files:

```bash 
$ ls docker/env_files
backup.env  development.env  development.env.enc 
```

To verify the newly decrypted file contents match its backup:

```bash 
$ diff docker/env_files/development.env docker/env_files/backup.env 
```

## Linux notes

If you're running linux you may need to change ownership of the newly created files, prepend commands with sudo, or both. To change ownership of newly generated files:

```bash
$ sudo chown <username><user group> -R .
```

If that doesn't work, Docker's [documentation](https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user) should get you pointed in the right direction.

## Troubleshooting 

### Port in use 

Sometimes you will ge a message saying the port specified in your docker-compose.yml file is already in use. This may be because you have a server running on your host from normal development, or because another Docker container is running a server and piping it to your host. If the former you can shut it down using ctrl^c, and if the latter:

```
$ docker-compose down 
``` 

Sometimes shutting down all servers isn't enough because a .pid file remains. You can usually remove it with: 

```bash
$ rm /tmp/pids/server.pid
```

If that doesn't work, restart your machine.

### Mismatched ruby versions 

Sometimes your Gemfile will specify a ruby version which doesn't match the ruby image your app container is using. There are three ways to handle this. 

The first is to specify an image with the same version of ruby in your Gemfile as specified at the top of your Dockerfile. Open your Dockerfile and change:

```
FROM ruby:2.5
```

to:

```
FROM ruby:2.5.x
```
where 2.5.x is the ruby specified in your Gemfile. 

The second way is to specify the version of ruby used in your app container's image at the top of your Gemfile:

```ruby 
ruby '2.5.x'
``` 

The third way is to comment out or remove the specification from the Gemfile and rely on Docker for ruby version management.

### Get out of jail

To remove all images, containers, and volumes from your system and start over:

```bash
$ docker system prune -af --volumes
```

## Contributing

This gem and its associated practices are just one way of using these tools, and certainly not the canonical way. My purpose in publishing it is to get a conversation started about what that looks like. If you have ideas, please put in an issue or fork the repo, make your changes, write your tests, and send me a pull request. I'd very much appreciate it.    

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).