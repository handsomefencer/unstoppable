module InsertGems
  
  def insert_roro_gem_into_gemfile
    insert_into_file 'Gemfile', "gem 'roro'", before: "group :development, :test do"
  end

  def insert_pg_gem_into_gemfile
    comment_lines 'Gemfile', /sqlite/
    comment_lines 'Gemfile', /mysql/
    insert_into_file 'Gemfile', "gem 'pg'", before: "group :development, :test do"
  end

  def insert_hfci_gem_into_gemfile
    insert_into_file 'Gemfile', "gem 'handsome_fencer-test'", after: "group :development, :test do"
  end  
end
