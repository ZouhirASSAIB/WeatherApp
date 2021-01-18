#
#  Be sure to run `pod spec lint WeatherFramework.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "WeatherFramework"
  spec.version      = "1.0.0"
  spec.summary      = "A short description of WeatherFramework."
  spec.description  = <<-DESC
A Complete description of WeatherFramework.
                   DESC

  spec.homepage     = "https://github.com/ZouhirASSAIB/WeatherApp"
  spec.license      = "MIT"
  spec.author       = { "Zouhair ASSAIB" => "zouhair.assaib@gmail.com" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/ZouhirASSAIB/WeatherApp.git", :tag => "1.0.0" }
  spec.source_files  = "WeatherFramework"
  spec.exclude_files = "Classes/Exclude"

end
