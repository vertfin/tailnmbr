task :import => :environment do

  require 'upsert/active_record_upsert'
  whitelisted_models = [ AircraftModel, EngineModel, Aircraft ]

  objects = []
  tn = Time.now
  YAML.load_file( File.join(Rails.root, 'config', 'data_format.yaml') ).each do |_model, config|
    model = _model.constantize
    next unless whitelisted_models.include?(model)

    model.delete_all
    puts _model
    line = 0

    attributes = {}

    File.open( File.join(Rails.root, 'data', config['filename']) ).readlines.each_with_index do |row,ridx|

      if line > 0
        attributes.clear
        config['columns'].each do |col, col_config|
          _type = model.columns_hash[col].type
          at = col_config['at'] - 1
          data = case col_config['type'] || _type
          when :date
            date = row[at,8]
            year = date[0,4]
            month = date[4,2]
            day = date[6,2]
            date = "#{year}-#{month}-#{day}"

            if [year, month, day].all?(&:blank?)
              nil
            else
              date # faster to let sql figure it out
              # Date.parse(date) rescue raise "Unexpected date format for #{_model}.#{col}: '#{date}'"
            end
          when :integer
            chunk = row[at,col_config['limit'] || 2]
            raise "Unexpected characters in integer field for #{_model}.#{col}: '#{chunk}' at row #{ridx}" if /[^0-9,\ ]/.match(chunk)
            chunk.to_i
          when :string
            if limit = col_config['limit']
              row[at,limit].strip
            else
              raise "String needs a limit for #{_model}:#{col}"
            end
          when :yboolean
            chunk = row[at,1]
            raise "Unexpected format for #{_model}.#{col}: '#{chunk}'" if /[^\ Y]/.match(chunk)
            data = chunk=='Y'
          when :weight_string
            chunk = row[at,7]
            # there is at least one record with 001 instead of CLASS 1.
            raise "Unexpected format for #{_model}.#{col}: '#{chunk}'" if !/CLASS\ \d$/.match(chunk) && !/(\d+)/.match(chunk)
            data = chunk.gsub(/[^0-9]*/,'').to_i
          else
          "Unknown data type: #{_type}"
          end
          attributes[col] = data
          puts "---->#{_model}:#{col} -> #{data}" if ENV['verbose']

        end
        attributes['created_at'] = attributes['updated_at'] = Time.now
        a = attributes.has_key?('n') ? 'n' : 'code'
        selector = { a => attributes.delete(a) }
        model.upsert selector, attributes
      end
      line += 1
      if line%1000==0
        puts "#{_model}:#{line} #{(Time.now-tn).to_f.round(3).to_s}s"
      end
    end
    puts "Imported #{_model}: #{line}"
  end

end
