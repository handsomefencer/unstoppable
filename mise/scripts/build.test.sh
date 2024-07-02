  #!/bin/sh

docker compose down

. mise/scripts/docker.prune.sh

docker compose build --with-dependencies roro-development
# docker compose build --with-dependencies test
docker compose run --rm test bundle 
docker compose build test
docker compose run --rm test bundle exec rake test:roro
