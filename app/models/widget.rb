class Widget < ActiveRecord::Base

  belongs_to :query
  validates :query, presence: true
  serialize :query_result, Array
  serialize :variables, Hash
  before_save :has_changed

  def initialize(attributes = {})
    super
    self.name ||= "Untitled #{self.class.to_s}"
    self.width ||= 7
    self.height ||= 5
    self.row ||= 1
    self.column ||= 1
  end

  def has_changed
    if self.query_id_changed? || self.query.command_changed? || self.variables_changed?
      update_variable_hash
      execute_query
    end
  end

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

  def execute_query
    self.variables.each do |k,v|
      return true if v.nil?
    end
    conn = PG.connect(host: 'slavedb2.quickquid.co.uk', port: 5432, dbname: 'cnuapp_prod_uk', user: 'conduit', password: 'cro0sSb@r')
    self.query_result = conn.exec(self.query.command % self.variables).to_a
  end


  def extract_variable_names
    self.query.command.nil? ?  [] : self.query.command.scan(/\%{(.*?)}/).flatten
  end

  def update_variable_hash
    update_hash = {}
    extract_variable_names.each do |variable|
      if self.variables[variable.to_sym].nil?
        update_hash[variable.to_sym] = nil
      else
        update_hash[variable.to_sym] = self.variables[variable.to_sym]
      end
    end
    self.variables = update_hash
  end

end
