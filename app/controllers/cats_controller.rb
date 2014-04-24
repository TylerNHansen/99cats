class CatsController < ApplicationController
  def index
    @cats = Cat.all
    render :index
  end

  def new
    render :new
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def create
    @cat = Cat.new(cat_params)
    if @cat.save
      redirect_to cat_url(@cat)
    else
      render plain: @cat.errors.full_messages
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      render plain: @cat.errors.full_messages
    end
  end

  private

  def cat_params
    params.require('cat').permit(:age, :name, :birth_date, :sex, :color)
  end
end
