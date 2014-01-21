require 'fileutils'

module HamckleFrester
  class Settings
    def initialize(path)
      @path = File.expand_path(path)
      @data = Hashie::Mash.new(load_yaml)
    end

    def data
      @data.to_h
    end

    def method_missing(method, *args)
      @data.send(method, *args)
    end

    def save!
      File.open(@path, 'w') { |f| YAML.dump(data, f) }
    end

    private

    def self.template
      {
       hamster_db: "/home/istvan/Downloads/hamster-copy.db",
       mark_synced_tag: 'cantiere',
       freckle: {
                 account_host: "CHANGEME",
                 username: "CHANGEME",
                 token: "CHANGEME"
                },
       projects_mapping: {},
      }
    end

    def load_yaml
      YAML::load_file(@path)
    rescue Errno::ENOENT
      FileUtils.mkdir_p(File.dirname(@path))
      @data = Hashie::Mash.new(Settings.template)
      save!
      @data
    end
  end
end
