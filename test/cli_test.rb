require "test_helper"

describe Roro::CLI do

  Given(:cli) { Roro::CLI.new }

  describe 'options' do 
    describe 'option groups' do 
      
      Given(:cli) { Roro::CLI.commands }
      Given(:assert_includes_options) {
        assert_includes cli[command].options.keys, :omakase 
        assert_includes cli[command].options.keys, :okonomi
        assert_includes cli[command].options.keys, :fatsutofodo
        assert_equal cli[command].options[:fatsutofodo].aliases, ['-f', '--fast']         
        assert_equal cli[command].options[:okonomi].aliases, ['-i', '--interactive']         
        assert_equal cli[command].options[:omakase].aliases, ['-d', '--default']         
        # assert_equal cli[command].options[:omakase].default, :omakase
      }
      
      describe 'with rollon' do 
        
        Given(:command) { 'rollon' }
      
        Then { assert_includes_options }
      end
      
      describe 'with rollon_rails' do 
        
        Given(:command) { 'rollon_rails' }
      
        Then { assert_includes_options }
      end

      
      describe 'with greenfield' do 
        
        Given(:command) { 'greenfield' }
      
        Then { assert_includes_options }
      end
      
      describe 'with greenfield::greenfield' do 

        Given(:command) { 'greenfield_rails' }
      
        Then { assert_includes_options }
        
      end
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
