Given /^all relevant routes$/ do
  # Please state a reason for exclusion
  excluded_routes = [
    # Landing page
    '/',
    # Assets path
    '/assets',
    # Dashboard does not need a back button
    '/users/1/dashboard',
    # New and edit pages have 'Cancel' buttons
    /^\/.+\/new$/,
    /^\/[^\/]+\/\d+\/edit$/,
    # Other pages with 'Cancel' buttons
    '/my/users/sign_up',
    '/my/users/sign_in',
    '/my/users/password/edit',
    '/my/users/cancel',
    '/matches/1/add_game_result',
    '/matches/1/edit_results',
    # List of all users, no return path
    '/users'
  ]

  @relevant_paths = []
  Rails.application.routes.routes.each do |route|
    if route.verb.match? 'GET'
      path = route.path.spec.to_s
      path['(.:format)'] = '' if path['(.:format)']
      path[':id'] = '1' if path[':id']
      @relevant_paths << path
    end
  end
  #Attempt fill match
  @relevant_paths.reject! { |path| excluded_routes.any? { |excluded| path[excluded] == path } }
end

Then(/^there should be a back button on all relevant pages$/) do
  @relevant_paths.each do |path|
    begin
      visit path
    rescue Exception
      next
    end
    expect(page).to have_link(I18n.t ('helpers.links.back'))
  end
end
