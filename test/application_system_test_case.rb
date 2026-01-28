require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ] do |driver_option|
    driver_option.add_argument("--no-sandbox")
    driver_option.add_argument("--disable-dev-shm-usage")
    [ "/usr/bin/google-chrome", "/usr/bin/chromium", "/usr/bin/chromium-browser" ].each do |binary_path|
      if File.exist?(binary_path)
        driver_option.binary = binary_path
        break
      end
    end
  end
end
