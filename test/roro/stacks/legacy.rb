def assert_stacked_postgres
  assert_stacked_compose_service_db
  assert_stacked_compose_service_db_postgres
  assert_stacked_dockerfile_postgres
  assert_stacked_mise_base_env_postgres
  assert_stacked_mise_development_env_postgres
  assert_stacked_mise_development_env_postgres
  assert_stacked_mise_production_env_postgres
  assert_file('config/database.yml', /adapter: postgresql/)
  assert_file('Gemfile', /gem ["']pg["'], ["']~> 1.1/)
  assert_file('mise/containers/app/Dockerfile', /postgresql-dev/)
end

def assert_stacked_mise_base_env_postgres
  f = 'mise/env/base.env'
  assert_file(f, /db_vendor=postgresql/)
  assert_file(f, /db_image=postgres/)
  assert_file(f, /db_image_version=14.1/)
  assert_file(f, %r{db_volume=/var/lib/postgresql/data})
  assert_file(f, /DATABASE_NAME=postgres/)
  assert_file(f, /DATABASE_HOST=db/)
  assert_file(f, /DATABASE_PASSWORD=password/)
  assert_file(f, /POSTGRES_NAME=postgres/)
  assert_file(f, /POSTGRES_PASSWORD=password/)
  assert_file(f, /POSTGRES_USERNAME=postgres/)
end

def assert_stacked_mise_development_env_postgres
  f = 'mise/env/development.env'
  assert_file(f, /db_pkg=postgresql-dev/)
end

def assert_stacked_mise_production_env_postgres
  f = 'mise/env/production.env'
  assert_file(f, /db_pkg=postgresql-client/)
end

def assert_stacked_compose_service_db_postgres
  a = ['docker-compose.yml', :services]
  assert_yaml(*a, :db, :image, 'postgres:14.1')
  assert_yaml(*a, :db, :volumes, 0, %r{db_data:/var/lib/postgresql/data})
end

def assert_stacked_dockerfile_postgres
  f = 'mise/containers/app/Dockerfile'
  assert_file(f, /postgresql-dev/)
  assert_file(f, /postgresql-client/)
end

def assert_stacked_mysql
  assert_stacked_compose_service_db
  assert_stacked_compose_service_db_mysql
  assert_stacked_compose_service_db_mysql
  assert_stacked_dockerfile_mysql
  assert_stacked_mise_base_env_mysql
  assert_stacked_mise_development_env_mysql
  assert_stacked_mise_development_env_mysql
  # assert_file('config/database.yml', /adapter: mysql/)
  # assert_file('Gemfile', /gem ["']mysql2["'], ["']~> 0.5/)
  # assert_file('mise/containers/app/Dockerfile', /mysql-dev/)
end

def assert_stacked_mise_development_env_mysql
  # f = 'mise/env/development.env'
  # assert_file(f, /DATABASE_HOST=db/)
  # assert_file(f, /DATABASE_NAME=development/)
  # assert_file(f, /MYSQL_DATABASE=development/)
  # assert_file(f, /MYSQL_HOST=db/)
  # assert_file(f, /MYSQL_USER=root/)
  # assert_file(f, /MYSQL_PASSWORD=root/)
  # assert_file(f, /MYSQL_ROOT_PASSWORD=root/)
end

def assert_stacked_dockerfile_mysql
  # f = 'mise/containers/app/Dockerfile'
  # assert_file(f, /mysql-dev/)
  # assert_file(f, /mysql-client/)
end

def assert_stacked_compose_service_db_mysql
  # a = ['docker-compose.yml', :services]
  # assert_yaml(*a, :db, :image, 'mysql:8.0.21')
  # assert_yaml(*a, :db, :volumes, 0, %r{db_data:/var/lib/mysql})
end

def assert_stacked_mise_base_env_mysql
  # f = 'mise/env/base.env'
  # assert_file(f, /db_vendor=mysql/)
  # assert_file(f, /db_image=mysql/)
  # assert_file(f, /db_image_version=8.0.21/)
  # assert_file(f, %r{db_volume=/var/lib/mysql})
end

def assert_stacked_mariadb
  assert_stacked_compose_service_db
  # assert_stacked_compose_service_db_mariadb
  # assert_stacked_mise_base_env_mariadb
  # assert_stacked_mise_development_env_mariadb
end

def assert_stacked_stacks
  assert_stacked_dot_dockerignore
  assert_stacked_dot_gitignore
  assert_stacked_mise
  assert_stacked_rails
  assert_stacked_ruby
  assert_stacked_docker_volumes
  assert_stacked_compose_anchor_app
  assert_stacked_compose_service_app
  assert_stacked_compose_service_chrome_server
  assert_stacked_compose_service_app_prod
end

def assert_stacked_dot_dockerignore
  # f = './.gitignore'
  # assert_file(f, /### Rails/)
  # assert_file(f, /### Roro/)
  # assert_file(f, /### Ruby/)
end

def assert_stacked_compose_service_vite
  assert_file('Gemfile', /gem ["']vite_rails["']/)
  # assert_file('bin/vite')
  # assert_file('config/vite.json')
  # assert_file('vite.config.ts')
  # a = ['docker-compose.yml', :services]
  # assert_yaml(*a, :vite, :ports, 0, '3036:3036')
end

def assert_stacked_dot_gitignore
  # f = './.dockerignore'
  # assert_file(f, /### Git/)
  # assert_file(f, /### Rails/)
  # assert_file(f, /### Roro/)
  # assert_file(f, /### Ruby/)
end

def assert_stacked_mise
  # f = 'mise/env/base.env'
  # assert_file(f, /app_name=unstoppable/)
  # assert_file(f, /docker_compose_version=3.9/)
end

def assert_stacked_rails
  # assert_file('mise/containers/app/env/base.env', /RAILS_MAX_THREADS/)
  # f = 'mise/containers/app/env/production.env'
  # assert_file(f, /RAILS_ENV=production/)
  # assert_file(f, /MALLOC_ARENA_MAX=2/)
  # assert_file(f, /RAILS_LOG_TO_STDOUT=true/)
  # assert_file(f, /RAILS_SERVE_STATIC_FILES=true/)
end

def assert_stacked_compose_service_chrome_server
  assert_file('Gemfile', /# gem ["']webdrivers["']/)
  assert_file('test/application_system_test_case.rb', /browser: :remote/)
  assert_file('test/support/capybara_support.rb', /Capybara.server_host = ['"]0.0.0.0['"]/)
  assert_file('test/support/capybara_support.rb', /Capybara.app_host = /)
  a = ['docker-compose.yml', :services, :'chrome-server']
  assert_yaml(*a, :image, %r{selenium/standalone-chrome:96.0})
  assert_yaml(*a, :ports, 0, '7900:7900')
end

def assert_stacked_ruby
  # f = 'mise/env/base.env'
  # assert_file(f, /ruby_version=3.2.1/)
  # assert_file(f, /bundler_version=2.4.13/)
  # assert_file('Gemfile', /ruby ["']3.2.1["']/)
  # f = 'mise/containers/app/Dockerfile'
  # assert_file(f, /FROM ruby:3.2.1-alpine/)
  # assert_file(f, /bundler:2.4.13/)
end

def assert_stacked_docker_volumes
  # f = 'docker-compose.yml'
  # assert_file(f, /\nvolumes:\n\s\sdb_data/)
  # assert_file(f, /\s\sgem_cache/)
  # assert_file(f, /\s\snode_modules/)
end

def assert_stacked_compose_anchor_app
  # f = 'docker-compose.yml'
  # a = [f, :"x-app"]
  # assert_yaml(*a, :env_file, 0, './mise/env/base.env')
  # assert_yaml(*a, :env_file, 1, %r{mise/env/development.env})
  # assert_yaml(*a, :env_file, 2, %r{containers/app/env/base.env})
  # assert_yaml(*a, :env_file, 3, %r{containers/app/env/development.env})
  # assert_yaml(*a, :image, 'unstoppable')
  # assert_yaml(*a, :user, 'root')
  # assert_yaml(*a, :volumes, 0, %r{.:/app})
end

def assert_stacked_compose_service_app
  # f = 'docker-compose.yml'
  # a = [f, :services, :app]
  # assert_yaml(*a, :ports, 0, '3000:3000')
  # assert_yaml(*a, :build, :context, '.')
  # assert_yaml(*a, :build, :dockerfile, %r{/mise/containers/app/Dockerfile})
  # assert_yaml(*a, :build, :target, 'development')
end

def assert_stacked_compose_service_app_prod
  # f = 'docker-compose.yml'
  # a = [f, :services, :'app-prod']
  # assert_yaml(*a, :build, :target, 'production')
  # assert_yaml(*a, :ports, 0, '3001:3000')
  # assert_yaml(*a, :profiles, 0, 'production')
  # assert_yaml(*a, :env_file, 0, './mise/env/base.env')
  # assert_yaml(*a, :env_file, 1, './mise/env/production.env')
  # assert_yaml(*a, :env_file, 2, './mise/containers/app/env/base.env')
  # assert_yaml(*a, :env_file, 3, './mise/containers/app/env/production.env')
  # assert_yaml(*a, :build, :dockerfile, %r{/mise/containers/app/Dockerfile})
  # assert_yaml(*a, :build, :target, 'production')
end

def assert_stacked_compose_service_db
  f = 'docker-compose.yml'
  a = [f, :services, :db, :env_file]
  assert_yaml(*a, 0, %r{/mise/env/base.env})
  assert_yaml(*a, 1, %r{/mise/env/development.env})
  assert_yaml(*a, 2, %r{/mise/containers/db/env/base.env})
  assert_yaml(*a, 3, %r{/mise/containers/db/env/development.env})
end

def assert_stacked_7_0
  # assert_file('Gemfile', /gem ["']rails["'], ["']~> 7.0.6/)
end

def assert_stacked_gemfile
  # assert_file('Gemfile', /ruby ["']3.2.1["']/)
end

def assert_stacked_sqlite
  f = 'mise/env/base.env'
  assert_file(f, /db_vendor=sqlite3/)
  assert_file(f, /db_pkg=sqlite-dev/)
  assert_file('config/database.yml', /adapter: sqlite3/)
  assert_file('Gemfile', /gem ["']sqlite3["'], ["']~> 1.4/)
  assert_file('mise/containers/app/Dockerfile', /sqlite-dev/)
  refute_content('mise/env/base.env', /db_volume/)
end

def refute_stacked_compose_service_redis
  f = 'docker-compose.yml'
  a = ['docker-compose.yml', :services, :redis]
  assert_yaml(f, :services, :app, :depends_on, 1, nil)
  refute_content(f, /redis:/)
end

def assert_stacked_compose_app_depends_on
  assert_yaml('docker-compose.yml', :services, :app, :depends_on, 0, 'db')
  assert_yaml('docker-compose.yml', :services, :app, :depends_on, 1, 'redis')
end
