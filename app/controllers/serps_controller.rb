class SerpsController < ApplicationController
  def index
    serps
  end

  private

  def serps
    @serps = if params.has_key?(:domain_id)
               Serp.where(domain: params[:domain_id])
             else
               Serp.all
             end
    @serps = if params.has_key?(:id)
               @serps.where(keyword: URI.decode(params[:id]))
             else
               @serps
             end
  end
end
