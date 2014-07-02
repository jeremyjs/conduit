class HomeController < ApplicationController
  def dashboard
    @widgets = Widget.all
  end
end

