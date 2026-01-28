require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ] do |options|
    # Prefer CHROME_BIN, otherwise use the first known Chrome/Chromium path found,
    # and fall back to Selenium's default detection if none exist.
    chrome_bin = [
      ENV["CHROME_BIN"],
      "/usr/bin/google-chrome-stable",
      "/usr/bin/google-chrome",
      "/usr/bin/chromium",
      "/usr/bin/chromium-browser",
      "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
      "/Applications/Chromium.app/Contents/MacOS/Chromium",
      "C:/Program Files/Google/Chrome/Application/chrome.exe",
      "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe"
    ].compact.find { |path| File.exist?(path) }

    options.binary = chrome_bin if chrome_bin
  end
end
