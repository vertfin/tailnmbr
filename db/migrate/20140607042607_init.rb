class Init < ActiveRecord::Migration
  def up
    create_table :aircrafts do |t|
      t.string :n, limit: 5
      t.string :serial, limit: 30
      t.string :ac_model_code, limit: 7
      t.string :eng_model_code, limit: 5
      t.integer :year
      t.integer :reg_type
      t.string :reg_name, limit: 50
      t.string :street1, limit: 33
      t.string :street2, limit: 33
      t.string :city, limit: 18
      t.string :state, limit: 2
      t.string :zip, limit: 10
      t.string :region, limit: 1
      t.string :county_mail, limit: 3
      t.string :country_mail, limit: 2
      t.date :last_activity_on
      t.date :cert_issued_on
      t.integer :aw_class
      t.string :op_codes, limit: 9 # what?
      t.string :ac_type, limit: 1
      t.integer :eng_type
      t.string :status_code, limit: 2
      t.string :mode_s, limit: 8
      t.boolean :fractional
      t.date :aw_date
      t.string :other_name_1, limit: 50
      t.string :other_name_2, limit: 50
      t.string :other_name_3, limit: 50
      t.string :other_name_4, limit: 50
      t.string :other_name_5, limit: 50
      t.date :expires_on
      t.string :uid, limit: 8
      t.string :kit_mfr_name, limit: 30
      t.string :kit_model, limit: 20
      t.string :mode_s_hex, limit: 10
      #
      t.timestamps
    end
    add_index :aircrafts, :n

    create_table :aircraft_models do |t|
      t.string :code, limit: 7
      #t.string :mfr_code, limit: 3
      #t.string :model_code, limit: 2
      #t.string :series_code, limit: 2
      t.string :mfr_name, limit: 30
      t.string :model_name, limit: 20
      t.string :ac_type, limit: 1
      t.integer :eng_type
      t.integer :ac_cat_code
      t.integer :builder_cert_code
      t.integer :num_engines
      t.integer :num_seats
      t.integer :weight
      t.integer :cruise_speed
      t.timestamps
    end
    add_index :aircraft_models, :code

    create_table :engine_models do |t|
      t.string :code, limit: 5
      # t.string :mfr_code, limit: 3
      # t.string :model_code, limit: 2
      t.string :mfr_name, limit: 10
      t.string :model_name, limit: 13
      t.integer :eng_type
      t.integer :hp
      t.integer :lbs_thrust
      t.timestamps
    end

  end

  def down
    drop_table :aircrafts
    drop_table :aircraft_models
    drop_table :engine_models

  end

end
