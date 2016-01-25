class SerpsController < ApplicationController
  def index
    serps
  end

  private

  def serps
    @serps = if domain_only?
               domain_only
             elsif domain_and_keyword?
               domain_and_keyword
             else
               Serp.all
             end
  end

  def all?
    !params.has_key?(:domain_id) &&
      !params.has_key?(:id)
  end

  def domain_only?
    !params.has_key?(:domain_id) &&
      params.has_key?(:id)
  end

  def domain_only
    Serp.where(domain: params[:id])
  end

  def domain_and_keyword?
    params.has_key?(:domain_id) &&
      params.has_key?(:id)
  end

  def domain_and_keyword
    Serp.where(domain: params[:domain_id],
               keyword: URI.decode(params[:id]))
  end
end
