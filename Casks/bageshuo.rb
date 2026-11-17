cask "bageshuo" do
  version "1.0.39"
  sha256 "0ea10effeaf4e88782c7ab7ac05d4767eb628ee9d12ba864ca3f6682b71532f4"

  url "https://codown.youdao.com/bageshuo/releases/#{version}/bageshuo_#{version}_darwin-universal.app.tar.gz"
  name "网易叭哥说"
  name "Bageshuo"
  desc "AI-powered voice input and translation tool"
  homepage "https://bug.youdao.com/"

  livecheck do
    url "https://codown.youdao.com/bageshuo/latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  depends_on :macos

  app "网易叭哥说.app"

  uninstall quit: "com.bageshuo"

  zap trash: [
    "~/Library/Application Support/com.bageshuo",
    "~/Library/Caches/com.bageshuo",
    "~/Library/HTTPStorages/com.bageshuo",
    "~/Library/Logs/com.bageshuo",
    "~/Library/Preferences/com.bageshuo.plist",
    "~/Library/Saved Application State/com.bageshuo.savedState",
    "~/Library/WebKit/com.bageshuo",
  ]
end
