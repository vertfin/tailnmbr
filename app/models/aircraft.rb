class Aircraft < ActiveRecord::Base

  attr_protected

  belongs_to :aircraft_model, :foreign_key => :ac_model_code, :primary_key => :code
  belongs_to :engine_model, :foreign_key => :eng_model_code, :primary_key => :code

end
