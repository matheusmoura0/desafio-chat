class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  
  has_one_attached :file
  
  validate :must_have_content_or_file

  private
  def must_have_content_or_file
    unless content.present? || file.attached?
      errors.add(:base, "Mensagem deve ter texto ou arquivo")
    end
  end
end