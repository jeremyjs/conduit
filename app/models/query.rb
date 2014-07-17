class Query < ActiveRecord::Base
  validates :command, presence: true

  has_many :widgets

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
    conn = PG.connect(host: 'slavedb2.quickquid.co.uk', port: 5432, dbname: 'cnuapp_prod_uk', user: 'conduit', password: 'cro0sSb@r')
    conn.exec(command).to_a
  end

  def name
    self.command.gsub(/^$\n/, '').gsub(/^\s*--\s*/, '').lines.first.chomp
  end



end
