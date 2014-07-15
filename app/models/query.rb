class Query < ActiveRecord::Base
  validates :command, presence: true

  has_many :widgets


 # def has_changed
  #  if self.command_changed? || self.variables_changed?
   #   self.execute
   # end
  #
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

end
