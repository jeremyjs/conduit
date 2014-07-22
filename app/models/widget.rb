class Widget < ActiveRecord::Base

  belongs_to :query
  validates :query, presence: true
  serialize :query_result, Array
  serialize :variables, Hash
  before_save :has_changed

  def initialize(attributes = {})
    super
    self.name ||= "Untitled #{self.class.to_s}"
    self.width ||= 7
    self.height ||= 5
    self.row ||= 1
    self.column ||= 1
    self.query_id ||= 1
  end

  def has_changed
    if self.query_id_changed? || self.query.command_changed? || self.variables_changed?
      update_variable_hash
      execute_query
    end
  end

  def self.descendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

  def self.all_descendants
    all = []
    self.descendants.each do |desc|
      all << desc.all
    end
    all
  end

  def self.last_page
    if w = Widget.order('page DESC').first
      w.page
    else
      1
    end
  end

  #Remember not to call self.save since self.save is automatically called at the end of this method
  #update_hash_variable and execute_query are the functions called in the before_save callback
  def execute_query
    # Do not execute a query if any variable has a nil value
    self.variables.each do |k,v|
      if v.nil?
        return true
      end
    end

    # Search through all complete_queries with a matching SQL command
    self.query.complete_queries.each do |cq|
      # If matching SQL and matching variables
      if cq.variables == self.variables
        # If "fresh" enough (last executed less than 15 minutes)
        if fresh(cq.last_executed)
          # Use the cached result
          self.query_result = cq.query_result
          self.last_executed = cq.last_executed
          return
        end
        # If not fresh enough, update the cached copy and use it
        conn = PG.connect(host: AppConfig.db.host, port: AppConfig.db.port, dbname: AppConfig.db.dbname, user: AppConfig.db.user, password: AppConfig.db.password)
        self.query_result = conn.exec(self.query.command % self.variables).to_a
        conn.finish
        self.last_executed = Time.now
        cq.query_result = self.query_result
        cq.last_executed = self.last_executed
        cq.save
        return
      else
        # Matching query, non-matching variables
        if not(self.variables[:start_time].nil? || self.variables[:end_time].nil? ||
               cq.variables[:start_time].nil? || cq.variables[:end_time].nil?)
          if self.variables[:start_time] >= cq.variables[:start_time] and
            self.variables[:end_time] <= cq.variables[:end_time] and
            cq.variables.except(:start_time, :end_time) == self.variables.except(:start_time, :end_time)
            # If our queries match other than the date range and the new date range is a subset of the old one
            if fresh(cq.last_executed)
              puts "Sub date fresh enoughXXX"
              result = cq.query_result.select do |row|
                DateTime.parse(row['date']) >= DateTime.parse(self.variables[:start_time]) && DateTime.parse(row['date']) <= DateTime.parse(self.variables[:end_time])
              end
              self.query_result = result
              self.last_executed = cq.last_executed
              CompleteQuery.create(query_id: self.query.id, variables: self.variables, query_result: self.query_result, last_executed: self.last_executed)
              return
            else
              puts "BAD SUB DATEXXX"
            end
          end
        end
      end
    end
    # If there is no complete_query with matching SQL and variables, execute and cache the query
    conn = PG.connect(host: AppConfig.db.host, port: AppConfig.db.port, dbname: AppConfig.db.dbname, user: AppConfig.db.user, password: AppConfig.db.password)
    self.query_result = conn.exec(self.query.command % self.variables).to_a
    conn.finish
    self.last_executed = Time.now
    CompleteQuery.create(query_id: self.query.id, variables: self.variables, query_result: self.query_result, last_executed: self.last_executed)
  end


  def extract_variable_names
    self.query.nil? ?  [] : self.query.variables
  end

  def update_variable_hash
    update_hash = {}
    extract_variable_names.each do |variable|
      if self.variables[variable.to_sym].nil?
        update_hash[variable.to_sym] = nil
      else
        update_hash[variable.to_sym] = self.variables[variable.to_sym]
      end
    end
    self.variables = update_hash
  end

  private
  def fresh(time)
    TimeDifference.between(time, Time.now).in_minutes < 100
  end

end
