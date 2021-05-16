module Roro::Crypto::FileReflection

  def source_files(dir, pattern)
    Dir.glob(dir + "/**/*#{pattern}")
  end

  def gather_environments(dir, ext)
    environments = source_files(dir, ext).map do |file| 
      file.split('/').last.split('.').first 
    end  
    if environments.empty? 
      raise Roro::Crypto::EnvironmentError, "No files in the #{dir} directory matching #{ext}"
    else 
      environments.uniq
    end
  end

  def get_key(environment, dir='roro')
    env_key = environment.upcase + '_KEY'
    key_file = Dir.glob("roro/keys/#{environment}.key").first
    case 
    when ENV[env_key]
      ENV[env_key]
    when key_file
      File.read(key_file).strip
    else 
      raise Roro::Crypto::KeyError, "No #{env_key} set. Please set one as a variable or in a file."
    end
  end
end