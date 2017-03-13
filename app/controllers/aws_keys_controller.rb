class AwsKeysController < ApplicationController
  before_action :set_aws_key, only: [:show, :edit, :update, :destroy]

  # GET /aws_keys
  # GET /aws_keys.json
  def index
    @aws_keys = AwsKey.all
  end

  # GET /aws_keys/1
  # GET /aws_keys/1.json
  def show
  end

  # GET /aws_keys/new
  def new
    @aws_key = AwsKey.new
  end

  # GET /aws_keys/1/edit
  def edit
  end

  # POST /aws_keys
  # POST /aws_keys.json
  def create
    @aws_key = AwsKey.new(aws_key_params)
     @aws_key.user_id=current_user.id
    respond_to do |format|
      if @aws_key.save
        format.html { redirect_to @aws_key, notice: 'Aws key was successfully created.' }
        format.json { render :show, status: :created, location: @aws_key }
      else
        format.html { render :new }
        format.json { render json: @aws_key.errors, status: :unprocessable_entity }
      end
    end
    f=open("/root/.aws/config","a")
    f.puts("[#{@aws_key.name}]")
    f.puts("region = #{@aws_key.region}")
    f.puts("output = json")
    f.close
    f=open("/root/.aws/credentials","a")
    f.puts("[#{@aws_key.name}]")
    f.puts("aws_access_key_id = #{@aws_key.accessKey}")
    f.puts("aws_secret_access_key = #{@aws_key.SecretKey}")
    f.close
  end

  # PATCH/PUT /aws_keys/1
  # PATCH/PUT /aws_keys/1.json
  def update
    respond_to do |format|
      if @aws_key.update(aws_key_params)
        format.html { redirect_to @aws_key, notice: 'Aws key was successfully updated.' }
        format.json { render :show, status: :ok, location: @aws_key }
      else
        format.html { render :edit }
        format.json { render json: @aws_key.errors, status: :unprocessable_entity }
      end
    end
    f=open("/root/.aws/config","a")
    f.puts("[#{@aws_key.name}]")
    f.puts("region = #{@aws_key.region}")
    f.puts("output = json")
    f.close
    f=open("/root/.aws/credentials","a")
    f.puts("[#{@aws_key.name}]")
    f.puts("aws_access_key_id = #{@aws_key.accessKey}")
    f.puts("aws_secret_access_key = #{@aws_key.SecretKey}")
    f.close
  end

  # DELETE /aws_keys/1
  # DELETE /aws_keys/1.json
  def destroy
    @aws_key.destroy
    respond_to do |format|
      format.html { redirect_to aws_keys_url, notice: 'Aws key was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_aws_key
      @aws_key = AwsKey.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def aws_key_params
      params.require(:aws_key).permit(:name, :accessKey, :secretKey, :region, :default, :user_id)
    end
end
