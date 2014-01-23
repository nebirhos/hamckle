module Hamckle
  class Category < Sequel::Model
    one_to_many :activities
  end
end
