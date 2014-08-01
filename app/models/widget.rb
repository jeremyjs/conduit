class Widget < ActiveRecord::Base

  belongs_to :user
  belongs_to :query
  validates :query, presence: true
  serialize :query_result, Array
  serialize :variables, Hash
  before_save :update_widget
  serialize :display_variables, Hash

  def initialize(attributes = {})
    super
    self.width ||= 7
    self.height ||= 5
    self.row ||= 1
    self.column ||= 1
    self.query_id ||= 4
    self.page ||= 2
    self.variables ||= {brand_id: "2", start_time: "2014-05-28 00:00:00", end_time: "2014-05-30 23:59:59", providers: "'t3uk'"}
    self.display_variables ||= {kpis: [ "total_imported"]}
    self.name ||= "Pitch main performance results for #{self.variables[:providers]}"
  end

  def has_changed?
    query_id_changed? || query.command_changed? || variables_changed?
  end

  def update_widget
    if has_changed?
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

  def self.last_page(user)
    w = user.widgets.order('page DESC').first
    if w && w.page
      w.page
    else
      1
    end
  end

  def providers
    variables[:providers] && s_to_a(variables[:providers]) || []
  end

  def complete_queries
    query.complete_queries
  end

  def extract_variable_names
    query ? query.variables : []
  end

  def update_variable_hash
    update_hash = {}
    extract_variable_names.each do |variable|
      if variables[variable.to_sym].nil?
        update_hash[variable.to_sym] = nil
      else
        update_hash[variable.to_sym] = variables[variable.to_sym]
      end
    end
    self.variables = update_hash
  end

  # Remember not to call self.save since self.save is automatically called at the end of this method
  # update_hash_variable and execute_query are the functions called in the before_save callback
  def execute_query
    variables.each { |_, v| return true if v.nil? }

    complete_queries.each do |complete_query|
      if complete_query.variables == variables && complete_query.fresh?
        use_cached_result(complete_query)
        return
      elsif complete_query.variables == variables
        update_and_use_cached_query(complete_query)
        return
      elsif times_are_not_nil?(complete_query) &&
      time_is_a_subset_of_complete_query_time?(complete_query) &&
      providers_are_a_subset_of_complete_query_providers?(complete_query) &&
      variables_other_than_time_match?(complete_query) &&
      complete_query.fresh?
        use_cached_result_with_subset(complete_query)
        return
      end
    end

    # If there is no complete_query with matching SQL and variables, execute and cache the query
    execute_and_cache_new_query
  end

  def use_cached_result(complete_query)
    self.query_result = complete_query.query_result
    self.last_executed = complete_query.last_executed
  end

  def use_cached_result_with_subset(complete_query)
    self.query_result = complete_query.query_result.select do |row|
      DateTime.parse(row['date']) >= DateTime.parse(variables[:start_time]) &&
      DateTime.parse(row['date']) <= DateTime.parse(variables[:end_time]) &&
      s_to_a(variables[:providers]).include?(row['provider'])
    end
    self.last_executed = complete_query.last_executed
    CompleteQuery.create(query_id: query.id, variables: variables, query_result: query_result, last_executed: last_executed)
  end

  def update_and_use_cached_query(complete_query)
    execute_new_query
    CompleteQuery.update(complete_query.id, query_result: query_result, last_executed: last_executed)
  end

  def execute_and_cache_new_query
    execute_new_query
    CompleteQuery.create(query_id: query.id, variables: variables, query_result: query_result, last_executed: last_executed)
  end

  def execute_new_query
    conn = PG.connect(host: AppConfig.db.host, port: AppConfig.db.port, dbname: AppConfig.db.dbname, user: AppConfig.db.user, password: AppConfig.db.password)
    self.query_result = conn.exec(query.command % variables).to_a
    conn.finish
    self.last_executed = Time.now
  end

  def times_are_not_nil?(complete_query)
    variables[:start_time] && variables[:end_time] &&
    complete_query.variables[:start_time] && complete_query.variables[:end_time]
  end

  def time_is_a_subset_of_complete_query_time?(complete_query)
    variables[:start_time] >= complete_query.variables[:start_time] &&
    variables[:end_time] <= complete_query.variables[:end_time]
  end

  def providers_are_a_subset_of_complete_query_providers?(complete_query)
    subset? s_to_a(variables[:providers]), s_to_a(complete_query.variables[:providers])
  end

  def variables_other_than_time_match?(complete_query)
    complete_query.variables.except(:start_time, :end_time, :providers) == variables.except(:start_time, :end_time, :providers)
  end

  private
  def subset?(smaller, larger)
    (smaller-larger).empty?
  end

  def s_to_a(s)
    s.gsub("'", "").split(", ")
  end

end
