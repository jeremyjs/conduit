require 'rails_helper'

RSpec.describe "pages/new", :type => :view do
  before(:each) do
    assign(:page, Page.new(
      :title => "MyString",
      :number => 1
    ))
  end

  it "renders new page form" do
    render

    assert_select "form[action=?][method=?]", pages_path, "post" do

      assert_select "input#page_title[name=?]", "page[title]"

      assert_select "input#page_number[name=?]", "page[number]"
    end
  end
end
