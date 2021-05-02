module Roro

  class CLI < Thor

    # desc "generate::key", "Generate a key inside roro/keys. Takes the name of
    #   an environment as an argument to private .env files from
    # encrypted .env.enc files inside the roro directory.
    # Expose encrypted files"

    # map "generate::key" => "generate_key"
    # method_option :environment, type: :hash, default: {}, desc: "Pass a list of environment variables like so: env:var", banner: "development, staging"

    desc "generate::keys", "Generate keys for each environment inside roro/keys.
      If you have .env files like 'roro/containers/app/[staging_env].env' and
      'roro/[circle_ci_env].env' it will generate '/roro/keys/[staging_env].key'
      and '/roro/keys/[circle_ci_env].key'."
    map "generate::keys" => "generate_keys"

    def generate_keys(*environments)
      Roro::Crypto.generate_keys(environments, './roro', '.env')
    end
  end
end
