class Databasium::Model
  attr_reader :model_name, :attributes

  def initialize(model_name:, attributes:)
    @model_name = model_name
    @attributes = attributes
  end

  def get_binding
    binding
  end

  def longest_name_length
    attributes.map { |a| a[:name].length }.max || 0
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
    attr_reader :name, :type, :validations

    def initialize(name:, type:, validations:)
      @name = name
      @type = type
      @validations = validations
    end
  end
end
