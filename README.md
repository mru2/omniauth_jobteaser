# Omniauth Jobteaser

Omniauth strategy for logging in with JobTeaser accounts.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth_jobteaser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth_jobteaser

## Sample setup

Register your application on `https://www.jobteaser.com/oauth/applications`

```ruby
# Gemfile
gem 'omniauth'
```

```ruby
# config/initializers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :jobteaser,
           YOUR_JOBTEASER_KEY,
           YOUR_JOBTEASER_SECRET
end
```

```ruby
# config/routes.rb
get '/auth/:provider/callback', to: 'sessions#create'
```

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :ensure_signed_in

  def ensure_signed_in
    return if session[:current_jt_user]
    redirect_to '/auth/jobteaser' and return
  end
end
```

```ruby
# app/controllers/session_controller.rb
class SessionsController < ApplicationController

  skip_before_action :ensure_signed_in

  def create
    session[:current_jt_user] = {
      token: request.env['omniauth.auth'].extra[:token], # For API calls
      info: request.env['omniauth.auth'].info # First name, last name, etc ...
    }

    redirect_to root_path
  end
end
```

With the token in session, you can request the APIs as a logged user whenever you want

```ruby
  # app/controllers/another_controller.rb
  def show
    client = Omniauth::Jobteaser::AccessToken.load(session[:current_jt_user]['token'])
    @user_info = JSON.parse(client.get('/fr/api/users/me').body)
  end
```

You also have access to the basic user info without needing any API call
```ruby
  # app/controllers/another_controller.rb
  def show
    @first_name = session[:current_jt_user]['info']['first_name']
  end
```



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/omniauth_jobteaser. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
