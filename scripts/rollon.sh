
( rvm use 3.0.3@sandbox --create &&
  bundle &&
  gem build roro.gemspec )
( mkdir -p ../sandbox/dev &&
  cd ../sandbox/dev &&
  sudo docker-compose down #&&
  sudo rm -rf ./* &&
  rvm use 3.0.3@sandbox &&
  gem install --local ../../roro/roro-0.3.30.gem  &&
  roro --help &&
  roro rollon
#  printf "2\n4\na$var\n" | roro rollon
)