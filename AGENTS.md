# AGENTS.md - Agentic Coding Guidelines

This document provides guidelines and commands for agentic coding assistants working in this repository. The repository contains two main projects: `roro` (a Ruby gem for containerization) and `story_store` (a Rails application).

## Build/Lint/Test Commands

### Roro Gem
```bash
# Run all tests
cd roro && rake test

# Run CI tests
cd roro && rake test:ci

# Run specific test suites
cd roro && rake test:stacks    # Stack-related tests
cd roro && rake test:roro      # Core roro tests

# Run a single test file
cd roro && ruby -I test test/path/to/specific_test.rb

# Install dependencies
cd roro && bundle install
```

### Story Store Rails App
```bash
# Setup development environment
cd story_store && bin/setup

# Run all tests
cd story_store && bin/rails test

# Run system tests only
cd story_store && bin/rails test:system

# Run model tests only
cd story_store && bin/rails test:models

# Run controller tests only
cd story_store && bin/rails test:controllers

# Run a single test file
cd story_store && bin/rails test test/path/to/specific_test.rb

# Run a single test method
cd story_store && bin/rails test test/path/to/specific_test.rb:TestClass#test_method

# Run tests with Guard (auto-watch)
cd story_store && bundle exec guard

# Install dependencies
cd story_store && bundle install

# Database setup
cd story_store && bin/rails db:prepare
cd story_store && bin/rails db:migrate
cd story_store && bin/rails db:seed

# Start development server
cd story_store && bin/dev
```

### Linting and Code Quality
```bash
# Code smell detection (Rails app)
cd story_store && bundle exec reek

# HTML formatting (Rails app)
cd story_store && bundle exec htmlbeautifier

# Run linters on specific files
cd story_store && bundle exec reek app/models/user.rb
```

## Code Style Guidelines

### Ruby/Rails Conventions

#### File Structure and Organization
- Use `frozen_string_literal: true` at the top of all Ruby files
- Organize files in logical module/class hierarchies
- Use consistent directory structure following Rails conventions
- Keep test files in parallel directory structure under `test/`

#### Naming Conventions
- **Classes/Modules**: PascalCase (e.g., `User`, `ApplicationController`, `Roro::Configurators`)
- **Methods**: snake_case (e.g., `find_by_email`, `validate_stack`)
- **Variables**: snake_case (e.g., `user_count`, `article_title`)
- **Constants**: SCREAMING_SNAKE_CASE (e.g., `DEFAULT_TIMEOUT`, `MAX_RETRIES`)
- **Files**: snake_case with underscores (e.g., `user_model.rb`, `application_controller.rb`)

#### Code Structure
```ruby
# frozen_string_literal: true

module Roro
  module Configurators
    class Configurator
      include Utilities

      attr_reader :structure, :itinerary, :manifest, :stack, :env

      def initialize(options = {})
        # Implementation
      end

      def rollon
        validate_stack
        choose_adventure
        build_env
        write_adventure
      end

      private

      def validate_stack
        # Implementation
      end
    end
  end
end
```

#### Imports and Dependencies
- Group requires at the top of files
- Use single quotes for strings unless interpolation is needed
- Prefer explicit requires over wildcard requires
- Follow Rails autoloading conventions (don't manually require Rails files)

#### Error Handling
- Use specific exception classes when possible
- Provide meaningful error messages
- Use `rescue` blocks appropriately scoped
- Log errors with context information
- Return meaningful values or raise appropriate exceptions

#### Testing Patterns
```ruby
require 'test_helper'

describe User do
  context 'validations' do
    should validate_presence_of(:email)
    should validate_uniqueness_of(:email).case_insensitive
  end

  describe '#full_name' do
    Given(:user) { users(:default) }
    Then { assert_equal 'John Doe', user.full_name }
  end

  describe '#conversations' do
    Given(:user) { users(:one) }
    Given(:comment) { comments(:one) }

    Then { assert_includes user.conversations, comment }
  end
end
```

### Rails-Specific Guidelines

#### Models
- Use ActiveRecord associations explicitly
- Include proper validations with meaningful messages
- Use scopes for common queries
- Implement callbacks thoughtfully
- Use enums for status fields
- Include proper indexes in migrations

#### Controllers
- Keep controllers thin - delegate business logic to models/services
- Use strong parameters for mass assignment
- Handle authentication/authorization properly
- Return appropriate HTTP status codes
- Use before_action filters appropriately

#### Views and Components
- Use View Components for complex UI logic
- Keep views simple and focused on presentation
- Use helpers for reusable view logic
- Follow semantic HTML practices

#### Testing Hierarchy
- **Unit Tests**: Models, services, utilities
- **Integration Tests**: Controllers, routing
- **System Tests**: Full browser interactions with Capybara/Cuprite
- **Component Tests**: View components

### Database and Migrations
- Use descriptive migration names
- Include proper indexes
- Use foreign keys and constraints
- Follow Rails migration conventions
- Use `counter_culture` for counter caches when needed

### Security Best Practices
- Use strong parameters in controllers
- Implement proper authentication/authorization (Devise, Pundit)
- Validate user input thoroughly
- Use secure defaults for sensitive operations
- Follow Rails security guidelines

### Performance Considerations
- Use database indexes appropriately
- Implement caching where beneficial
- Use background jobs for heavy operations (Sidekiq)
- Monitor N+1 queries
- Use pagination for large datasets (Pagy)

### Git and Version Control
- Write clear, concise commit messages
- Use feature branches for development
- Follow conventional commit format when possible
- Keep commits focused and atomic
- Use meaningful branch names

### Development Workflow
1. Create feature branch from main
2. Write tests first (TDD/BDD approach)
3. Implement functionality
4. Run full test suite
5. Run linters and fix issues
6. Commit with descriptive message
7. Create pull request
8. Address code review feedback

## Common Patterns and Utilities

### File Operations
- Use Rails path helpers (`Rails.root.join`)
- Prefer Pathname for complex path operations
- Handle file encoding properly
- Use temporary directories for test files

### Configuration Management
- Use Rails credentials for sensitive data
- Environment-specific configuration in `config/environments/`
- Application-wide settings in `config/application.rb`

### Logging
- Use Rails logger with appropriate levels
- Include context in log messages
- Avoid logging sensitive information

### Internationalization (i18n)
- Use Rails I18n for user-facing text
- Store translations in `config/locales/`
- Use keys consistently across the application

## Tooling and Dependencies

### Key Gems Used
- **Rails 7.2+**: Web framework
- **Minitest**: Testing framework with extensions (given, reporters, focus)
- **Devise**: Authentication
- **Pundit**: Authorization
- **Sidekiq**: Background processing
- **ViewComponent**: UI components
- **Reek**: Code smell detection
- **Guard**: File watching for tests

### Development Tools
- **Vite Rails**: Frontend asset compilation
- **Bullet**: N+1 query detection
- **Letter Opener**: Email testing in development
- **Rails ERD**: Database diagram generation

This document should be updated as the codebase evolves and new patterns emerge.