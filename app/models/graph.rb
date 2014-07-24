class Graph < Widget
  belongs_to :query

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
