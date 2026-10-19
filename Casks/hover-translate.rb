cask "hover-translate" do
  version "1.5.2"
  sha256 "bf43ffc0fe173098b9e87026f0f39a63e2f7cc4bb7035dadadf22897254568a3"

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
