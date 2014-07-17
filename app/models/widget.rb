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
    initialize_variables_hash
  end

  def has_changed
    #query id might remain the same but the command might have changed
    if self.query_id_changed? || self.query.command_changed?
      initialize_variables_hash
      execute_query
    else
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
    return true if self.variables.empty?
    self.variables.each do |k,v|
      return true if v.nil?
    end
    conn = PG.connect(host: 'slavedb2.quickquid.co.uk', port: 5432, dbname: 'cnuapp_prod_uk', user: 'conduit', password: 'cro0sSb@r')
    self.query_result = conn.exec(self.query.command % self.variables).to_a
    puts "Last Executed: #{Time.now}"
    self.last_executed = Time.now
    self.save
  end



  private
  def extract_variable_names
    self.query.nil? ?  [] : self.query.command.scan(/\%{(.*?)}/).flatten
  end

  def initialize_variables_hash
   self.variables = {}
   extract_variable_names.each do |variable|
     self.variables[variable] = nil
   end
  end

end
