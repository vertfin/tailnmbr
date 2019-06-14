class EngineModel < ActiveRecord::Base

  has_many :aircrafts, :foreign_key => :eng_model_code, :primary_key => :code

end
