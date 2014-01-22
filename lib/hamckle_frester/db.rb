module HamckleFrester
  module DB
    def self.connect(path)
      connection = Sequel.connect("sqlite://#{File.expand_path(path)}")
      # Sequel requires a db connection to define models
      require "hamckle_frester/models/activity"
      require "hamckle_frester/models/category"
      require "hamckle_frester/models/tag"
      require "hamckle_frester/models/fact"
      connection
    end
  end
end
