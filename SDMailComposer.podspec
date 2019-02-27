#
# Be sure to run `pod lib lint SDMailComposer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SDMailComposer'
  s.version          = '0.1.0'
  s.summary          = 'A utility mail composer library for iOS to open most popular mail applications from your app.'
  s.swift_version    = '4.2'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
 A utility mail composer library for iOS to open most popular mail applications from your app. Install this library to open AppleMail, Gmail, Yahoo Mail and MS Outlook from your application. You can provide optional recipient, carbon copy (cc), blind carbon copy (bcc) list along with optional subject line and body content.
                       DESC

  s.homepage         = 'https://github.com/sauvikdolui/SDMailComposer'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sauvikdolui' => 'sauvikdolui@gmail.com' }
  s.source           = { :git => 'https://github.com/sauvikdolui/SDMailComposer.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SDMailComposer/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SDMailComposer' => ['SDMailComposer/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
