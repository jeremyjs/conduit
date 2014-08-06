class Graph < Widget
  belongs_to :query

  def display_providers
    display_variables[:providers] || []
  end

  def query_providers
    Provider.all_providers(brand)
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
