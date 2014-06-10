class Transfer1hsController < ApplicationController
  before_action :set_transfer_1h, only: [:show, :edit, :update, :destroy]

  # GET /transfer_1hs
  # GET /transfer_1hs.json
  def index
    @transfer_1hs = Transfer1h.all
  end

  # GET /transfer_1hs/1
  # GET /transfer_1hs/1.json
  def show
  end

  # GET /transfer_1hs/new
  def new
    @transfer_1h = Transfer1h.new
  end

  # GET /transfer_1hs/1/edit
  def edit
  end

  # POST /transfer_1hs
  # POST /transfer_1hs.json
  def create
    @transfer_1h = Transfer1h.new(transfer_1h_params)

    respond_to do |format|
      if @transfer_1h.save
        format.html { redirect_to @transfer_1h, notice: 'Transfer 1h was successfully created.' }
        format.json { render action: 'show', status: :created, location: @transfer_1h }
      else
        format.html { render action: 'new' }
        format.json { render json: @transfer_1h.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transfer_1hs/1
  # PATCH/PUT /transfer_1hs/1.json
  def update
    respond_to do |format|
      if @transfer_1h.update(transfer_1h_params)
        format.html { redirect_to @transfer_1h, notice: 'Transfer 1h was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @transfer_1h.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transfer_1hs/1
  # DELETE /transfer_1hs/1.json
  def destroy
    @transfer_1h.destroy
    respond_to do |format|
      format.html { redirect_to transfer_1hs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transfer_1h
      @transfer_1h = Transfer1h.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transfer_1h_params
      params.require(:transfer_1h).permit(:id, :sender_id, :reciever_id, :ammount, :payout, :starts_at)
    end
end
