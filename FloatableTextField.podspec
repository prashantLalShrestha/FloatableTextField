#
# Be sure to run `pod lib lint FloatableTextField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FloatableTextField'
  s.version          = '0.1.0'
  s.swift_version    = '4.0'
  s.summary          = 'A beautiful Custom TextField designed for forms and login in iOS Apps.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
It is a custom UItextField with the addition of animations, state indicator, messages label and animated placeholders.
                       DESC

  s.homepage         = 'https://github.com/prashantLalShrestha/FloatableTextField'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'prashantLalShrestha' => 'prashantlurvs@gmail.com' }
  s.source           = { :git => 'https://github.com/prashantLalShrestha/FloatableTextField.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'FloatableTextField/Classes/**/*'
  
  s.resource_bundles = {
    'FloatableTextField' => ['FloatableTextField/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
