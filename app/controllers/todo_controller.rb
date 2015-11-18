class TodoController < ApplicationController
  def index
    @cats             = ToDoList.categories
    @current_category = ToDoList.current_category
    @todo             = ToDoList.get_current
    
    if params[:new] && params[:new] != ""
      @todo.add_new(params[:new])
      redirect_to :action => "index"
    elsif params[:cat]
      ToDoList.change_to_category params[:cat]
      redirect_to :action => "index"
    end
  end
  
  
  def mark
    index = params[:id].to_i
    ToDoList.mark_as_checked index
    
    render :text => ""
  end
  
  
  def edit
    @id         = params[:id].to_i
    @todo       = ToDoList.get_current
    @item       = @todo.items[@id]
    
    if request.post?
      @item.text = params[:text]
      @todo.update_item(@item)
      redirect_to :action => "index"
    end
  end
end

