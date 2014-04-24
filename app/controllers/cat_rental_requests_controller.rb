class CatRentalRequestsController < ApplicationController
  before_action :verify_cat_ownership, only: [:approve, :deny]

  def new
    @cat_rental_request = CatRentalRequest.new
    @cat_rental_request.cat_id = params[:id]
    render :new
  end

  def create
    @request = CatRentalRequest.new(cat_rental_request_params)
    @request.user_id = current_user.id
    if @request.save
      redirect_to cat_url(@request.cat_id)
    else
      render @request.errors.full_messages
    end
  end

  def index
    @requests = CatRentalRequest.all
    render :index
  end

  def approve
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.approve!
    redirect_to :back
  end

  def deny
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.deny!
    redirect_to :back
  end

  private

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:start_date, :end_date, :cat_id)
  end


  def verify_cat_ownership
    @cat_rental_request = CatRentalRequest.find(params[:id])
    unless @cat_rental_request.cat.user_id == current_user.id
      flash[:errors] = ["You don't own that cat!"]
      redirect_to root_url
    end
  end
end
