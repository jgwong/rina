class ToDoList < ActiveRecord::Base
  attr_accessor :category, :items
  
  def initialize
    @category = nil
    @entries  = []
  end
  
  
  def self.filepath(cat)
    return TODO_CATEGORIES_PATH + cat
  end
  
  
  def self.get(cat)
    unless self.categories.include? cat
      raise "Category #{cat} doesn't exist!"
    end
    
    # Get list of Entries
    items = []
    
    lines = File.readlines(ToDoList.filepath(cat))
    
    lines.each_with_index do |l, i|
      t = ToDoItem.new
      t.id = i
      t.done = l[0].chr == "*"
      t.text = l[2..-1]
      items << t
    end
    
    t = ToDoList.new
    t.category = cat
    t.items    = items
    
    return t
  end
  
  
  def self.get_current
    @category = ToDoList.current_category
    @todo     = self.get(@category)
  end
  
  
  def undone
    return @items.select { |t| t.done == false }
  end
  
  
  def self.mark_as_checked(index)
    @todo = self.get_current
    @todo.items[index].done = true
    @todo.save
  end
  
  
  def update_item(item)
    @entries[item.id] = item
    self.save
  end
  
  
  def save
    f = File.open(ToDoList.filepath(@category), "w")
    
    @items.each do |t|
      f.puts t.to_s
    end
    f.close
    
    return true
  end
  
  
  def add_new(entry)
    t      = ToDoItem.new
    t.id   = @entries.size
    t.done = false
    t.text = entry
    
    @items << t
    self.save
  end
  
  
  def self.categories
    if @categories.nil?
      c = Dir.getwd
      Dir.chdir TODO_CATEGORIES_PATH
      list = Dir["*"].sort
      Dir.chdir c
      
      @categories = list
    else
      list = @categories
    end
    
    return list
  end
  
  
  def self.change_to_category(cid)
    f = File.open(DATA_PATH + "todo_current_category", "w")
    f.print cid
    f.close
  end
  
  
  def self.current_category
    return File.open(DATA_PATH + "todo_current_category").readlines.first.strip
  end
end
