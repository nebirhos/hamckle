module Hamckle
  class Fact < Sequel::Model
    many_to_one :activity
    many_to_many :tags, join_table: 'fact_tags'

    def self.after(date)
      where("start_time > ?", date).order(:start_time)
    end

    def tagged_with?(tag)
      tags.find { |t| t.name == tag }
    end

    def duration(precision=2)
      ((end_time - start_time) / (60.0 * 60.0)).round(precision)
    end

    def description
      [activity.name, tags_string].compact.join(', ')
    end

    def tags_string
      tags.map { |t| "##{t.name}" }.join(', ') if tags.any?
    end

    def to_s
      "#{start_time} : #{activity.name}@#{activity.category.name} : #{duration}h"
    end
  end
end
