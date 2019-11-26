#
#  Be sure to run `pod spec lint SwipeActionView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |spec|

  spec.name         = "SwipeActionView"
  spec.version      = "0.0.1"
  spec.summary      = "Native container view for enabling swipe actions (for example to enable swipe to delete and such)"
  spec.license      = "MIT"

  spec.author       = "Wix"
  spec.homepage     = "https://github.com/wix/react-native-action-view.git"
  spec.platform     = :ios, "10.0"

  spec.source       = { :git => "https://github.com/wix/react-native-action-view.git", :tag => "#{spec.version}" }
  spec.source_files = "ios/**/*.{h,m}"
  spec.dependency   "React"

end
