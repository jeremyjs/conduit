 def create_visitor
   @visitor ||= {:email => "testy_mcuserton@example.com", :login => "Testy McUserton",  :password => "changeme", :password_confirmation => "changeme" }
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
  create_new_user
  visit 'users/sign_in'
  sign_in
end

When(/^I click the sign out button$/) do
  click_link "Log Out"
end

Then(/^I should be logged out$/) do
  expect(page).to have_no_content(@visitor[:login])
end



Given /^I am not signed up$/ do
  create_visitor
  delete_user
  visit 'users/sign_up'
end

When /^I provide a valid email$/ do
  provide_email(@visitor[:email])
end

When /^I provide a valid password$/ do
  provide_password(@visitor[:password])
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
end


def provide_confirmation(confirm)
  fill_in "sign_up_confirm" , :with => confirm
end

When /^my passwords do not match$/ do
  provide_password(@visitor[:password])
  provide_confirmation("hello")
  click_button "Sign Up"
end


When /^I do not confirm my password$/ do
  provide_confirmation("")
end

When /^I click the sign up button$/ do
  click_sign_up
end

def click_sign_up
  click_button "Sign Up"
end

When /^I provide a password of less than 8 characters$/ do
  provide_password("hello")
end

When /^I confirm the same$/ do
  provide_confirmation(@visitor[:password_confirmation])
end

When /^my password and its confirmation are less than 8 characters$/ do
  provide_password("hello")
  provide_confirmation("hello")
end

When /^I do not provide an email$/ do
  provide_email("")
end

When /^I do not provide a valid email$/ do
  provide_email("hello@com")
end


def provide_email(email)
  fill_in "sign_up_email" , :with => email
end
