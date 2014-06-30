class Widget < ActiveRecord::Base
  def self.descendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

  def self.all_descendants
    all = self.all
    self.descendants.each do |desc|
      all << desc.all
    end
    all
  end
end
