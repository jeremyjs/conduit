class HomeController < ApplicationController
  def dashboard
    @widgets = [{id: 1, name: "Name", data: ""}, {id: 2, name: "Name", data: ""}, {id: 3, name: "Name", data: ""}]
  end
end

