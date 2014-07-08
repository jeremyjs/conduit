class Query < ActiveRecord::Base
  require 'pg'
  validates :command, presence: true

  has_many :query_tables
  serialize :query_result, PG::Result

  def execute
    conn = PG.connect(host: 'qassdb-38-nut.cashnetusa.com', port: 5432, dbname: 'cnuapp_prod_uk', user: 'cnuapp', password: 'cnuappukqa')
    self.query_result = conn.exec(self.command)
  end

  def self.execute(command)
    conn = PG.connect(host: 'qassdb-27-nut.cashnetusa.com', port: 5432, dbname: 'cnuapp_prod_uk', user: 'cnuapp', password: 'cnuappukqa')
    self.query_result = conn.exec(command)
  end
end
