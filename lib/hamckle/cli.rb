require 'fileutils'

module Hamckle
  class Cli < Thor
    class_option :config, aliases: "-c", desc: "Configuration file path", default: "~/.hamckle/settings.yml"

    desc 'push', 'Push Hamster entries to LetsFreckle.com'
    method_option :yes, aliases: "-y", type: :boolean, desc: "Don't ask for confirmation and skip unknown projects"
    method_option :from, aliases: "-f", banner: "DATE", desc: "Process only entries from specified DATE (yyyy-mm-dd)"
    def push
      settings = Hamckle::Settings.new(options[:config])
      Hamckle::DB.connect(settings.hamster_db)
      freckle = Hamckle::Freckle.new(settings.freckle)

      facts = options[:from] ? Fact.after(options[:from]) : Fact.all
      say "Found #{facts.count} time entries"
      facts.each do |fact|
        project_id = settings.projects_mapping[fact.activity.category.name]

        if !fact.tagged_with?(settings.synced_tag) &&
            (project_id || !options[:yes]) &&
            (options[:yes] || yes?("#{fact} Push this entry?", [:bold, :cyan]))

          unless project_id
            say "Available Freckle projects:", :cyan
            projects = freckle.projects.map do |p|
              say "  * #{p.id} : #{p.name}", :cyan
              p.id.to_s
            end << "no"
            project_id = ask(set_color("Choose one:", :bold, :cyan), limited_to: projects)
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
        settings = Hamckle::Settings.new(options[:config])
        [:account_host, :username, :token].each do |s|
          settings.freckle[s] = options[s] || ask("Freckle #{s.to_s.gsub('_', ' ').titleize}:")
        end
        settings.save!
        say "Hamckle configuration file created! Happy logging :)", :green
      else
        say "Hamckle configuration file init skipped", :yellow
      end
    end
  end
end
