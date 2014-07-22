class Graph < Widget
  belongs_to :query

  def as_json(options = {})
    if self.variables["kpis"] == 1
      ProvidersPresenter.new(self).to_json
    else
      KpiPresenter.new(self).to_json
    end
  end
end


