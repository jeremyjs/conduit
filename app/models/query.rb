class Query < ActiveRecord::Base
  require 'pg'
  validates :command, presence: true

  has_many :query_tables
  serialize :query_result, PG::Result

  def execute
    values = []
    conn = PG.connect(host: 'qassdb-27-nut.cashnetusa.com', port: 5432, dbname: 'cnuapp_prod_uk', user: 'cnuapp', password: 'cnuappukqa')
    res = conn.exec(self.command)
    self.query_result = res
    res
  end

  def self.execute(command)
    values = []
    conn = PG.connect(host: 'qassdb-27-nut.cashnetusa.com', port: 5432, dbname: 'cnuapp_prod_uk', user: 'cnuapp', password: 'cnuappukqa')
    res = conn.exec(command)
    res.each do |row|
      puts row
    end
    res
  end
end
