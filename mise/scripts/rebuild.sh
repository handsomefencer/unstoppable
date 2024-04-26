2#!/bin/bash

app='reference-app'
sandbox_dir=~/sandbox/${app}
roro=~/work/handsomefencer/club/roro-stories-2204

# docker system prune
# docker system prune -af --volumes
# docker volume rm $(docker volume ls -q)

cd ${sandbox_dir} 
docker compose down
cd ${roro}

sudo rm -rf ${sandbox_dir}
mkdir -p ${sandbox_dir} 

git add .

# dc build --with-dependencies roro 
. mise/scripts/dcub.production.sh
cd ${sandbox_dir} 

docker rm artifact
docker run \
  --name artifact \
  -v $PWD:/artifact \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -u 0 \
  -it handsomefencer/roro:latest sh -c "printf '1\n1\n2\n3\n3\n1\n2\n3\na\n' | roro rollon"
  # -it handsomefencer/roro:latest sh 
  # 1 1 2 3 3 1  2 3
  # -it handsomefencer/roro:latest sh -c "printf '2\n3\n2\n3\n3\n1\n2\n3\na\n' | roro rollon"

  # -it handsomefencer/roro:latest sh -c "printf '1\n2\n3\n3\n1\n1\n3\na\n' | roro rollon"
  # -it handsomefencer/roro:latest sh -c "printf '2\n1\n2\n3\n2\n2\n1\na\n' | roro rollon"
  # -it handsomefencer/roro:latest sh -c "printf '1\n1\n1\n3\n3\n2\n1\na\n' | roro rollon"

schown  

ls -a .



dc build app 
# cd ${roro} 
# dc up -d app
# dc run --rm app bin/rails db:migrate
# dc exec app ./bin/dev
# # cd ${roro}


# mkdir -p ${sandbox_dir}
# cd ${sandbox_dir} 
# docker volume rm $(docker volume ls --filter name=$app -q)
