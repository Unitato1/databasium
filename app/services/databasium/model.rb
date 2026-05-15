class Databasium::Model
  attr_reader :model_name, :attributes, :relations
  PATHS = [ "models" ].freeze
  RELATIONS = %w[belongs_to has_many has_one has_and_belongs_to_many].freeze
  RELATIONS_REGEX = /\A(#{Regexp.union(RELATIONS).source})/

  def initialize
  end

  #  might be worth switching to reading from the dir directly in future
  # def get_all_models_from_dir(search: nil)
  #   model_files = []
  #   PATHS.each { |path| model_files += Dir.glob(Rails.root.join("app", path, "**/*.rb")) }
  #   model_names =
  #     model_files
  #       .map { |file| File.basename(file).sub(/\.rb$/, "").classify }
  #       .reject do |name|
  #         %w[ApplicationRecord Concerns].include?(name) || !name.safe_constantize&.table_exists?
  #       end
  #   model_names = model_names.select { |name| name =~ /#{search}/i } if search
  #   model_names
  # end

  def get_all_models_from_db(search: nil)
    conn = ActiveRecord::Base.connection
    tables = conn.tables - %w[ar_internal_metadata schema_migrations]
    tables = tables.map { |t| t.classify }
    tables = tables.select { |t| t =~ /#{search}/i } if search
    tables
  end

  def read_model_file(model_name)
    File.read(model_file_path(model_name))
  end

  def get_model_data_from_file(model_name)
    raw_model = constantize_model(model_name)
    model = { validations: [], columns: [], unknown: [], relations: [], columns_hash: {} }
    raw_model.columns.each do |column|
      model[:columns_hash][column.name] = { type: column.type, validations: [] }
    end

    index = 0
    inside_class = false
    File.foreach(model_file_path(model_name)) do |line|
      raw_line = line
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
        if !raw_line.include?("class")
          parsed_line = { type: :unknown, content: {} }
        else
          inside_class = true
        end
      end

      if parsed_line.present? && !(raw_line.blank? && !inside_class)
        parsed_line[:content].merge!(
          { index: index, line: parsed_line[:type] == :unknown ? raw_line : line }
        )
        model[parsed_line[:type]] << parsed_line[:content]
      end
      index += 1
    end
    model
  end

  def create_model_data(model_name:, attributes:, relations:, unknown:)
    ModelData.new(model_name: model_name, attributes: attributes, relations: relations, unknown: unknown)
  end

  private

  class ModelData
    attr_reader :model_name, :attributes, :relations, :unknown

    def initialize(model_name:, attributes:, relations:, unknown: [])
      @model_name = model_name
      @attributes = attributes
      @relations = relations
      @unknown = unknown
    end

    def get_binding
      binding
    end

    def longest_name_length
      attributes.map { |a| (a[:name] || a["name"]).to_s.length }.max || 0
    end

    def relation_name(relation)
      table_name = relation[:table_name].to_s

      case relation[:type]
      when "has_many", "has_and_belongs_to_many"
        table_name.tableize
      when "belongs_to", "has_one"
        table_name.singularize.underscore
      end
    end

    class Validation
      attr_reader :name, :value
      def initialize(name:, value:)
        @name = name
        @value = value
      end
    end

    class Attribute
      attr_reader :name, :type, :validations, :relations

      def initialize(name:, type:, validations:)
        @name = name
        @type = type
        @validations = validations
      end
    end
  end

  private

  def model_file_path(model_name)
    Rails.root.join("app/models/#{model_name.to_s.underscore.singularize}.rb")
  end

  def constantize_model(model_name)
    model_name.to_s.safe_constantize || model_name.to_s.classify.safe_constantize
  end

  def parse_column(line)
    scan =
      line
        .scan(/# (\w+)\s*:\s*(\w+)(.*)/)
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
