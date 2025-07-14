Pod::Spec.new do |spec|
  spec.name         = "KoolingSDK"
  spec.version      = "1.0.6"
  spec.summary      = "A lightweight iOS SDK for location tracking and activity monitoring"
  spec.description  = <<-DESC
                      KoolingSDK is a lightweight iOS SDK for location tracking and activity monitoring. 
                      Perfect for apps that need to track user trips and provide analytics.
                      
                      Features:
                      - Background Location Tracking
                      - Activity Monitoring (walking, driving, cycling)
                      - Automatic Permissions handling
                      - Network Integration with authentication
                      - Debug Tools and logging
                      DESC

  spec.homepage     = "https://github.com/shinnguyen5589/KoolingSDK"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Shin Nguyen" => "shinnguyen5589@gmail.com" }
  spec.platform     = :ios, "15.0"
  spec.source       = { :git => "https://github.com/shinnguyen5589/KoolingSDK.git", :tag => "1.0.6" }

  spec.vendored_frameworks = [
    "Sources/KoolingSDK.xcframework",
    "Sources/Alamofire.xcframework"
  ]

  spec.source_files = "Sources/KoolingSDKWrapper/*.swift"

  spec.frameworks = [
    "Foundation",
    "CoreLocation",
    "CoreData",
    "HealthKit",
    "CoreBluetooth",
    "UIKit"
  ]

  spec.requires_arc = true
  spec.swift_version = "5.0"

  spec.pod_target_xcconfig = {
    'SWIFT_VERSION' => '5.0',
    'IPHONEOS_DEPLOYMENT_TARGET' => '15.0'
  }

  spec.user_target_xcconfig = {
    'SWIFT_VERSION' => '5.0',
    'IPHONEOS_DEPLOYMENT_TARGET' => '15.0'
  }

  # Add any additional dependencies if needed
  # spec.dependency "SomeOtherPod", "~> 1.0"
end 