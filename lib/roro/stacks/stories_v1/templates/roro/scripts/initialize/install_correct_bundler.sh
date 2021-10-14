
nipbin/zsh

specify_bundler () {

  GEMSET=$2
  echo Using ${1}@${2}
  rvm use ${1}@${2}
  echo Uninstalling bundler
  gem uninstall bundler --force
  echo Installing company bundler
  gem install bundler -v 1.9.9
  bundle

}

specify_bundler 2.5.5 api
specify_bundler jruby-9.1.17 api
specify_bundler 2.6.5 tokenizer-rails
specify_bundler 2.7.2 public-api
specify_bundler 3.0 client-api
