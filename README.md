# Roro

Roro provides developers a handsome way to create, test, integrate and deploy applications Ruby on Rails applications using Guard, CircleCI, Docker, Docker Compose, and the server of their choice. It's written in Ruby, uses Thor, and admires the Rails philosophy of convention over configuration.

## Installation

```bash
$ gem install roro
```
## Usage

Once installed, Roro provides you a CLI with a number of commands:

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

## Using Roro to secure environment files 

Roro gives you a special place to put environment files for use in dockerized environments. If you want to store a variable called EXAMPLE_KEY for use in your development environment, create a file with that variable, name it "development.env," and store it in docker/env_files like so:

```bash 
$ echo "export export EXAMPLE_KEY=example_value" > docker/env_files/development.env
```

To encrypt an environment file, using the example above, first generate a key for your development environment like so:

```bash 
$ roro generate key development
```

Second, verify that the key has been generated:

```bash 
$ ls docker/keys
development.key
```

And third, use the generated key to obuscate its matching environment file:

```bash 
$ roro obfuscate development
```

You should now see an encrypted version of the environment file alongside the unencrypted one like so:

```bash 
$ ls docker/env_files
development.env  development.env.enc
```

And to expose a previously obfuscated file:

```bash 
$ mv docker/env_files/development.env
$ roro expose development
```

To verify the contents match:

```bash 
$ diff docker/env_files/development.env docker/env_files/backup.env 
```

## Install Docker and Docker Compose 

If you wish to use either the greenfield or rollon commands, you'll need Docker and Docker Compose installed.

[installing Docker](https://docs.docker.com/install/)
[installing Docker Compose](https://docs.docker.com/compose/install/)

Once you can do:

```bash
$ docker-compose -v
```

...and see output similar to:

```bash
$ docker-compose -v
docker-compose version 1.21.0, build 5920eb0
```

...you should be set.


## Greenfielding a fully dockerized Rails application:

1) Create a directory with the name of your app and change into it:

```bash
$ mkdir -p sooperdooper
$ cd sooperdooper
```

2) Run the greenfield command:

```bash
$ roro greenfield
```

2) Start it up:

```bash
$ docker-compose up
```

If you're on a linux machine and run into issues, please see the
[linux notes](roro#development) below.

4) Ask Docker to build the necessary images for our app and spool up containers using them:

```bash
$ docker-compose up --build
 ```

4) Now we need to ask Docker to execute a command on the container we asked Docker to run in the previous step. Issue the following command in a new terminal:

 ```bash
 $ docker-compose run app bin/rails db:create db:migrate
  ```

You should now be able to see the Rails welcome screen upon clicking [http://localhost:3000/](http://localhost:3000/).


## Use rollon with an existing rails app:

You can roll roro onto an existing rails app. For demonstration purposes, let's use the one we generated using the 'greenfield' instructions above. First, let's tell Docker to shut down: 

```bash
$ docker-compose down
```

Now lets roll roro onto that app:

```bash
$ roro rollon
```
And 

```bash
$ docker-compose up
 ```

If you're on a linux machine, you may need to chown the newly created files using:

```bash
$ sudo chown <username><user group> -R .
```

If that doesn't work, Docker's [documentation](https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user) should get you pointed in the right direction.

4) Ask Docker to set up your database by executing the following commands inside the app container:

 ```bash
 $ docker-compose exec app bin/rails db:setup
  ```

You should now be able to see your app running upon clicking [http://localhost:3000/](http://localhost:3000/).


## Contributing

This gem and the associated practices are just a way of deploying your application, not the canonical or best way. If you have suggestions on how to make it easier, more secure, quicker or better, please share them. If you have specific ideas, please fork the repo, make your changes, write your tests, and send me a pull request.    

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


 should get you pointed in the right direction. , you may need to prepend 'sudo' to the above command, or chown newly created files:

```bash
$ sudo chown <username><user group> -R .
```

If that doesn't work, Docker's [documentation](https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user) should get you pointed in the right direction.
