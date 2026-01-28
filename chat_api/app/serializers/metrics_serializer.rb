class MetricsSerializer
  include JSONAPI::Serializer
  
  attributes :total_users, :total_messages, :active_users_24h
end