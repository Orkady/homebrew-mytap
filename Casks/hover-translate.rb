cask "hover-translate" do
  version "1.5.0"
  sha256 "5992c2364bf54cf0f2abb98ba71209595de5f81d3daa08042b70b09098d99270"

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
