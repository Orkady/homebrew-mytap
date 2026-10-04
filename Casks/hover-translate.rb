cask "hover-translate" do
  version "1.4.1"
  sha256 "c045b7d784a92cf751bf2907f6ef81c06629fec86d8e7dc50a208527ab7828e5"

  url "https://hover-translate.oss-cn-beijing.aliyuncs.com/releases/Hover%20Translate-#{version}.dmg"
  name "Hover Translate"
  desc "Translate text by hovering the cursor over it"
  homepage "https://hover-translate.oss-cn-beijing.aliyuncs.com/"

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
