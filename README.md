# RoRo

RoRo is a containerization and continuous integration framework for Ruby applications. Like Rails, it favors convention over configuration. It aims to provide everything you need to:

1. Greenfield a Rails app in its own container that can talk to a separate Postgresql container.
2. Containerize your existing application and database in development.
3. Run your tests with Guard in a separate container.
4. Roll your containers onto CircleCI for testing.
5. Roll your containers off of CircleCI to your servers.

## Getting started

### Install

RoRo can be installed
```bash
$ gem install roro
```

Once installed, RoRo provides a CLI:

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

However to use RoRo


### Docker and Docker Compose 

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

### Greenfielding a dockerized app

```bash
$ mkdir -p handsome_app
$ cd handsome_app
$ roro greenfield
```

It'll take a few minutes for Docker to download your images, copy your files, and build your application but once finished, you'll see the Rails welcome screen at [http://localhost:3000](http://localhost:3000/). 

### Rolling onto an existing app

Whether using your own app or one greenfielded using instructions above, first shut down any running docker containers: 

```bash
$ docker-compose down
```

Then, roll RoRo on:

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

As with greenfielding above, wait a few minutes, and when it's finished, open [http://localhost:3000/](http://localhost:3000/). 


### Guard and tests

From another terminal: 

```bash
$ docker-compose exec app bundle exec guard
```

To use LiveReoload with Guard, install the Chrome [extension](https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei?hl=en):


## Deployment 

### Securing environment files 

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

To verify the newly decrypted file's contents match those of its backup:

```bash 
$ diff docker/env_files/development.env docker/env_files/backup.env 
```

## Notes 

### Linux

If you're running linux you may need to change ownership of the newly created files, prepend commands with sudo, or both. To change ownership of newly generated files:

```bash
$ sudo chown <username><user group> -R .
```

If that doesn't work, Docker's [documentation](https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user) should get you pointed in the right direction.

### Troubleshooting 

#### Port in use 

Sometimes you will ge a message saying the port specified in your docker-compose.yml file is already in use. This may be because you have a server running on your host from normal development, or because another Docker container is running a server and piping it to your host. If the former you can shut it down using ctrl^c, and if the latter:

```
$ docker-compose down 
``` 

Sometimes shutting down all servers isn't enough because a .pid file remains. You can usually remove it with: 

```bash
$ rm /tmp/pids/server.pid
```

If that doesn't work, restart your machine.

#### Mismatched ruby versions 

Sometimes your Gemfile will specify a ruby version which doesn't match the ruby version of the image your container is using. There are three ways to handle this. The first way is to specify an image with the same version of ruby as is in your Gemfile. Open your Dockerfile and change:

```
FROM ruby:2.5
```
to:
```
FROM ruby:2.5.x
```
...where 2.5.x is the ruby specified in your Gemfile. The second way is to specify the same version of ruby in your app container's image as at the top of your Gemfile:

```ruby 
ruby '2.5.x'
``` 

The third way is to remove the ruby specification from your Gemfile, relying on your Dockerfile for ruby version management.

#### Get out of jail

To remove all images, containers, and volumes from your system and start over:

```bash
$ docker system prune -af --volumes
```

## Contributing

This gem and its associated practices are just one way of using these tools and not the canonical way. My purpose in publishing it is to get a conversation started about what conventions around these tools might look like. If you have ideas on how to make it better please put in an issue -- or fork the repo, make your changes, write your tests, and send me a pull request. It'll make me feel warm inside.    

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).