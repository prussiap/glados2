class PeopleController < ApplicationController
  def index
    @people = Person.paginate :page=>params[:page], :order => 'name desc', :per_page => 10
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(params[:person])
    if @person.save
      flash[:success] = "#{@person.name} has been added"
      redirect_to people_path
    else
      flash[:error] = "We were unable to add the person due to missing or incorrect information"
      redirect_to new_person_path, :person => @person
    end
  end

  def show
    @person = Person.find_by_id(params[:id])
    if @person.nil?
      flash[:error] = "The person you are looking for does not exist or the id was invalid"
      redirect_to people_path
    end
  end

  def edit
    @person = Person.find_by_id(params[:id])
    if @person.nil?
      flash[:error] = "The person you are looking for does not exist or the id was invalid"
      redirect_to people_path
    else
      render 'edit'
    end
  end

  def update
    @person = Person.find_by_id(params[:id])
    if @person.present? && @person.update_attributes(params[:person])
      flash[:success] = "Person updated"
      redirect_to people_path
    else
      flash[:error] = "Update unsuccessful"
      redirect_to edit_person_path(@person)
    end
  end

  def destroy
    @person = Person.find_by_id(params[:id])
    if @person.present? && @person.destroy
      flash[:success] = "Person successfully deleted"
      redirect_to people_path
    else
      flash[:error] = "Person not deleted"
      redirect_to people_path
    end
  end

  def show_equipment_possession_on_date
    @person = Person.find_by_id(params[:id])
    @date   = params[:date]
    if @person.nil?
      flash.now[:error] = "The person you are looking for does not exist or the id was invalid"
      render 'index_equipment_possession_on_date' and return
    end

    if @date.blank?
      @date = Date.today
    else
      begin
        @date = Date.strptime(params[:date], '%m/%d/%Y')
      rescue ArgumentError
        flash[:error] = "Invalid date using Today's date"
        redirect_to show_person_equipment_path(@person.id), :date => Date.today and return
      end
    end

    @possession_contracts = @person.possession_contracts.where("(expires >= ?) OR ( expires IS NULL)", @date)
    if @possession_contracts.empty?
      flash[:error] = "No contracts found or person does not exist!"
      redirect_to people_equipment_path and return
    end
  end

  def index_equipment_possession_on_date
    @date = params[:date]
    if @date.blank?
      @date = Date.today
    else
      begin
        @date = Date.strptime(params[:date],'%m/%d/%Y')
      rescue ArgumentError
        flash[:error] = "Invalid Date"
        redirect_to people_equipment_path and return
      end
    end
    @people = Person.joins(:possession_contracts).where("(expires >= ?) OR ( expires IS NULL)", @date).uniq(:person).paginate :page=>params[:page], :order => 'name desc', :per_page => 10
    if @people.empty?
      flash[:error] = "No contracts in your database"
      render 'index_equipment_possession_on_date' and return
    end
  end
end
