class Databasium::Model
  attr_reader :model_name, :attributes, :relations

  def initialize(model_name:, attributes:, relations:)
    @model_name = model_name
    @attributes = attributes
    @relations = relations
  end

  def get_binding
    binding
  end

  def longest_name_length
    attributes.map { |a| (a[:name] || a["name"]).to_s.length }.max || 0
  end

  private

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
