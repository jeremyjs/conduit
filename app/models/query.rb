class Query < ActiveRecord::Base
  validates :command, presence: true

  has_many :widgets
  has_many :complete_queries

  before_save :has_changed

  def has_changed
    if self.command_changed?
      widgets = Widget.where(query_id:  self.id)
      widgets.each do |w|
        w.query.command = self.command
        w.save
      end
    end
  end

  def self.execute(command)
    conn = PG.connect(host: AppConfig.db.host, port: AppConfig.db.port, dbname: AppConfig.db.dbname, user: AppConfig.db.user, password: AppConfig.db.password)
    result =  conn.exec(command).to_a
    conn.finish
    result
  end

  def name
    self.command.gsub(/^$\n/, '').gsub(/^\s*--\s*/, '').lines.first.chomp
  end

  def variables
    self.command.scan(/\%{(.*?)}/).flatten
  end
end
