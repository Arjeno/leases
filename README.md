# Leases

[![Build Status](https://secure.travis-ci.org/Arjeno/leases.png?branch=master)](http://travis-ci.org/Arjeno/leases)

Database multi-tenancy for Rails.

## Installation

Add this line to your Gemfile and run `bundle`.

```
gem 'leases'
```

## Usage

```ruby
# app/models/account.rb
class Account < ActiveRecord::Base
  leases
end

# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  visit_as :current_account

  protected

  def current_account
    @account
  end
end
```

That's it. Now you have a fully multi-tenant app.

## More

```ruby
# app/models/account.rb
class Account < ActiveRecord::Base

  # Customize the leaser name (used for the database name)
  leases :name => :slug
  leases :name => Proc.new { |c| "acount_#{c.id}" }

  # Callbacks
  on_enter :set_something     # => Called on :enter (part of visit)
  on_leave :clear_something   # => Called on :leave (part of visit)

  on_lease :create_something  # => Called on new lease
  on_break :delete_something  # => Called on break of lease

end

account = Account.create :name => 'John Doe' # => Calls account.lease! and sets up database 'account-1'

account.enter # => Switches to database 'account-1'
account.leave # => Switches back to regular database

account.visit do
  # You are now in account database context
  # Context is automatically cleared after visit
end

account.destroy # => Calls account.break! and deletes leaser database
```

## Shared models

By default only the leaser model is a shared model. The rest is stored in a separate database. There may be situations in which you want to have more shared models, such as a `User` model. You can configure this as such:

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  shared_by_leasers
end
```

## Under the hood

We're using `apartment` for managing and switching databases. This is a fantastic gem that you should check out: https://github.com/influitive/apartment. Apartment supports MySQL and PostgreSQL.

## Background processing

We recommend using `apartment-sidekiq` to process background jobs (https://github.com/influitive/apartment-sidekiq). This is a zero-configuration gem that enables background processing in a tenant context.

Doing it yourself is also possible, here is a simple example:

```ruby
class SomeWorker
  def some_process(account_id)
    Account.find(account_id).visit do
      # Your processing here
    end
  end
end
```

## Migrating

```
rake apartment:migrate
```

This will migrate all leaser databases.

## Other solutions

If you're looking for multi-tenancy without having multiple databases then you should check out acts_as_tenant: https://github.com/ErwinM/acts_as_tenant.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
