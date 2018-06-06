#
# Be sure to run `pod lib lint CLHelper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CLHelper'
  s.version          = '1.0.6'
  s.summary          = 'A Classic way to manage Core Location Jobs'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  'CLHelper is a helper file which will help in managing all your Core Location related task in a neat way with closures.'
                       DESC

  s.homepage         = 'https://github.com/greenSyntax/CLHelper'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Abhishek Kumar Ravi' => 'ab.abhishek.ravi@gmail.com' }
  s.source           = { :git => 'https://github.com/greenSyntax/CLHelper.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/greenSyntax'

  s.ios.deployment_target = '9.0'

  s.source_files = 'CLHelper/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CLHelper' => ['CLHelper/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
