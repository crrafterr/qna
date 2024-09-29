module LinkedConcern
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

  included do
    has_many :links
  end

  def links
    object.links.map do |link|
      { id: link.id,
        name: link.name,
        url: link.url,
        created_at: link.created_at,
        updated_at: link.updated_at }
    end
  end
end
