# Repository::Support

[![Gem Version](https://badge.fury.io/rb/repository-support.svg)](http://badge.fury.io/rb/repository-support)
[![Code Climate](https://codeclimate.com/github/jdickey/repository-support/badges/gpa.svg)](https://codeclimate.com/github/jdickey/repository-support)
[ ![Codeship Status for jdickey/repository-support](https://codeship.com/projects/224d6180-997e-0132-c9c3-165733f17d49/status?branch=master)](https://codeship.com/projects/63652)
[![security](https://hakiri.io/github/jdickey/repository-support/master.svg)](https://hakiri.io/github/jdickey/repository-support/master)

This Gem provides several support classes for
[`Repository::Base`](https://github.com/jdickey/repository-base) and its
user-created subclasses, which implement the Repository layer of a typical Data
Mapper pattern architecture.

These classes are:

* `ErrorFactory` provides a single class method, `.create` which, when supplied with an `ActiveModel::Errors`-quacking object as a parameter, produces an Array of Hashes containing JSON-compatible error information;
* `ResultBuilder` is a Command-pattern class whose `#initialize` method takes one parameter and whose `#build` method evaluates that value. If it is truthy, then `#build` returns a `StoreResult::Success` (see below) with that value as its "paylaaod". If the value is falsy, then `#build` returns a `StoreResult#Failure`, yielding the value to a block that returns the payload for the `StoreResult`.
* `StoreResult` is a simple value object with three accessors for values passed in to the `#initialize` method: namely `#entity` (some value object); `#success` (a Boolean, aliased as `#success?`); and `#errors` an Array of error records as created by `ErrorFactory.create`. It has two subclasses: `StoreResult::Success` fills in a `StoreResult` using its single parameter (the entity) and defaults for the other fields; and `StoreResult::Failure`, which does likewise initialised with an array of error hashes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'repository-support'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install repository-support

## Usage

### `StoreResult`

`StoreReult` is used as the return value from all `Repository::Base` instance
methods (actions) *except* `#all`.

If the action implemented by the method was successful, it returns a
`StoreResult` where

* the `entity` attribute is an entity matching the state of the record persisted or accessed by the action;
* the `success` attribute (or `#success?` method) is `true`; and
* the `errors` attribute is an empty Array.

If the action was unsuccessful, the repository method returns a `StoreResult`
where

* the `entity` attribute is `nil`;
* the `success` attribute (or `#success?` method) is `false`; and
* the `errors` attribute contains one error Hash for each error preventing the action from succeeding.

#### `StoreResult::Success`

This subclass of `StoreResult` is a convenience for initialising a successful
`StoreResult`. Its `#initialize` method takes a single parameter, the entity to
be used in the result, with the other fields set as described above for a
successful result.

#### `StoreResult::Failure`

This subclass of `StoreResult` is a convenience for initialising an unsuccessful
`StoreResult`. Its `#initialize` method takes a single parameter, the Array of
error hashes to be used in the result, with the other fields set as described
above for an unsuccessful result.

### `ErrorFactory`

This class has a single class method, `.create`. Given a parameter value that
quacks as an[`ActiveModel::Errors`](http://api.rubyonrails.org/classes/ActiveModel/Errors.html)
instance, it returns an Array where each item is a Hash derived from each error
reported by the parameter object, or an empty Array if there are no errors. Each
Hash in the Array has two fields:

1. `field`, which contains the attribute passed to [`ActiveModel::Errors#add`](http://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-add) *as a string*; and
1. `message`, which contains the message as passed into the same `#add` call.

So, given an `ActiveModel::Errors` object that resulted from the following code:

```ruby
  errors = ActiveModel::Errors.new self
  # ...
  errors.add :frobulator, 'does not frob'
  errors.add :frobulator, `is busted'
  errors.add :foo, 'is :foo'
  # ...
  error_data = ErrorFactory.create errors
  @logger.log error_data
```

the value of `error_data` written to the log would be (formatted for clarity)

```
[
  {field: 'frobulator', message: 'does not frob'},
  {field: 'frobulator', message: 'is busted'},
  {field: 'foo', 'is :foo'}
]
```

Note that no guarantees are made for ordering, just as seems to be the case for
`ActiveModel::Errors`.

## Contributing

1. Fork it ( https://github.com/jdickey/repository-support/fork )
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Ensure that your changes are completely covered by *passing* specs, and comply with the [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide) as enforced by [RuboCop](https://github.com/bbatsov/rubocop). To verify this, run `bundle exec rake`, noting and repairing any lapses in coverage or style violations;
1. Commit your changes (`git commit -a`). Please *do not* use a single-line commit message (`git commit -am "some message"`). A good commit message notes what was changed and why in sufficient detail that a relative newcomer to the code can understand your reasoning and your code;
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new Pull Request. Describe at some length the rationale for your new feature; your implementation strategy at a higher level than each individual commit message; anything future maintainers should be aware of; and so on. *If this is a modification to existing code, reference the open issue being addressed*.
1. Don't be discouraged if the PR generates a discussion that leads to further refinement of your PR through additional commits. These should *generally* be discussed in comments on the PR itself; discussion in the Gitter room (see below) may also be useful;
1. If you've comments, questions, or just want to talk through your ideas, don't hesitate to hang out in the `Repository::Base` [room on Gitter](https://gitter.im/jdickey/repository-base). Ask away!
