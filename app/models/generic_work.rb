# Generated via
#  `rails generate curation_concerns:work GenericWork`
class GenericWork < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::CurationConcerns::BasicMetadata
  include Sufia::WorkBehavior
  include LafayetteConcerns::WorkBehavior
  include LafayetteConcerns::EastAsiaWorkBehavior
  include LafayetteConcerns::SilkRoadWorkBehavior
  include LafayetteConcerns::CasualtiesWorkBehavior
  self.human_readable_type = 'Work'
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  def thumbnail_path
    path = Rails.application.routes.url_helpers.download_path(thumbnail.id,
                                                              file: 'thumbnail')
    path.split('&').first
  end
end