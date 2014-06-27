class HomeController < ApplicationController
  def dashboard
    @widgets = [
      {id: 1, name: "Name", col: 1, row: 1, width: 3, height: 2, data: ""},
      {id: 2, name: "Name", col: 1, row: 1, width: 3, height: 2, data: ""},
      {id: 3, name: "Name", col: 1, row: 1, width: 3, height: 2, data: ""},
      {id: 4, name: "Name", col: 1, row: 1, width: 3, height: 2, data: ""},
      {id: 5, name: "Name", col: 1, row: 1, width: 3, height: 2, data: ""},
      {id: 6, name: "Name", col: 1, row: 1, width: 3, height: 2, data: ""},
      {id: 7, name: "Name", col: 1, row: 1, width: 4, height: 2, data: ""},
      {id: 8, name: "Name", col: 1, row: 1, width: 2, height: 2, data: ""},
      {id: 9, name: "Name", col: 1, row: 1, width: 3, height: 1, data: ""},
      {id: 10, name: "Name", col: 1, row: 1, width: 2, height: 1, data: ""},
      {id: 11, name: "Name", col: 1, row: 1, width: 1, height: 1, data: ""}
    ]
  end
end

