module Configuration
  
  def get_configuration_variables
    options["interactive"] ? set_interactively : set_from_defaults
    @env_hash[:deploy_tag] = "${CIRCLE_SHA1:0:7}"
    @env_hash[:server_port] = "22"
    @env_hash[:server_user] = "root"
    @env_hash
  end
  
  def set_from_defaults
    @env_hash = configuration_hash
    @env_hash.map do  |key, hash| 
      @env_hash[key] = hash.values.last 
    end
    @env_hash
  end
  
  def set_interactively
    @env_hash = configuration_hash
    @env_hash.map do |key, prompt|
      answer = ask("Please provide #{prompt.keys.first} or hit enter to accept: \[ #{prompt.values.first} \]")
      @env_hash[key] = (answer == "") ? prompt.values.first : answer
    end  
  end 
  
  private
  
  def configuration_hash
    {
      app_name: {
        "the name of your app" => `pwd`.split('/').last.strip! },
      ruby_version: {
        "the version of ruby you'd like" => `ruby -v`.scan(/\d.\d/).first },
      server_host: {
        "the ip address of your server" => "ip-address-of-your-server"},
      database_container: {
        "the name of your database container" => "database"},
      frontend_container: {
        "the name of your frontend container" => "frontend"},
      server_container: {
        "the name of your server container" => "nginx"},
      dockerhub_email: {
        "your Docker Hub email" => "your-docker-hub-email"},
      dockerhub_user: {
        "your Docker Hub username" => "your-docker-hub-user-name" },
      dockerhub_org: {
        "your Docker Hub organization name" => "your-docker-hub-org-name"},
      dockerhub_password: {
        "your Docker Hub password" => "your-docker-hub-password"},
      postgres_user: {
        "your Postgres username" => "postgres"},
      postgres_password: {
        "your Postgres password" => "your-postgres-password"} }
  end
end
