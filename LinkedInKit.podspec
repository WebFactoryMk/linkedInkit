#
# Be sure to run `pod lib lint LinkedInKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LinkedInKit'
  s.version          = '0.1.0'
  s.summary          = 'A short description of LinkedInKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/<GITHUB_USERNAME>/LinkedInKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mariana' => 'mariana.ristovska@webfactory.mk' }
  s.source           = { :git => 'https://github.com/<GITHUB_USERNAME>/LinkedInKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'LinkedInKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LinkedInKit' => ['LinkedInKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit'
  
  s.dependency 'Alamofire'
  
end
