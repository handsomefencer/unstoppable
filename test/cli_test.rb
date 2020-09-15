require "test_helper"

describe Roro::CLI do

  Given(:cli) { Roro::CLI.new }

  describe 'options' do 
      
    Given(:cli) { Roro::CLI.commands }
    Given(:assert_includes_options) {
      class_options = Roro::CLI.class_options
      assert_includes class_options.keys, :omakase 
      assert_includes class_options.keys, :okonomi
      assert_includes class_options.keys, :fatsutofodo
      assert_equal class_options[:okonomi].aliases, ['-i', '--interactive']         
      assert_equal class_options[:fatsutofodo].aliases, ['--fast', '-f']
      assert class_options[:omakase].default
      refute class_options[:okonomi].default
    }
    
    describe 'with rollon' do 
      
      Given(:command) { 'rollon' }
    
      Then { assert_includes_options }
    end
    
    describe 'with greenfield' do 
      
      Given(:command) { 'greenfield' }
    
      Then { assert_includes_options }
    end
    
    describe 'with greenfield::rails' do 

      Given(:command) { 'greenfield_rails' }
    
      Then { assert_includes_options }
    end
    
    describe 'with rollon::rails' do 

      Given(:command) { 'rollon_rails' }
    
      Then { assert_includes_options }
    end
  end
  
  describe 'commands' do
    commands = { 
      generate_story: 'generate::story',
      generate_exposed: 'generate::exposed',
      generate_key: 'generate::key',
      generate_keys: 'generate::keys',
      generate_obfuscated: 'generate::obfuscated',
      greenfield_rails: 'greenfield::rails',
      rollon_rails: 'rollon::rails',
      rollon_rails_kubernetes: 'rollon::rails::kubernetes',
    }
    
    commands.each do |k,v| 
      describe v do 
        describe 'command must exist' do 

          Then { assert_includes Roro::CLI.commands.keys, k.to_s }  
        end

        describe 'mapping must exist' do 

          Then { assert_includes Roro::CLI.map.keys, v.to_s }  
        end
        
        describe 'mapping to key must be correct' do 

          Then { assert_equal Roro::CLI.map[v], k.to_s }  
        end
      end
    end
  end
end
