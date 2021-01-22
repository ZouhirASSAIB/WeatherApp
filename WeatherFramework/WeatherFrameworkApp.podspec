#
#  Be sure to run `pod spec lint WeatherFramework.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name           = "WeatherFrameworkApp"
  spec.version        = "1.0.5"
  spec.summary        = "Collects weather informations from an OpenWeather One Call API."
  spec.description    = <<-DESC
Just one API call and get all your essential weather data for a specific location with OpenWeather One Call API.
                   DESC

  spec.homepage       = "https://github.com/ZouhirASSAIB/WeatherApp"
  spec.license        = { :type => 'MIT', :file => 'LICENSE' }
  spec.author         = { "Zouhair ASSAIB" => "zouhair.assaib@gmail.com" }
  spec.platform       = :ios, "11.0"
  spec.source         = { :git => "https://github.com/ZouhirASSAIB/WeatherApp.git", :tag => "1.0.5" }
  spec.source_files   = "WeatherFramework/**/*.{h,m,swift}"
  spec.exclude_files  = "WeatherFramework/WeatherFrameworkTests"
  spec.swift_versions = "5.0"

end
