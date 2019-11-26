require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |spec|

  spec.name         = "SwipeActionView"
  spec.version      = package['version']
  spec.summary      = package['description']
  spec.license      = package['license']

  spec.author       = "Wix"
  spec.homepage     = package['homepage']
  spec.platforms    = { :ios => "9.0", :tvos => "9.2" }

  spec.source       = { :git => "https://github.com/wix/react-native-action-view.git", :tag => "v#{spec.version}" }
  spec.source_files = "ios/lib/**/*.{h,m}"

  spec.dependency "React"

end
