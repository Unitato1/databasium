class Databasium::Models
  attr_reader :model_name, :attributes, :relations
  # TODO make this configurable
  PATHS = [ "models" ].freeze
  RELATIONS = %w[belongs_to has_many has_one has_and_belongs_to_many].freeze
  RELATIONS_REGEX = /\A(#{Regexp.union(RELATIONS).source})/

  def initialize
  end

  def get_all_models_from_dir(search: nil)
    model_files = []
    PATHS.each { |path| model_files += Dir.glob(Rails.root.join("app", path, "**/*.rb")) }
    model_names =
      model_files
        .map { |file| File.basename(file).sub(/\.rb$/, "").classify }
        .reject do |name|
          %w[ApplicationRecord Concerns].include?(name) || !name.safe_constantize&.table_exists?
        end
        .map(&:downcase)
    model_names = model_names.select { |name| name =~ /#{search}/i } if search
    model_names
  end

  def get_all_models_from_db(search: nil)
    conn = ActiveRecord::Base.connection
    tables = conn.tables - %w[ar_internal_metadata schema_migrations]
    tables = tables.select { |t| t =~ /#{search}/i } if search
    tables.map { |t| t.singularize.classify }
  end

  def get_model_data(model)
    {
      columns: model.column_names,
      validations: model.validators.map { |v| { attributes: v.attributes, kind: v.kind } }
    }
  end

  def read_model_file(model_name)
    File.read(Rails.root.join("app/models/#{model_name.downcase}.rb"))
  end

  def get_model_data_from_file(model_name)
    raw_model = model_name.safe_constantize
    model = { validations: [], columns: [], unknown: [], relations: [], columns_hash: {} }
    raw_model.columns.each do |column|
      model[:columns_hash][column.name] = { type: column.type, validations: [] }
    end
    index = 0
    File.foreach(Rails.root.join("app/models/#{model_name.downcase}.rb")) do |line|
      line = line.strip.lstrip

      parsed_line = {}

      if line.start_with?("#")
        parsed_line = parse_column(line)

      elsif line.start_with?("validates :")
        parsed_line = parse_validation(line)
        scan_name = parsed_line[:content][:name]
        model_column = model[:columns_hash].fetch(scan_name, nil)
        if model_column.present?
          model_column[:validations] << {
            type: parsed_line[:content][:type],
            value: parsed_line[:content][:value]
          }
        end

      elsif line.match?(RELATIONS_REGEX)
        parsed_line = parse_relation(line)
      else
        parsed_line = { type: :unknown, content: {} }
      end

      if parsed_line.present?
        parsed_line[:content].merge!({ index: index, line: line })
        model[parsed_line[:type]] << parsed_line[:content]
        index += 1
      end
    end
    model
  end

  private

  def parse_column(line)
    scan =
      line
        .scan(/(\w+): (\w+)(.*)/)
        .map { |match| { name: match[0], type: match[1], unknown: match[2] } }
    parsed_line = { type: :columns, content: scan.first } if scan.any?
    parsed_line = { type: :unknown, content: {} } if scan.empty?
    parsed_line
  end

  def parse_validation(line)
    scan =
      line
        .scan(/validates :(\w+), (\w+): (.*)/)
        .map { |match| { name: match[0], type: match[1], value: match[2] } }
    parsed_line = { type: :validations, content: scan.first } if scan.any?
    parsed_line = { type: :unknown, content: {} } if scan.empty?
    parsed_line
  end

  def parse_relation(line)
    scan =
      line
        .scan(/(\w+) :(\w+)(.*)/)
        .map { |match| { name: match[0], type: match[1], unknown: match[2] } }
    parsed_line = { type: :unknown, content: {} } if scan.empty?
    parsed_line = { type: :relations, content: scan.first } if scan.any?
    parsed_line
  end
end
