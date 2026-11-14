cask "micyou" do
  version "2.2.0"
  sha256 "8bb8d8e9a5c4eb57a12e0a2188a198c121e1ae156f23203abce9513b2309d88b"

  url "https://github.com/MicYou-Dev/MicYou/releases/download/v#{version}/MicYou-macOS-#{version}-arm64.dmg"
  name "MicYou"
  desc "Use an Android device as a high-quality microphone for your computer"
  homepage "https://micyou.top/"

  livecheck do
    url "https://github.com/MicYou-Dev/MicYou/releases/latest"
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on :macos

  app "MicYou.app"

  # This app is an ad-hoc signed Tauri bundle whose signature does not pass
  # Gatekeeper evaluation (spctl reports a broken seal). Copying it out of
  # the mounted disk image attaches a quarantine attribute, so the
  # attributes must be cleared after the app lands in /Applications.
  postflight_steps do
    run "xattr", args: ["-cr", "/Applications/MicYou.app"]
  end

  zap trash: [
    "~/Library/Application Support/com.lanrhyme.micyou",
    "~/Library/Caches/com.lanrhyme.micyou",
    "~/Library/Logs/com.lanrhyme.micyou",
    "~/Library/Preferences/com.lanrhyme.micyou.plist",
    "~/Library/Saved Application State/com.lanrhyme.micyou.savedState",
    "~/Library/WebKit/com.lanrhyme.micyou",
  ]
end
