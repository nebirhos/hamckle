module Hamckle
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
       hamster_db: "~/.local/share/hamster-applet/hamster.db",
       synced_tag: 'freckle',
       freckle: {},
       projects_mapping: {},
      }
    end

    def load_yaml
      YAML::load_file(@path)
    rescue Errno::ENOENT
      Settings.template
    end
  end
end
