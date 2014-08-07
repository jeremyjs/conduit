class Table < Widget

  def update_as_a_child
    self.variables[:providers] = self.display_variables[:providers]
  end

  def display_providers
    display_variables[:providers]
  end

  def query_providers
    display_providers
  end

  def as_json(options)
    {
      id: id,
      hide: [
        "total_sent",
        "month",
      ],
      data: query_result
    }
  end
end
