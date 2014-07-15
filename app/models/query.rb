class Query < ActiveRecord::Base
  validates :command, presence: true

  has_many :widgets

  def initialize(attributes = {})
    super
    #initialize_variables_hash
  end

 # def has_changed
  #  if self.command_changed? || self.variables_changed?
   #   self.execute
   # end
 # end
  def has_changed
    #rerun all widgtes when the command of a query changes
  end



  def self.execute(command)
    conn = PG.connect(host: 'slavedb2.quickquid.co.uk', port: 5432, dbname: 'cnuapp_prod_uk', user: 'conduit', password: 'cro0sSb@r')
    conn.exec(command).to_a
  end

  def name
    self.command.gsub(/^$\n/, '').gsub(/^\s*--\s*/, '').lines.first.chomp
  end

  private
 # def extract_variable_names
   # self.command.nil? ?  [] : self.command.scan(/\%{(.*?)}/).flatten
 # end
 # def initialize_variables_hash
   # extract_variable_names.each do |variable|
     # self.variables[variable] = nil
   # end
 # end
end
