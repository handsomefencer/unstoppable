namespace :fixtures do
  namespace :matrixes do
    namespace :create do

      desc 'Create or update cases'
      task 'cases' do |task|
        create_fixture_matrix('cases') do
          builder = Roro::Configurators::AdventureCaseBuilder.new
          builder.build_cases_matrix.to_yaml
        end
      end

      desc 'Create or update itineraries'
      task 'itineraries' do |task|
        create_fixture_matrix('itineraries') do
          builder = Roro::Configurators::AdventureCaseBuilder.new
          builder.build_cases_matrix.to_yaml
        end
      end

      private

      def create_fixture_matrix(fixture, &block)
        path = "test/fixtures/matrixes/#{fixture}.yml"
        puts "Creating #{path} ..."
        File.open("#{Dir.pwd}/#{path}", "w+") do |f|
          f.write(block.call)
        end
        puts "Created #{path}"
      end
    end
  end
end

