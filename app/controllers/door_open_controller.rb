class DoorOpenController < ApplicationController 

  def check 
      @fob_param= params[:fob]
      @door_param= params[:door]
      @message = [] 

    if @fob_param.nil?
      @message<< "Missing fob parameter"
    else
      @fob = Fob.find_by_key(@fob_param)
      if @fob.nil?
        @message << "Fob not found"
      end
    end  

    if @door_param.nil?
      @message<<"Missing door parameter"
    else
      @door = Door.find_by_name(@door_param)
      if @door.nil?
        @message<<"Door not found"
      end  
    end

    if @door.present? && @fob.present?
      if @door.permitting_entry_to?(@fob)
        render_json(true, "User Authenticated")
      else
        render_json(false, "User not permitted entry")
      end
    else 
      render_json(false, @message.join(", "))
    end
  end 

  def render_json(access, reason)
     respond_to do |format|
            format.json {render json: {can_open: access, message: reason}}
      end 
  end
end 



