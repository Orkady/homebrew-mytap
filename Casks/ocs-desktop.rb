cask "ocs-desktop" do
  version "3.4.1"
  sha256 "3a3ae4c37c301b27f9b84aaa9d4385f6b1101e3f635f7667b5ef59d033ef66de"

  url "https://github.com/ocsjs/ocs-desktop/releases/download/v#{version}/ocs-#{version}-setup-mac-arm64.dmg"
  name "OCS Desktop"
  desc "OCS browser automation tool for multi-instance browsers and user script setup"
  homepage "https://docs.ocsjs.com/"

  livecheck do
    url "https://github.com/ocsjs/ocs-desktop/releases/latest"
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on :macos

  app "OCS Desktop.app"

  # This app is an ad-hoc signed Electron bundle that has not been notarized.
  # Copying it out of the mounted disk image causes macOS to attach a
  # quarantine attribute, and Gatekeeper then refuses to launch it. Clearing
  # the attributes after the app has been moved fixes that.
  postflight_steps do
    run "xattr", args: ["-cr", "/Applications/OCS Desktop.app"]
  end

  zap trash: [
    "~/Library/Application Support/ocs.enncy.cn",
    "~/Library/Caches/ocs.enncy.cn",
    "~/Library/Logs/ocs.enncy.cn",
    "~/Library/Preferences/ocs.enncy.cn.plist",
    "~/Library/Saved Application State/ocs.enncy.cn.savedState",
  ]
end
