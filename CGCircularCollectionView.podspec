#
# Be sure to run `pod lib lint CGCircularCollectionView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "CGCircularCollectionView"
  s.version          = "0.1.6"
  s.summary          = "A circular collection"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.homepage         = "https://github.com/guoshencheng/CGCircularCollectionView"
  s.license          = 'MIT'
  s.author           = { "guoshencheng" => "guoshencheng1@gmail.com" }
  s.source           = { :git => "https://github.com/guoshencheng/CGCircularCollectionView.git", :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/*'
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
