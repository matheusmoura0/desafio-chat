class MessageSerializer
  include JSONAPI::Serializer
  attributes :content, :created_at, :sender_id, :receiver_id

  belongs_to :sender, record_type: :user, serializer: UserSerializer
  belongs_to :receiver, record_type: :user, serializer: UserSerializer

  attribute :file_url do |object|
    if object.file.attached?
      Rails.application.routes.url_helpers.rails_blob_url(object.file, only_path: true)
    else
      nil
    end
  end
end
