class PinsController < ApplicationController
  before_action :find_pin, only: [:show, :edit, :update, :destroy, :upvote]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @pins = Pin.all.order("created_at DESC")
  end

  def show
    @pin = Pin.find(params[:id])
  end

  def new
    @pin = current_user.pins.build #we get current_user from devise
  end

  def create
    @pin = current_user.pins.build(pin_params)

    if @pin.save
      redirect_to pins_path, notice; 'Successfully created new Pin'
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @pin.update(pin_params)
      redirect_to @pin, notice: "Pin was successfully updated"
    else
      render 'edit'
    end
  end

  def destroy
    @pin.destroy #already finds pin from our before_action :find_pin
    redirect_to root_path
  end

  def upvote
    @pin.upvote_by current_user
    redirect_to :back
  end

  private
  def pin_params
    params.require(:pin).permit(:title, :description, :image)
  end

  def find_pin
    @pin = Pin.find(params[:id])
  end

end
