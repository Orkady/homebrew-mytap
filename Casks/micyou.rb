cask "micyou" do
  version "2.1.0"
  sha256 "5380a7721d76a77d5ae817f61424e5f21a9d03eeda641745375c3827ff6537bc"

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
