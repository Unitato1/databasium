class Databasium::Record
  def initialize(model: nil)
    @model = model
  end

  def update(record, params)
    return false unless record
    record.update(params)
  end

  def create_new(attributes:)
    return false unless @model
    @model.create(attributes)
  end

  def update_by_id(id, attributes:)
    return nil unless @model || id.blank?
    record = @model.find(id)
    return nil unless record

    record.update(attributes)
    record
  end

  def bulk_destroy(ids)
    return nil if @model.blank? || ids.blank?
    @model.where(id: ids).destroy_all
  end

  def filter_records(filter)
    records = @model&.all
    return records if filter.nil? || @model.nil?
    connectors = Array(filter[:operator_types]).map(&:to_s)
    allowed_operators = %w[eq not_eq gt lt gteq lteq matches does_not_match]
    combined_predicate = nil
    predicate_index = 0

    filter
      .except(:operator_types)
      .each do |name, value|
        next if value[:operator].blank? || value[:value].blank?

        operator = value[:operator].to_s
        next unless allowed_operators.include?(operator)

        column = @model.arel_table[name]
        predicate_value = value[:value].to_s
        predicate_value = "%#{predicate_value}%" if %w[matches does_not_match].include?(operator)
        current_predicate = column.public_send(operator, predicate_value)

        if combined_predicate.nil?
          combined_predicate = current_predicate
        else
          connector = connectors[predicate_index - 1] == "or" ? :or : :and
          combined_predicate = combined_predicate.public_send(connector, current_predicate)
        end

        predicate_index += 1
      end

    return records if combined_predicate.nil?

    records.where(combined_predicate)
  end
end
