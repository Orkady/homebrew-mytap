cask "hover-translate" do
  version "1.5.1"
  sha256 "2c200807fdbe6bbe6fb13d6c37e18490fe759bc96efe30b9aae3c6d58745d8c8"

  url "https://hover-translate.oss-cn-beijing.aliyuncs.com/releases/Hover%20Translate-#{version}.dmg"
  name "Hover Translate"
  desc "Translate text by hovering the cursor over it"
  homepage "https://hover-translate.com/"

  livecheck do
    url "https://hover-translate.oss-cn-beijing.aliyuncs.com/appcast.xml"
    strategy :sparkle
  end

  depends_on macos: :sonoma

  app "Hover Translate.app"

  zap trash: [
    "~/Library/Application Support/me.blipsandchitz.hovertranslate",
    "~/Library/Caches/me.blipsandchitz.hovertranslate",
    "~/Library/Logs/me.blipsandchitz.hovertranslate",
    "~/Library/Preferences/me.blipsandchitz.hovertranslate.plist",
    "~/Library/Saved Application State/me.blipsandchitz.hovertranslate.savedState",
  ]
end
