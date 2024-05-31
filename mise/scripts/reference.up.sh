#!/bin/bash

cd ${sandbox_dir} 

schown .

dc build --with-dependencies dev 
dc run --rm dev bundle
dc up --build -d dev
dc exec dev bin/setup
dc exec dev bin/rails g scaffold post title content
dc exec dev bin/rails db:migrate

dc build --with-dependencies test-runner
dc build rake-test
dc run --rm rake-test bundle
dc run --rm rake-test

# dc run --rm test-runner bin/rails g scaffold post title content
# dc run --rm test-runner bin/rails db:migrate
# dc run --rm rake-test

# dc up -d --build dev


# 1
# npm install -D tailwindcss
# npx tailwindcss init

# npx tailwindcss -i ./src/input.css -o ./src/output.css --watch

#2 
# npm install --save-exact --save-dev esbuild


# "yarn", "esbuild", "app/javascript/*.*", "--bundle",
#       "--outdir=app/assets/builds", "--watch"]
# npm esbuild app/javascript/*.* --bundle --outdir=app/assets/builds
# dc up dev-js
# dc run --rm rake-test

# docker compose build --with-dependencies test-runner
# docker compose run --rm test-runner bundle

# dc run --rm test-runner bin/rails g scaffold post title content
# dc run --rm test-runner bin/rails db:migrate
# dc run --rm rake-test

# docker compose build --with-dependencies dev
# dc run --rm dev bin/setup
# dc up --build -d --remove-orphans dev

schown .
cd ${roro}
