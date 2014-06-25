class HomeController < ApplicationController
  def dashboard
    @widgets = [{name: "Name", data: ""}, {name: "Name", data: ""}, {name: "Name", data: ""}]
  end
end

