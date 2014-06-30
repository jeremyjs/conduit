 def create_visitor
  @visitor ||= { :login => "Testy McUserton",  :password => "changeme", :password_confirmation => "changeme" }
 end

def create_new_user
  create_visitor
  delete_user
  @new_user = FactoryGirl.create(:user , @visitor) #new_use ewill have the same attributes as visitori
end

def delete_user
  @existing_user = User.where(:login => @visitor[:login]).first
  User.destroy(@existing_user.id) unless @existing_user.nil? 
end

def sign_in
  fill_in "login", :with => @visitor[:login]
  fill_in "password" , :with => @visitor[:password]
  click_button "Sign In" 
end

Given /^I exist as a user$/ do
  create_new_user
end

Given /^I am not logged in$/ do
  visit 'users/sign_in'
  expect(page).to have_no_content(@visitor[:login])
end

When /^I sign in with valid credentials$/ do
  create_visitor
  sign_in
end

Then /^I have signed in successfully$/ do
  expect(page).to have_content(@visitor[:login])
end

When /^I return to the site$/ do
  visit '/'
end

When(/^I return to the sign in page$/) do
  visit 'users/sign_in'
end

Given /^I am on the login page$/ do
  visit 'users/sign_in'
end
 

Then /^I am unable to sign up$/ do
  expect(page).to have_content("prohibited this user from being saved")
end

Given /^I do not exist as a user$/ do
  create_visitor
  delete_user
end

When /^I provide the username "(.*?)"$/ do |arg1|
  fill_in "login", :with => arg1
end

When /^I provide the password "(.*?)"$/ do |arg1|
  fill_in "password", :with => arg1
  click_button "Sign In"
end

Then /^I should not be able to log in$/ do
  expect(page).to have_selector('h2' , :text => "Sign in")
end


Given /^I am logged in$/ do
  visit 'users/sign_in'
  fill_in "login", :with => "nprabhu"
  fill_in "password" , :with => "Pepp.611" 
  click_button "Sign In" 
end

When(/^I click the sign out button$/) do
  delete 'users/sign_out'
end

Then(/^I should be logged out$/) do
  visit 'users/sign_in'
  expect(page).to have_selector('h2' , :text => "Sign in")
end



Given /^I am not signed up$/ do
  create_visitor
  delete_user
  visit 'users/sign_up'
end

When /^I provide a valid username and password$/ do
  provide_user_name(@visitor[:login])
  provide_password(@visitor[:password])
  provide_confirmation(@visitor[:password_confirmation])
  click_button "Sign Up"
end

def provide_user_name(user_name)
  fill_in "sign_up_username", :with => user_name
end

When /^I provide a username$/ do
  provide_user_name(@visitor[:login])
end

def provide_password(password)
  fill_in "sign_up_password" , :with => password
end

When /^I do not provide a password$/ do
  provide_password("")
  provide_confirmation("")
  click_button "Sign Up"
end

Then /^I am redirected to the errors page$/ do
  expect(page).to have_selector('h2' , :text => 'Request')
end

def provide_confirmation(confirm)
  fill_in "sign_up_confirm" , :with => confirm
end

When /^my passwords do not match$/ do
  provide_password(@visitor[:password])
  provide_confirmation("hello")
  click_button "Sign Up"
end

When /^I provide a password$/ do
  provide_password(@visitor[:password])
end

When /^I do not confirm my password$/ do
  provide_confirmation("")
  click_button "Sign Up"
end

When /^I provide a password of less than 8 characters$/ do
  provide_password("hello")
end

When /^I confirm the same$/ do
  provide_confirmation("hello")
  click_button "Sign Up"
end

