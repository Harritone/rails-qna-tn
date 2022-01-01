class AnswersSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :created_at, :updated_at, :user_id, :question_id

  # has_many :comments
  # has_many :links
  # has_many :files

  belongs_to :user

  # def files
  #   object.files.map { |file| rails_blob_url(file, host: :localhost) }
  # end
end
