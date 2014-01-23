module Hamckle
  class Activity < Sequel::Model
    one_to_many :facts
    many_to_one :category
  end
end
