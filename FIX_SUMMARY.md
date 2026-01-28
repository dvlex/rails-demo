# Fix for CI System Test Failures in GitHub Actions

## Problem
The system tests in Pull Request #26 ("Feature/oauth devise basics") are failing in GitHub Actions with the following error:

```
Selenium::WebDriver::Error::SessionNotCreatedError: session not created
from unknown error: no chrome binary at /usr/bin/chromium
```

The tests work correctly locally using Chromium, but fail in the CI environment.

## Root Cause
The test configuration in PR #26 attempts to use `/usr/bin/chromium` as the Chrome binary. While this path exists in both local development and GitHub Actions, in the CI environment this is a symlink that Selenium WebDriver cannot use properly. 

The GitHub Actions workflow (`.github/workflows/ci.yml`) installs `google-chrome-stable`, which provides a more reliable Chrome binary at `/usr/bin/google-chrome`.

## Solution
The fix involves updating `test/application_system_test_case.rb` to:

1. Detect the CI environment using the `ENV["CI"]` variable (automatically set by GitHub Actions)
2. Use `/usr/bin/google-chrome` in CI environments (installed by the workflow)
3. Use `/usr/bin/chromium` for local development
4. Include required Chrome arguments for headless testing

### Updated Code

```ruby
require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ] do |driver_option|
    driver_option.add_argument("--no-sandbox")
    driver_option.add_argument("--disable-dev-shm-usage")
    # Use Google Chrome in CI environments (installed by workflow), chromium in local development
    if ENV["CI"] && File.exist?("/usr/bin/google-chrome")
      driver_option.binary = "/usr/bin/google-chrome"
    elsif !ENV["CI"] && File.exist?("/usr/bin/chromium")
      driver_option.binary = "/usr/bin/chromium"
    end
  end
end
```

### Key Changes from PR #26's Version

The original code in PR #26:
```ruby
driver_option.binary = "/usr/bin/chromium" if File.exist?("/usr/bin/chromium")
```

The fixed code:
```ruby
if ENV["CI"] && File.exist?("/usr/bin/google-chrome")
  driver_option.binary = "/usr/bin/google-chrome"
elsif !ENV["CI"] && File.exist?("/usr/bin/chromium")
  driver_option.binary = "/usr/bin/chromium"
end
```

## How to Apply This Fix to PR #26

### Option 1: Manual Update
1. Check out the `feature/oauth-devise-basics` branch
2. Edit `test/application_system_test_case.rb`
3. Replace the Chrome binary configuration with the code shown above
4. Commit and push the changes
5. The CI tests should now pass

### Option 2: Cherry-pick from This Branch
1. Check out the `feature/oauth-devise-basics` branch
2. Cherry-pick commit `8f22752` from this branch:
   ```bash
   git cherry-pick 8f22752962d7c2d6c83c5544257e26117d3ccf42
   ```
3. Resolve any conflicts if necessary
4. Push the changes

## Why This Fix Works

1. **CI Environment Detection**: The `ENV["CI"]` variable is automatically set by GitHub Actions, making it a reliable way to detect the CI environment.

2. **Appropriate Binary for Each Environment**: 
   - In CI: Uses the reliable `google-chrome` binary installed by the workflow
   - Locally: Uses the user's `chromium` installation

3. **Fail-Safe**: Both conditions check for file existence before setting the binary, ensuring the code won't break if the expected binary is missing.

4. **Required Arguments**: The `--no-sandbox` and `--disable-dev-shm-usage` arguments are essential for running Chrome/Chromium in headless mode in containerized environments like GitHub Actions.

## Verification

After applying this fix to PR #26, the system tests should pass in GitHub Actions. The test output should show:
- Regular tests passing (as they already do)
- System tests passing without the "no chrome binary" error

## No Changes Needed to ci.yml

The `.github/workflows/ci.yml` file does not need any changes. It already correctly installs `google-chrome-stable`, which provides the binary at `/usr/bin/google-chrome` that this fix uses.
