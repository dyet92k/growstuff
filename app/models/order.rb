class Order < ActiveRecord::Base
  attr_accessible :member_id
  belongs_to :member

  has_and_belongs_to_many :products

  default_scope order('created_at DESC')
end
