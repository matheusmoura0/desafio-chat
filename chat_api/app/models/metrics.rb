class Metrics
  include ActiveModel::Model

  attr_reader :id

  def initialize
    @id = 'current'
  end

  def total_users
    User.count
  end

  def total_messages
    Message.count
  end

  def active_users_24h
    User.where('updated_at > ?', 24.hours.ago).count
  end
end
