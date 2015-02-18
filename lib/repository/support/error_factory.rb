
# Support classes for Repository::Base and subclasses.
module Repository
  # Support classes for Repository::Base and subclasses.
  module Support
    # Factory for our funky error-info hashes.
    class ErrorFactory
      class << self
        def create(errors)
          errors.map do |field, message|
            { field: field.to_s, message: message }
          end
        end
      end
    end # class Repository::Support::ErrorFactory
  end
end
