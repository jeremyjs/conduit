class HomeController < ApplicationController
  def dashboard
    @widgets = [
      {id: 1, name: "Name", col: 1, row: 1, x: 6, y: 4, data: ""},
      {id: 2, name: "Name", col: 1, row: 1, x: 4, y: 4, data: ""},
      {id: 3, name: "Name", col: 1, row: 1, x: 4, y: 3, data: ""},
      {id: 4, name: "Name", col: 1, row: 1, x: 4, y: 2, data: ""},
      {id: 5, name: "Name", col: 1, row: 1, x: 3, y: 3, data: ""},
      {id: 6, name: "Name", col: 1, row: 1, x: 3, y: 2, data: ""},
      {id: 7, name: "Name", col: 1, row: 1, x: 2, y: 2, data: ""},
      {id: 8, name: "Name", col: 1, row: 1, x: 2, y: 1, data: ""},
      {id: 9, name: "Name", col: 1, row: 1, x: 1, y: 1, data: ""}
    ]
  end
end

