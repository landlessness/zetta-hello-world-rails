class Server < ActiveRecord::Base
  has_many :devices, dependent: :destroy
end
