# KoolingSDK

A Swift Package Manager library that provides prebuilt KoolingSDK framework with Alamofire framework for iOS applications.

## Features

- **KoolingSDK**: Main SDK functionality (prebuilt xcframework)
- **Alamofire**: Network layer support (prebuilt xcframework)
- **iOS 15+**: Minimum deployment target

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## Installation

### Swift Package Manager

Add KoolingSDK to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/shinnguyen5589/KoolingSDK.git", from: "1.0.1")
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

## Usage

### Basic Setup

```swift
import KoolingSDK

// Configure SDK
let configuration = KoolingConfiguration(
    accessToken: "your-access-token",
    environment: .production
)

do {
    try KoolingSDKManager.shared.configure(with: configuration)
} catch {
    print("Configuration error: \(error)")
}
```

### Start/Stop Tracking

```swift
// Start tracking
do {
    try KoolingSDKManager.shared.startTracking(from: viewController)
} catch {
    print("Failed to start tracking: \(error)")
}

// Stop tracking
do {
    try KoolingSDKManager.shared.stopTracking()
} catch {
    print("Failed to stop tracking: \(error)")
}
```

### Check Status

```swift
// Check if SDK is configured
if KoolingSDKManager.shared.isConfigured {
    print("SDK is ready")
}

// Check if tracking is active
if KoolingSDKManager.shared.isTracking {
    print("Currently tracking")
}
```

### Fetch Trips

```swift
// Get recent trips (default 20 items)
do {
    let trips = try await KoolingSDKManager.shared.getTrips()
    print("Fetched \(trips.count) trips")
} catch {
    print("Error: \(error)")
}

// Get trips with custom page size
do {
    let trips = try await KoolingSDKManager.shared.getTrips(pageSize: 50)
    print("Fetched \(trips.count) trips")
} catch {
    print("Error: \(error)")
}

// Get trips with filters
let filters = TripFilters(
    transportationMode: 1,  // Car
    vehicleType: "electric",
    month: 3,
    year: 2024,
    pageSize: 30
)

do {
    let filteredTrips = try await KoolingSDKManager.shared.getTrips(with: filters)
    print("Fetched \(filteredTrips.count) filtered trips")
} catch {
    print("Error: \(error)")
}

// Get single trip by ID
do {
    let trip = try await KoolingSDKManager.shared.getTrip(id: "trip-id")
    print("Trip distance: \(trip.distance ?? "0") meters")
} catch {
    print("Error: \(error)")
}
```

### Fetch Statistics

```swift
// Monthly statistics
do {
    let monthlyStats = try await KoolingSDKManager.shared.getStatistics(for: .month)
    print("Monthly stats: \(monthlyStats.count) entries")
} catch {
    print("Error: \(error)")
}

// Yearly statistics  
do {
    let yearlyStats = try await KoolingSDKManager.shared.getStatistics(for: .year)
    print("Yearly stats: \(yearlyStats.count) entries")
} catch {
    print("Error: \(error)")
}

// All-time statistics
do {
    let allStats = try await KoolingSDKManager.shared.getStatistics(for: .all)
    print("All-time stats: \(allStats.count) entries")
} catch {
    print("Error: \(error)")
}
```

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
