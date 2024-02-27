namespace :ci do
  namespace :prepare do
    namespace :workflows do

      desc 'Prepare workflow test-rubies'
      task 'rubies' do |task|
        set_content(task)
        matrix = @content['jobs'][0]['test-rubies']['matrix']
        matrix['parameters']['version'] = %w[3.1 3.2 3.3]
        matrix['parameters']['folder'] = %w[cli common configurators crypto]
        overwrite
        notify 'version'
      end
    end
  end
end
