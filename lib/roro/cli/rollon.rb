module Roro
  class CLI < Thor

    class << self
      private
      def shared_options!
        method_option :omakase, desc: "Use the Roro setup with some configuring. 'Omakase' translates as 'I'll leave it up to you.'", aliases: ['-d', '--default']
        method_option :fatsutofodo, desc: 'Use the Roro setup without having to think.', aliases: ['-f', '--fast']
        method_option :okonomi, desc: "Use Roro how you like. 'Okonomi' has the opposite meaning of omakase.", aliases: ['-i', '--interactive']
      end

      alias_method :orig_desc, :desc

      def desc(*args)
        orig_desc(*args)
        shared_options!
      end
    end
    rollonto = ' into Roro.'
    desc "rollon", "Roll an existing backend#{rollonto}"
    def rollon(args={})
      @config ||= Roro::Configuration.new(args, options)
      greenfield_actions
      greenfield_commands
      manifest_actions
      manifest_intentions
      congratulations
      startup_commands
    end

    desc "omakase", "Greenfield a new backend and roll it#{rollonto}"
    def greenfield(args={})
      args[:greenfield] = :greenfield

      rollon(args)
    end

    desc "omakase::rails", "Greenfield a new Rails backend and roll it#{rollonto}"

    map "omakase::rails" => "greenfield_rails"

    def greenfield_rails
      greenfield( { story: :rails } )
    end

    desc "rollon::rails", "Roll an existing backend#{rollonto}"
    map "rollon::rails" => "rollon_rails"

    def rollon_rails(args={})
      rollon( { story: :rails } )
    end

    desc "rollon::rails::kubernetes", "Adds Kubernetes for production."
    map "rollon::rails::kubernetes" => "rollon_rails_kubernetes"

    def rollon_rails_kubernetes(args={})
      story = {
        rails: [
          { database: :postgresql },
          { kubernetes: :postgresql },
          { ci_cd: :circleci}
        ]
      }
      rollon( { story: story } )
    end

    desc "omakase::rails::kubernetes", "Adds Kubernetes for production."
    map "omakase::rails::kubernetes" => "greenfield_rails_kubernetes"

    def greenfield_rails_kubernetes(args={})
      story = {
        rails: [
          { database: :postgresql },
          { kubernetes: :postgresql },
          { ci_cd: :circleci}
        ]
      }
      rollon( { story: story } )
    end

    no_commands do

      def configure_for_rollon(aroptions=nil)
        @config ||= Roro::Configuration.new(options)
      end

      def manifest_actions
        @config.structure[:actions].each {|a| eval a }
      end

      def manifest_intentions
        @config.intentions.each {|k, v| eval(k.to_s) if v.eql?('y') }
      end

      def greenfield_actions
        return unless @config.structure[:greenfield_actions]
        @config.structure[:greenfield_actions].each {|a| eval a }
      end

      def greenfield_commands
        return unless @config.structure[:greenfield_actions]
        @config.structure[:greenfield_commands].each {|a| eval a }
      end

      def congratulations(story=nil)
        ( @config.story[:rollon])
        if @config.structure[:greenfield]
          usecase = 'greenfielded a new '
        else
          usecase = 'rolled your existing '
        end
        array = ["You've successfully "]
        array << usecase
        congrats = array.join("")
        puts congrats
      end

      def startup_commands
        congratulations( @config.story[:rollon])
        cmd = @config.structure[:startup]
        commands = cmd[:commands]
        question = []
        question << "\n\n You can start your backend up with some combination of these commands:\n"
        commands.each { |c| question << "\t#{c}"}
        question << "\nOr if you'd like Roro to try and do it for you:"
        question = question.join("\n")
        if ask(question, default: 'y', limited_to: ['y', 'n']).eql?("y")
          commands.each {|a| system(a) }
          puts "\n\n#{cmd[:success]}\n\n"
        end
      end

      def yaml_from_template(file)
        File.read(find_in_source_paths(file))
      end

      def generate_config_story
        roro_story = {
          story: @config.story,
          env_vars: @config.env,
          intentions: @config.intentions
        }
        create_file ".roro_story.yml", roro_story.to_yaml
      end
    end
  end
end