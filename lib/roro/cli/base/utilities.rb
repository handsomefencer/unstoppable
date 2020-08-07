module Utilities
  
  def choices 
    { default: 'y', limited_to: ["y", "n"] }
  end
  
  def own_if_required
    system 'sudo chown -R $USER .'
  end   
end
