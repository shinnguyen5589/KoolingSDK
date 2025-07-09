# KoolingSDK

A Swift Package Manager library that provides prebuilt KoolingSDK framework with Alamofire framework for iOS applications.

## Features

- **KoolingSDK**: Main SDK functionality (prebuilt xcframework)
- **Alamofire**: Network layer support (prebuilt xcframework)
- **iOS 15+**: Minimum deployment target

## Requirements

- iOS 15.0+
- Xcode 15.0+
- Swift 6.1+

## Installation

### Swift Package Manager

Add KoolingSDK to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/shinnguyen5589/KoolingSDK.git", from: "1.0.2")
]
```

Then add the frameworks to your target:

```swift
targets: [
    .target(
        name: "YourApp",
        dependencies: [
            .product(name: "KoolingSDK", package: "KoolingSDK"),
            .product(name: "Alamofire", package: "KoolingSDK")
        ]
    )
]
```

## Required Permissions

Add these permissions to your `Info.plist`:

```xml
<!-- Location Permissions -->
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs location access to track trips and calculate CO2 emissions</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to track trips and calculate CO2 emissions</string>

<!-- Health Permissions -->
<key>NSHealthShareUsageDescription</key>
<string>This app uses HealthKit to determine walking and running distances</string>

<!-- Motion Permissions -->
<key>NSMotionUsageDescription</key>
<string>This app uses motion sensors to detect transportation modes</string>

<!-- Background Modes -->
<key>UIBackgroundModes</key>
<array>
    <string>location</string>
    <string>fetch</string>
</array>
```

## Required Capabilities

In your Xcode project, go to **Signing & Capabilities** and add the following capabilities:

### Background Modes
- ✅ **Background fetch**: Allows the app to fetch data in the background
- ✅ **Location updates**: Enables location tracking when app is in background
- ✅ **Uses Bluetooth LE accessories**: Required for Bluetooth Low Energy functionality

### HealthKit
- ✅ **HealthKit Background Delivery**: Allows background delivery of HealthKit Observer Queries

> **Note**: These capabilities must be enabled in your Xcode project's **Signing & Capabilities** tab for the SDK to function properly.

## Usage

### Basic Setup

(Updating...)

### Error Handling

```swift
do {
    let trips = try await KoolingSDKManager.shared.getTrips()
    // Handle success
} catch KoolingSDKError.notConfigured {
    print("SDK not configured")
} catch KoolingSDKError.networkUnavailable {
    print("Network unavailable")
} catch KoolingSDKError.permissionDenied {
    print("Location permissions required")
} catch {
    print("Error: \(error.localizedDescription)")
}
```

## Important Notes

- KoolingSDK framework already includes Alamofire as a dependency
- You typically only need to import `KoolingSDK` in your code
- Import `Alamofire` separately only if you need direct access to Alamofire APIs
- Test on real devices - location tracking doesn't work in simulators

## License

This project is licensed under the MIT License - see the LICENSE file for details.
