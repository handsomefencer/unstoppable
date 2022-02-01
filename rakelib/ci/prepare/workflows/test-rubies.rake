namespace :ci do
  namespace :prepare do
    namespace :workflows do

      desc 'Prepare workflow test-rubies'
      task 'test-rubies' do |task|
        set_content(task)
        matrix = @content['jobs'][0]['test-rubies']['matrix']
        matrix['parameters']['version'] = Roro::CLI.supported_rubies
        overwrite
        notify 'version'
      end
    end
  end
end
