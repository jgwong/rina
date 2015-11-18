class ToDoItem < ActiveRecord::Base
  attr_accessor :id, :done, :text
  
  def initialize
    @id, @done, @text = nil, nil, nil
  end
  
  
  def to_s
    prefix = (@done ? "*" : "-")
    
    return "#{prefix} #{text}"
  end
end 
