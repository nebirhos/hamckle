module Hamckle
  module DB
    def self.connect(path)
      connection = Sequel.connect("sqlite://#{File.expand_path(path)}")
      # Sequel requires a db connection to define models
      require "hamckle/models/activity"
      require "hamckle/models/category"
      require "hamckle/models/tag"
      require "hamckle/models/fact"
      connection
    end
  end
end
