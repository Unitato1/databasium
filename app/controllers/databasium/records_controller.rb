class Databasium::RecordsController < Databasium::ApplicationController
  def index
    @tables = ActiveRecord::Base.connection.tables - %w[ar_internal_metadata schema_migrations]
    if params[:table]
      @model = params[:table].classify.constantize
      @records = @model.all
    end
    if params[:search]
      @tables = @tables.select { |table| table =~ /#{params[:search]}/i }
    end
    puts "Tables: #{@tables}"
    respond_to do |format|
      format.html # normal full page
      format.turbo_stream # for Hotwire updates
    end
  end
end
