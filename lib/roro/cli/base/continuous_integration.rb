module ContinuousIntegration
  
  def copy_circleci 
    directory 'base/circleci', '.circleci', @env_hash
  end  
end
