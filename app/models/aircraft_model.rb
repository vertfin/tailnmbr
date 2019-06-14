class AircraftModel < ActiveRecord::Base

  has_many :aircrafts, :foreign_key => :ac_model_code, :primary_key => :code

end
