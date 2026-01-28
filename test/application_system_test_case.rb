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
