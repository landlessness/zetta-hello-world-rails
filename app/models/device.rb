class Device < ActiveRecord::Base
  self.inheritance_column = 'column_that_is_not_type'
  belongs_to :server

  state_machine initial: :ready do
    after_transition on: :change, do: :make_ready

    # TODO: provide a way to explicitly add expected arguments to events
    # for example should be able to add 'message' as a required attribute for 'change'
    # 
    event :change do
      transition ready: :changing
    end

    event :make_ready do
      transition changing: :ready
    end
  end

  def change(message, turkey, soup = 'chicken', *args)
    self.update message: message
    super
  end  
end
