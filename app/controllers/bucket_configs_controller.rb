class BucketConfigsController < ApplicationController
  before_action :set_bucket_config, only: [:show, :edit, :update, :destroy]

  # GET /bucket_configs
  # GET /bucket_configs.json
  def index
    @bucket_configs = BucketConfig.all
  end

  # GET /bucket_configs/1
  # GET /bucket_configs/1.json
  def show
  end

  # GET /bucket_configs/new
  def new
    @bucket_config = BucketConfig.new
  end

  # GET /bucket_configs/1/edit
  def edit
  end

  # POST /bucket_configs
  # POST /bucket_configs.json
  def create
    @bucket_config = BucketConfig.new(bucket_config_params)
    @bucket_config.user_id = current_user.id

    respond_to do |format|
      if @bucket_config.save
        format.html { redirect_to @bucket_config, notice: 'Bucket config was successfully created.' }
        format.json { render :show, status: :created, location: @bucket_config }
      else
        format.html { render :new }
        format.json { render json: @bucket_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bucket_configs/1
  # PATCH/PUT /bucket_configs/1.json
  def update
    respond_to do |format|
      if @bucket_config.update(bucket_config_params)
        format.html { redirect_to @bucket_config, notice: 'Bucket config was successfully updated.' }
        format.json { render :show, status: :ok, location: @bucket_config }
      else
        format.html { render :edit }
        format.json { render json: @bucket_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bucket_configs/1
  # DELETE /bucket_configs/1.json
  def destroy
    @bucket_config.destroy
    respond_to do |format|
      format.html { redirect_to bucket_configs_url, notice: 'Bucket config was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bucket_config
      @bucket_config = BucketConfig.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bucket_config_params
      params.require(:bucket_config).permit(:bucketname, :servicename, :region, :user_id)
    end
end
