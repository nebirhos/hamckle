module Hamckle
  class Freckle
    def initialize(options)
      LetsFreckle.configure do
        account_host options[:account_host]
        username options[:username]
        token options[:token]
      end
    end

    def projects
      @projects ||= LetsFreckle::Project.all.sort_by(&:name)
    end

    def create(project_id, date, duration, description)
      response = LetsFreckle::Entry.create(
                                           project_id: project_id,
                                           date: date,
                                           minutes: duration,
                                           description: description,
                                           allow_hashtags: true
                                          )
      (response.status == 201)
    end
  end
end
