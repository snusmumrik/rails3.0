# -*- coding: utf-8 -*-
class ContentsController < ApplicationController
  def show
    if params[:id] && File.exist?(path = "#{Rails.root.to_s}/public/contents/#{params[:id]}.html.erb")
      render :file => path, :layout => true
    else
      render :text => "Page does not exists.", :status => 404
    end
  end
end




