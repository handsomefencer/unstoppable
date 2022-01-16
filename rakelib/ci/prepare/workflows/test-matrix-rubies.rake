namespace :ci do
  namespace :prepare do
    namespace :workflows do

      desc 'Prepare workflow test-matrix-rubies'
      task 'test-matrix-rubies' do |task|
        set_content(task)
        matrix = @content['jobs'][0]['test-rubies']['matrix']
        matrix['parameters']['version'] = %w[2.5 2.6 2.7 3.0]
        overwrite
        notify('version')
      end
    end
  end
end
