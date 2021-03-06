require 'mime/types'
class AgreementExecutionsController < ApplicationController
  respond_to :html, :json

  def index
    @agreement_executions = AgreementExecution.paginate :page=>params[:page], :order => 'created_at desc', :per_page => 10
  end

  def show
    @agreement_execution = AgreementExecution.find_by_id(params[:id])
    if @agreement_execution.nil?
      flash[:error] = "The signed agreement does not exist"
      redirect_to agreement_executions_path
    end
  end

  def new
    @agreement_execution = AgreementExecution.new
  end

  def create  
    @client = Dropbox::API::Client.new(:token  => 'nqwavyitn2wvab9k', :secret => '0o5isnlrhjcodi2')
    @picture = params[:agreement_execution][:picture]
    @url = params[:agreement_execution][:agreement_url]
    @form_data = params[:agreement_execution].select{|key, value| key != "picture"}
    @agreement_execution = AgreementExecution.new(@form_data)
      
      if @picture.present? && @url.present?
        flash[:error] = "Please include only one of the following:  DropBox URL or Upload"
      elsif @picture.present? && @url.blank?
        @client_file = @client.upload(dropbox_filename(@agreement_execution, @picture), @picture.read)
        @agreement_execution.update_attributes(agreement_url: @client_file.direct_url.url)
        if @agreement_execution.save
          flash[:success] = "Agreement successfully signed"
          redirect_to agreement_executions_path
        else
          flash.now[:error] = "Agreement signature not correctly saved"
          render 'new'
        end
      end 
  end

  def edit
    @agreement_execution = AgreementExecution.find_by_id(params[:id])
    if @agreement_execution.nil?
      flash[:error] = "The agreement execution was not found"
      redirect_to agreement_executions_path
    end
  end

  def update
    @agreement_execution = AgreementExecution.find_by_id(params[:id])
    agreement_execution_attr = params[:agreement_execution]
    if @agreement_execution.present? && @agreement_execution.update_attributes(agreement_execution_attr)
      flash[:success] = "Agreement execution correctly updated"
    else
      flash.now[:error] = "The agreement execution could not be updated"
    end
      respond_with(@agreement_execution, :location => agreement_executions_path)
  end

  def destroy
    @agreement_execution = AgreementExecution.find_by_id(params[:id])
    if @agreement_execution.present? && @agreement_execution.destroy && @agreement_execution.destroyed?
      flash[:success] = "The agreement execution was successfully deleted"
      redirect_to agreement_executions_path
    else
      flash[:error] = "Agreement execution could not be deleted"
      redirect_to request.referrer
    end 
  end

 private 
  def dropbox_filename(agreement_execution, picture)
     @ext= Rack::Mime::MIME_TYPES.invert[picture.content_type]
    "#{agreement_execution.date_signed.strftime('%Y_%m_%d')}_#{agreement_execution.person.first_name}_#{agreement_execution.person.last_name}#{@ext}"
  end 

end

