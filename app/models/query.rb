class Query < ActiveRecord::Base
  validates :command, presence: true

  has_many :widgets
  has_many :complete_queries

  before_save :update_query

  def initialize(attrs = {})
    super
    self.name ||= self.command.gsub(/^$\n/, '').gsub(/^\s*--\s*/, '').lines.first.chomp
  end

  def update_query
    return unless command_changed?
    Widget.where(query_id:  self.id).each do |w|
      # w.query.command = self.command
      w.save
    end
  end

  def self.execute(command, variables)
    conn = PG.connect(host: AppConfig.db.host, port: AppConfig.db.port, dbname: AppConfig.db.dbname, user: AppConfig.db.user, password: AppConfig.db.password)
    result = conn.exec(command % variables).to_a
    conn.finish
    result
  end

  def execute(variables)
    Query.execute(command, variables)
  end

  def get_required_variables
    command.scan(/\%{(.*?)}/).flatten
  end
end
