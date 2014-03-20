class AgreementsController < ApplicationController

  def index
    @agreements = Agreement.paginate :page=>params[:page], :order => 'name desc', :per_page => 10 
  end

  def show
    @agreement = Agreement.find_by_id(params[:id])
    if @agreement.nil?
      flash[:error] = "The Agreement does not exist"
      redirect_to agreements_path
    end
  end

  def new
   @agreement = Agreement.new
  end

  def create
    @agreement = Agreement.new(params[:agreement])
    if @agreement.save
      flash[:success] = "Agreement #{@agreement.name} has been added"
      redirect_to agreements_path
    else
      flash.now[:error] = "Unable to save your agreement"
      render 'new'
    end
  end

  def edit
    @agreement = Agreement.find_by_id(params[:id])
    if @agreement.nil?
      flash[:error] = "The agreement could not be found"
      redirect_to agreements_path
    else
      render 'edit'
    end
  end

  def update
    @agreement = Agreement.find_by_id(params[:id])
    if @agreement.present? && @agreement.update_attributes(params[:agreement])
      flash.now[:success] = "Your agreement was updated"
      redirect_to agreements_path
    else
      flash.now[:error] = "Unable to update agreement"
      render 'edit'
    end
  end

  def destroy
    @agreement = Agreement.find_by_id(params[:id])
    if @agreement.present? && @agreement.destroy
      flash[:success] = "Agreement successfully deleted"
      redirect_to agreements_path
    else
      flash[:error] = "Agreement not deleted"
      redirect_to request.referrer
    end
  end

end
