class Graph < Widget

  def update_as_a_child
    self.variables[:providers] = query_providers
  end

  def display_providers
    display_variables[:providers] || []
  end

  def query_providers
    Provider.all_providers(brand_id)
  end

  def kpis
    display_variables[:kpis] || []
  end

  def kpi
    kpis.length == 1 && kpis.first
  end

  def as_json(options = {})
    if kpi
      ProviderPresenter.new(self).to_json
    else
      KpiPresenter.new(self).to_json
    end
  end
end
