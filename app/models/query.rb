class Query < ActiveRecord::Base
  require 'pg'
  validates :command, presence: true

  has_many :query_tables

  def execute
    conn = PG.connect(host: 'qassdb-27-nut.cashnetusa.com', port: 5432, dbname: 'cnuapp_prod_uk', user: 'cnuapp', password: 'cnuappukqa')
    conn.exec(self.command) do |result|
      result.each do |row|
        puts row
      #  puts "%s\t%s" % row.values_at('id', 'email')
      end
    end
  end

  def self.execute(command)
    conn = PG.connect(host: 'qassdb-27-nut.cashnetusa.com', port: 5432, dbname: 'cnuapp_prod_uk', user: 'cnuapp', password: 'cnuappukqa')
    conn.exec(command) do |result|
      result.each do |row|
        puts row
      end
    end
  end
end
