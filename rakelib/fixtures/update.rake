namespace :fixtures do

  desc 'Create or update fixtures'
  task 'update' do |task|
    def document_cases
      File.open("#{Dir.pwd}/mise/logs/cases_matrix.yml", "w") do |f|
        f.write(build_cases_matrix.to_yaml)
      end
    end
  end
end
