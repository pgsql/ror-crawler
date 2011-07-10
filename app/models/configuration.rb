class Configuration < ActiveRecord::Base
  has_many :results
  scope :activivated, where(:active => true)
end
