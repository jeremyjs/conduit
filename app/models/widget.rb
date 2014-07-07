class Widget < ActiveRecord::Base
  belongs_to :page

  def self.descendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

  def self.all_descendants
    all = []
    self.descendants.each do |desc|
      all << desc.all
    end
    all
  end

  def self.last_page
    if w = Widget.order('page DESC').first
      w.page
    else
      1
    end
  end
end
