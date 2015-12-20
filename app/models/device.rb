class Device < ActiveRecord::Base
  self.inheritance_column = 'column_that_is_not_type'
  belongs_to :server
end
