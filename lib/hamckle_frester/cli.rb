require 'fileutils'

module HamckleFrester
  class Cli < Thor
    class_option :config, aliases: "-c", desc: "Configuration file path", default: "~/.hamckle/settings.yml"

    desc 'push', 'Sync Hamster entries with LetsFreckle.com'
    method_option :from, aliases: "-f", banner: "DATE", desc: "Process only entries from specified DATE (yyyy-mm-dd)"
    def push
      settings = HamckleFrester::Settings.new(options[:config])
      HamckleFrester::DB.connect(settings.hamster_db)
      freckle = HamckleFrester::Freckle.new(settings.freckle)

      facts = options[:from] ? Fact.after(options[:from]) : Fact.all
      say "Found #{facts.count} time entries"
      facts.each do |fact|
        if !fact.tagged_with?(settings.synced_tag) && yes?("#{fact} Push this entry?", [:bold, :cyan])
          unless project_id = settings.projects_mapping[fact.activity.category.name]
            say "Available Freckle projects:", :cyan
            projects = freckle.projects.map do |p|
              say "  * #{p.id} : #{p.name}", :cyan
              p.id.to_s
            end << "no"
            project_id = ask(set_color( "Choose one:", :bold, :cyan), limited_to: projects)
            next if project_id == 'no'
            settings.projects_mapping[fact.activity.category.name] = project_id
            settings.save!
          end

          if freckle.create(project_id, fact.start_time.to_date, "#{fact.duration}", fact.description)
            fact.add_tag(Tag.find_or_create(name: settings.synced_tag))
            say "#{fact} ADDED", :green
          else
            say "ERROR", :red
          end

        else
          say "#{fact} SKIPPED", :yellow
        end
      end
    end

    desc 'init', 'Create a hamckle configuration file'
    method_option :account_host, desc: "Freckle API host"
    method_option :username, desc: "Freckle username"
    method_option :token, desc: "Freckle access token"
    def init
      config_path = File.expand_path(options[:config])
      base_path = File.dirname(config_path)

      FileUtils.mkdir_p(base_path) if !File.directory?(base_path)
      if !File.exists?(config_path) || file_collision(config_path)
        settings = HamckleFrester::Settings.new(options[:config])
        settings.freckle.account_host = options[:account_host] || ask("Freckle API host:")
        settings.freckle.username = options[:username] || ask("Freckle username:")
        settings.freckle.token = options[:token] || ask("Freckle access token:")
        settings.save!
      end
    end
  end
end
