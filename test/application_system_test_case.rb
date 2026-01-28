require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ] do |driver_option|
    driver_option.add_argument("--no-sandbox")
    driver_option.add_argument("--disable-dev-shm-usage")
    chrome_bin = ENV["CHROME_BIN"].to_s.strip
    chrome_bin = nil if chrome_bin.empty?
    selected_binary = nil
    if chrome_bin
      if File.exist?(chrome_bin)
        selected_binary = chrome_bin
      else
        warn "CHROME_BIN is set to #{chrome_bin}, but the file does not exist."
      end
    end
    if selected_binary.nil?
      [
        "/usr/bin/google-chrome-stable",
        "/usr/bin/google-chrome",
        "/opt/google/chrome/google-chrome",
        "/usr/bin/chromium",
        "/usr/bin/chromium-browser",
        "/snap/bin/chromium"
      ].each do |binary_path|
        if File.exist?(binary_path)
          selected_binary = binary_path
          break
        end
      end
    end
    driver_option.binary = selected_binary if selected_binary
  end
end
