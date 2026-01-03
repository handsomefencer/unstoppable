---
name: Refactor RoRo repositories
overview: Remove duplicate RoRo library code from unstoppable, make it use the roro gem instead, and remove all library tests from unstoppable while keeping only story tests. Clean up unnecessary test infrastructure and update configuration files.
todos:
  - id: remove_lib_roro
    content: Delete unstoppable/lib/roro/ directory (duplicate library code)
    status: pending
  - id: update_gemfile
    content: Update unstoppable/Gemfile to use roro gem instead of building locally
    status: pending
  - id: remove_gemspec
    content: Delete unstoppable/roro.gemspec (unstoppable should not build the gem)
    status: pending
  - id: simplify_lib_roro_rb
    content: Simplify unstoppable/lib/roro.rb to just require 'roro' gem
    status: pending
    dependencies:
      - remove_lib_roro
  - id: remove_library_tests
    content: Delete unstoppable/test/roro/ directory (all library tests)
    status: pending
  - id: update_test_helper
    content: Update unstoppable/test/test_helper.rb to use gem instead of local lib
    status: pending
    dependencies:
      - remove_lib_roro
  - id: clean_rakelib
    content: Remove unstoppable/rakelib/test/roro/ directory and update test tasks
    status: pending
    dependencies:
      - remove_library_tests
  - id: update_ci_config
    content: Update unstoppable CI configuration to remove library test jobs
    status: pending
    dependencies:
      - remove_library_tests
  - id: update_dockerfiles
    content: Update unstoppable Dockerfiles to install roro gem instead of building locally
    status: pending
    dependencies:
      - remove_gemspec
  - id: update_readme
    content: Update unstoppable/README.md to document gem usage
    status: pending
  - id: remove_build_artifacts
    content: Remove unstoppable/pkg/ directory and other build artifacts
    status: pending
---

# Refactor RoRo, Unstoppable, and Story Store Repositories

## Overview

This refactoring removes duplicate code and unnecessary tests across three repositories:

- **roro/** - The extracted gem (source of truth for library code)
- **unstoppable/** - A book of Rails stories (currently contains duplicate RoRo library code)
- **story_store/** - Rails marketplace app (already uses roro gem correctly)

## Current State

1. **unstoppable** contains duplicate RoRo library code in `lib/roro/` that was extracted to the **roro** gem
2. **unstoppable** contains library tests in `test/roro/` that should only exist in the **roro** repository
3. **unstoppable** builds the roro gem from local code instead of using the published gem
4. **unstoppable** has test infrastructure (rakelib, CI config) that references library tests

## Refactoring Plan

### Phase 1: Remove Duplicate Library Code from Unstoppable

1. **Remove `unstoppable/lib/roro/` directory**

- This entire directory is duplicate code that exists in the roro gem
- Files to delete: All files in `unstoppable/lib/roro/` except potentially story-specific stacks

2. **Update `unstoppable/lib/roro.rb`**

- Replace with a simple require statement: `require 'roro'`
- Or remove entirely if not needed

3. **Update `unstoppable/Gemfile`**

- Add `gem 'roro', '~> 0.3.33'` (or appropriate version) to use the published gem
- Remove or update the `gemspec` line if it's building from local code

4. **Remove `unstoppable/roro.gemspec`**

- Unstoppable should not build the gem; it should consume it

5. **Update `unstoppable/bin/roro`**

- Should work as-is since it just requires 'roro', which will now come from the gem

### Phase 2: Remove Library Tests from Unstoppable

1. **Remove `unstoppable/test/roro/` directory**

- Delete all library tests: `test/roro/cli/`, `test/roro/common/`, `test/roro/configurators/`, `test/roro/crypto/`, `test/roro/roro_test.rb`
- These test the RoRo library and belong in the **roro** repository

2. **Keep `unstoppable/test/stacks/` directory**

- These test the actual stories (the book content) and should remain

3. **Update `unstoppable/test/test_helper.rb`**

- Remove `$LOAD_PATH.unshift File.expand_path('../lib', __dir__)` since we're using the gem
- Keep the `require 'roro'` statement

4. **Remove test helper tests for library code**

- Review `unstoppable/test/test_helper_tests/` and remove any that test library functionality
- Keep only those that test story-specific helpers

### Phase 3: Clean Up Test Infrastructure

1. **Update `unstoppable/Rakefile`**

- Remove or update `test:roro:stacks:ci` task that references `test/roro/stacks/`
- Update main test task to exclude removed directories
- Remove commented-out library test tasks

2. **Update `unstoppable/rakelib/test/`**

- Remove `rakelib/test/roro/` directory (all files: `cli.rake`, `common.rake`, `configurators.rake`, `crypto.rake`, `stacks.rake`)
- Remove `rakelib/test/roro.rake` if it only tests library code
- Update `rakelib/test/tasks.rake` to remove library test references

3. **Update `unstoppable/rakelib/ci/prepare/workflows/test.rake`**

- Remove references to `test/roro/stacks/` 
- Update test splitting logic to only handle `test/stacks/` (story tests)

4. **Update CI configuration**

- Review `.circleci/config.yml` and remove `test-roro` job if it only tests library code
- Update `test-stacks` job to reference correct test paths
- Update any test file splitting logic

### Phase 4: Update Docker/Container Configuration

1. **Update `unstoppable/mise/containers/roro/Dockerfile.*`**

- Remove `RUN gem build roro.gemspec` commands
- Update to install roro gem via bundle instead
- Review and update any other references to building the gem locally

2. **Update `unstoppable/docker-compose.builders.yml`**

- Review if roro image building is still needed or if it should use the published image

### Phase 5: Documentation and Cleanup

1. **Update `unstoppable/README.md`**

- Document that unstoppable uses the roro gem
- Update setup instructions if needed
- Clarify that unstoppable is a book of stories, not the library itself

2. **Remove unnecessary files**

- `unstoppable/pkg/` directory (built gem artifacts)
- Any other build artifacts related to gem building

3. **Verify story_store**

- Confirm story_store already correctly uses the roro gem (it does - `gem 'roro', '~> 0.3.33'`)
- No changes needed for story_store

## Files to Modify

### Unstoppable Repository

- `lib/roro.rb` - Simplify to just require gem
- `lib/roro/` - **DELETE ENTIRE DIRECTORY**
- `Gemfile` - Add roro gem dependency
- `roro.gemspec` - **DELETE FILE**
- `test/roro/` - **DELETE ENTIRE DIRECTORY**
- `test/test_helper.rb` - Update to use gem
- `test/test_helper_tests/` - Review and remove library-specific tests
- `Rakefile` - Update test tasks
- `rakelib/test/roro/` - **DELETE ENTIRE DIRECTORY**
- `rakelib/test/roro.rake` - **DELETE FILE**
- `rakelib/test/tasks.rake` - Update
- `rakelib/ci/prepare/workflows/test.rake` - Update test splitting
- `.circleci/config.yml` - Update CI jobs
- `mise/containers/roro/Dockerfile.*` - Update to use gem
- `README.md` - Update documentation
- `pkg/` - **DELETE DIRECTORY** (if contains only built gems)

### Roro Repository

- No changes needed (this is the source of truth)

### Story Store Repository  

- No changes needed (already uses gem correctly)

## Testing Strategy

After refactoring:

1. Verify unstoppable can still run its story tests (`test/stacks/`)
2. Verify unstoppable can still use roro CLI commands
3. Verify story_store continues to work (should be unaffected)
4. Run roro's own test suite to ensure library functionality is intact

## Risk Mitigation

- Keep a backup branch before making changes
- Test that `bundle install` works in unstoppable after adding gem dependency
- Verify roro gem version compatibility
- Ensure Docker builds still work after removing local gem building