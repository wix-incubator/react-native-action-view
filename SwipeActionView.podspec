require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |spec|

  spec.name         = "SwipeActionView"
  spec.version      = "1.0.0"
  spec.summary      = "Native container view for enabling swipe actions (for example to enable swipe to delete and such)"
  spec.license      = "MIT"

  spec.author       = "Wix"
  spec.homepage     = "https://github.com/wix/react-native-action-view"
  spec.platform     = :ios, "10.0"

  spec.source       = { :git => "https://github.com/wix/react-native-action-view.git", :tag => "v#{spec.version}" }
  spec.source_files = "ios/lib/**/*.{h,m}"

  spec.dependency "React"

end
