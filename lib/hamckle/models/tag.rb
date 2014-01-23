module Hamckle
  class Tag < Sequel::Model
    many_to_many :facts, join_table: 'fact_tags'
  end
end
