class MetricsController < ApplicationController
  before_action :authorize_request 

  def index
    metrics = Metrics.new
    render json: MetricsSerializer.new(metrics).serializable_hash
  end
end