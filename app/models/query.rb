class Query < ActiveRecord::Base
  require 'pg'
  validates :command, presence: true

  has_many :query_tables
  serialize :query_result, PG::Result
  serialize :variables, Hash

  def initialize(attributes = {})
    super
    initialize_variables_hash
  end

  def execute
    conn = PG.connect(host: 'slavedb2.quickquid.co.uk', port: 5432, dbname: 'cnuapp_prod_uk', user: 'conduit', password: 'cro0sSb@r')
    self.query_result = conn.exec(self.command % self.variables)
  end

  def self.execute(command)
    conn = PG.connect(host: 'slavedb2.quickquid.co.uk', port: 5432, dbname: 'cnuapp_prod_uk', user: 'conduit', password: 'cro0sSb@r')
    self.query_result = conn.exec(command)
  end

  private
  def extract_variable_names
    if self.command.nil?
      []
    else
      self.command.scan(/\%{(.*?)}/).flatten
    end
  end
  def initialize_variables_hash
    extract_variable_names.each do |variable|
      self.variables[variable] = nil
    end
  end
end
