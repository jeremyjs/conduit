class TopNPresenter < ProviderPresenter

  def user_defined_headers
    @user_defined_headers ||= set_headers
  end

  def set_headers
    providers_hash = Hash.new { 0 }
    query_result.each do |row|
      providers_hash[row[provider]] += row[kpi]
    end
    providers_hash.to_a.sort_by { |pair| pair[1] }.first(5)
  end
end
