Pod::Spec.new do |s|
  s.name         = "BasicStepIndoorLocationProvider"
  s.version      = "1.0.0"
  s.license      = { :type => 'MIT' }
  s.summary      = "Allows to set an IndoorLocation with Navisens"
  s.homepage     = "https://github.com/IndoorLocation/basic-step-indoor-location-provider-ios.git"
  s.author       = { "Indoor Location" => "indoorlocation@mapwize.io" }
  s.platform     = :ios
  s.ios.deployment_target = '6.0'
  s.source       = { :git => "https://github.com/IndoorLocation/basic-step-indoor-location-provider-ios.git", :tag => "#{s.version}" }
  s.source_files  = "basic-step-indoorlocation-provider-ios/Provider/*.{h,m}"
  s.dependency "IndoorLocation", "1.0.4"
end
