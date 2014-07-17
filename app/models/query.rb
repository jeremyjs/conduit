class Query < ActiveRecord::Base
  validates :command, presence: true

  has_many :widgets

  def has_changed
    #rerun all widgtes when the command of a query changes
  end

  def self.execute(command)
    conn = PG.connect(host: AppConfig.db.host, port: AppConfig.db.port, dbname: AppConfig.db.dbname, user: AppConfig.db.user, password: AppConfig.db.password)
    conn.exec(command).to_a
  end

  def name
    self.command.gsub(/^$\n/, '').gsub(/^\s*--\s*/, '').lines.first.chomp
  end

  def variables
    self.command.scan(/\%{(.*?)}/).flatten
  end
end
