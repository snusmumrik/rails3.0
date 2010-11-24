# -*- coding: utf-8 -*-
class Image < ActiveRecord::Base
  belongs_to :parent, :polymorphic => true

  # /:attachment/:class以下のフォルダ数が膨大になるとパフォーマンス低下を招くので要対応
  has_attached_file :image,
    :default_url => "/:attachment/:class/missing/:style/missing.png",
    :styles => {
      :medium => "300x300>",
      :thumb => "100x100#"
    },
    :url => "/:attachment/:class/:id/:style/:basename.:extension",
    :path => ":rails_root/public/:attachment/:class/:id/:style/:basename.:extension"

  delegate :path, :url, :to => :image

  def destroy
    base_dir = self.path.sub(%r!/[^/]+/[^/]+$!, "")
    super
    FileUtils.rm_rf(base_dir)
  end
end
