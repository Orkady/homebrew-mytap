cask "hover-translate" do
  version "1.5.3"
  sha256 "58e5323f0eb3f96656d16ccdaee3afadd71fd1de63f6dbb60773d5e852bbdf54"

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
