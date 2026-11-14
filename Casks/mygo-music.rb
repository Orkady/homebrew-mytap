cask "mygo-music" do
  version "0.1.25"
  sha256 "589373d58a6b2a9c2dcdcb2ca7ecfc0b5ca43d029174e73240eed491e94a211d"

  url "https://github.com/egoist/mygo-music/releases/download/v#{version}/mygo-music-#{version}-arm64.dmg"
  name "MyGo Music"
  desc "Native music player extended with plugins"
  homepage "https://music.egoist.dev/"

  livecheck do
    url "https://github.com/egoist/mygo-music/releases/latest"
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :ventura

  app "MyGo Music.app"

  zap trash: [
    "~/Library/Application Support/dev.egoist.music",
    "~/Library/Caches/dev.egoist.music",
    "~/Library/Logs/dev.egoist.music",
    "~/Library/Preferences/dev.egoist.music.plist",
    "~/Library/Saved Application State/dev.egoist.music.savedState",
    "~/Library/WebKit/dev.egoist.music",
  ]
end
