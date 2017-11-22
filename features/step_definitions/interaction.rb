When (/^he clicks '(.*)'$/) do |text|
  click_on text
end


When(/^the user enters his name$/) do
  user = single_user
  fill_in 'First name', with: user.first_name
  fill_in 'Last name', with: user.last_name
end


When(/^the user submits the form$/) do
  find('input[name="commit"]').click
end
