class Databasium::RecordsController < Databasium::ApplicationController
  def index
    @tables = (ActiveRecord::Base.connection.tables - %w[ar_internal_metadata schema_migrations]).map(&:classify)
    if params[:table]
      table_name = params[:table].downcase.pluralize.to_sym
      if ActiveRecord::Base.connection.table_exists?(table_name)
        @model = params[:table].classify.constantize
        @records = @model.all
      else
        @model = nil
        @records = nil
      end
    end
    if params[:search]
      @tables = @tables.select { |table| table =~ /#{params[:search]}/i }
    end
    puts "Tables: #{@tables}"
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
