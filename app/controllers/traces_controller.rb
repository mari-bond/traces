class TracesController < ApplicationController
  before_filter :find_trace, only: [:show, :update, :destroy]

  # GET /traces
  # GET /traces.json
  def index
    @traces = Trace.includes(:points)

    render json: @traces
  end

  # GET /traces/1
  # GET /traces/1.json
  def show
    render json: @trace
  end

  # POST /traces
  # POST /traces.json
  def create
    @trace = Trace.new
    if @trace.save
      @trace.import_points(points_data)
      status = :created
    else
      status = :bad_request
    end

    render json: @trace, status: status
  end

  # PUT /traces/1
  # PUT /traces/1.json
  def update
    @trace.import_points(points_data)
    @trace.reload

    render json: @trace
  end

  # DELETE /traces/1
  # DELETE /traces/1.json
  def destroy
    status = @trace.destroy ? :ok : :bad_request

    render json: @trace, status: status
  end

  private
  def points_data
    params.permit!
    params[:_json]
  end

  def find_trace
    @trace = Trace.includes(:points).find(params[:id])
  end
end
