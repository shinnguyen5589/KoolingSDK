# KoolingSDK

A comprehensive iOS SDK for tracking user activities, calculating CO2 emissions, and managing transportation data. KoolingSDK enables applications to automatically detect different transportation modes, track locations, and provide detailed analytics about travel patterns and environmental impact.

## Features

🚗 **Automatic Transportation Detection** - Detect walking, driving, cycling, and other transportation modes
📍 **Location Tracking** - High-accuracy GPS tracking with background support
📊 **CO2 Calculations** - Calculate carbon emissions based on transportation mode and distance
🏆 **Points & Rewards** - Track eco-friendly transportation points and achievements
📈 **Trip Analytics** - Detailed trip statistics and historical data
🔋 **Battery Optimized** - Efficient tracking with minimal battery impact
🌍 **Multiple Environments** - Support for production and staging environments

## Requirements

- **iOS Deployment Target**: 15.0+ (minimum supported)
- **Swift Version**: 5.0+
- **Xcode Version**: 15.0+ (compatible), 16.4+ (recommended)
- **Supported Architectures**: arm64, x86_64 (simulator)

> **Note**: While KoolingSDK works with Xcode 15.0+, we recommend using Xcode 16.4+ for the best development experience and latest iOS features.

## Dependencies

KoolingSDK requires the following dependencies:

- **Alamofire** - Network layer for API communications
- **Core Location** - For location tracking and geofencing
- **Core Motion** - For activity and motion detection
- **HealthKit** - For steps and distance measurements

## Installation

### Manual Installation

1. Download the latest **KoolingSDK.framework** from releases
2. Download the latest **Alamofire.xcframework** from releases
3. Drag and drop both frameworks into your Xcode project
4. Add both frameworks to your target's "Frameworks, Libraries, and Embedded Content"
5. **Important**: Set both frameworks to **"Do Not Embed"** (see Framework Configuration below)

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/shinnguyen5589/KoolingSDK.git", from: "1.0.0")
]
```

## Framework Configuration

After adding both frameworks to your project, you need to configure them properly:

### 1. In Xcode Project Navigator:

1. Select your project file
2. Go to your app target
3. Navigate to **"General"** tab
4. Scroll down to **"Frameworks, Libraries, and Embedded Content"**

### 2. Configure Framework Settings:

Set both frameworks to **"Do Not Embed"**:

- ✅ **KoolingSDK.xcframework** → **Do Not Embed**
- ✅ **Alamofire.xcframework** → **Do Not Embed**

![Framework Configuration](https://imgur.com/framework-config.png)

### 3. Framework Embedding Options Explained:

| Option | When to Use | KoolingSDK Setting |
|--------|-------------|-------------------|
| **Do Not Embed** | Framework is statically linked or already included | ✅ **Use This** |
| **Embed & Sign** | Dynamic framework that needs to be copied to app bundle | ❌ Don't use |
| **Embed Without Signing** | Dynamic framework, manual signing | ❌ Don't use |

### 4. Why "Do Not Embed" for Both Frameworks?

- ✅ **Static Linking**: Both frameworks are designed to be statically linked
- ✅ **Separate Dependencies**: Alamofire is a required dependency for KoolingSDK
- ✅ **Smaller App Size**: Static linking reduces final app bundle size
- ✅ **Faster Launch**: No dynamic loading overhead
- ❌ **Avoid "Embed & Sign"**: Would cause duplicate symbols and linker errors

### 5. Set iOS Deployment Target:

In your Xcode project settings:

1. Select your project file
2. Go to your app target
3. Navigate to **"Build Settings"** tab
4. Search for **"iOS Deployment Target"**
5. Set to **15.0** or higher

```
iOS Deployment Target: 15.0
```

## Quick Setup Checklist

Before using KoolingSDK, make sure you have completed:

### Framework Setup:
- [ ] ✅ Downloaded KoolingSDK.framework from releases
- [ ] ✅ Downloaded Alamofire.xcframework from releases
- [ ] ✅ Added both frameworks to project
- [ ] ✅ Set both frameworks to **"Do Not Embed"**
- [ ] ✅ Set iOS Deployment Target to **15.0+**

### Permissions Setup:
- [ ] ✅ Added Location permissions (Always, When In Use, Temporary Usage)
- [ ] ✅ Added Health permission (Share)
- [ ] ✅ Added Motion permission
- [ ] ✅ Configured background modes (fetch, bluetooth-central, location)

### SDK Integration:
- [ ] ✅ Called `configure()` before using SDK
- [ ] ✅ Implemented proper error handling

## Required Permissions

Add these permissions to your `Info.plist`:

```xml
<!-- Location Permissions -->
<key>NSLocationTemporaryUsageDescriptionDictionary</key>
<dict>
    <key>LocationAccuracyAuthorizationDescription</key>
    <string>Please enable precise location. Turn-by-turn directions only work when precise location data is available.</string>
</dict>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Please accept location permission to use app location functionality</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Please accept location permission to use app location functionality</string>

<!-- Health Permissions -->
<key>NSHealthShareUsageDescription</key>
<string>This app uses healtkit for determining walking and running distances</string>

<!-- Motion Permissions -->
<key>NSMotionUsageDescription</key>
<string>App uses motion sensors to determine travels and calculate points and CO2 emissions based on this information.</string>

<!-- Background Modes -->
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>bluetooth-central</string>
    <string>location</string>
</array>
```

### Why These Permissions Are Required:

| Permission | Purpose | Required For |
|------------|---------|--------------|
| **Location** | Track trips and detect transportation modes | Core functionality |
| **Health** | Access steps and walking/running distances | Activity detection |
| **Motion** | Detect device movement and activity type | Transportation mode detection |

> **Privacy Note**: KoolingSDK only uses these permissions for transportation tracking and CO2 calculation purposes. No personal data is stored or shared without consent.

## Configuration

### 1. Import the SDK

```swift
import KoolingSDK
```

### 2. Configure the SDK

```swift
// Configure with your access token
let configuration = KoolingConfiguration(
    accessToken: "your-access-token",
    environment: .production // or .staging
)

do {
    try KoolingSDKManager.shared.configure(with: configuration)
} catch {
    print("Configuration error: \(error)")
}
```

## Usage

### Starting Location Tracking

```swift
// Start tracking with permission request
do {
    try KoolingSDKManager.shared.startTracking(from: viewController)
} catch {
    print("Failed to start tracking: \(error)")
}

// Start tracking without permission UI (if permissions already granted)
do {
    try KoolingSDKManager.shared.startTracking()
} catch {
    print("Failed to start tracking: \(error)")
}
```

### Stopping Location Tracking

```swift
do {
    try KoolingSDKManager.shared.stopTracking()
} catch {
    print("Failed to stop tracking: \(error)")
}
```

### Check Tracking Status

```swift
// Check if SDK is configured
if KoolingSDKManager.shared.isConfigured {
    print("SDK is configured")
}

// Check if tracking is active
if KoolingSDKManager.shared.isTracking {
    print("Tracking is active")
}

// Get current environment
if let environment = KoolingSDKManager.shared.environment {
    print("Current environment: \(environment)")
}
```

## Trip Management

### Fetch Trips with Pagination

```swift
// Get trips with default pagination (20 items)
do {
    let trips = try await KoolingSDKManager.shared.getTrips()
    print("Fetched \(trips.count) trips")
} catch {
    print("Error fetching trips: \(error)")
}

// Get trips with custom page size
do {
    let trips = try await KoolingSDKManager.shared.getTrips(pageSize: 50)
    print("Fetched \(trips.count) trips")
} catch {
    print("Error fetching trips: \(error)")
}
```

### Fetch Trips with Filters

```swift
// Create trip filters
let filters = TripFilters(
    transportationMode: 1,  // Car
    vehicleType: "electric",
    fuelType: "electric",
    week: 10,
    month: 3,
    year: 2024,
    pageSize: 30,
    cursor: "next-page-cursor"
)

// Fetch filtered trips
do {
    let trips = try await KoolingSDKManager.shared.getTrips(with: filters)
    print("Fetched \(trips.count) filtered trips")
} catch {
    print("Error fetching filtered trips: \(error)")
}
```

### Fetch Single Trip

```swift
do {
    let trip = try await KoolingSDKManager.shared.getTrip(id: "trip-id")
    print("Trip distance: \(trip.distance ?? "0") meters")
} catch {
    print("Error fetching trip: \(error)")
}
```

## Statistics

### Fetch General Statistics

```swift
// Get monthly statistics
do {
    let stats = try await KoolingSDKManager.shared.getStatistics(for: .month)
    print("Monthly statistics: \(stats.count) entries")
} catch {
    print("Error fetching statistics: \(error)")
}

// Get yearly statistics
do {
    let stats = try await KoolingSDKManager.shared.getStatistics(for: .year)
    print("Yearly statistics: \(stats.count) entries")
} catch {
    print("Error fetching statistics: \(error)")
}

// Get all-time statistics
do {
    let stats = try await KoolingSDKManager.shared.getStatistics(for: .all)
    print("All-time statistics: \(stats.count) entries")
} catch {
    print("Error fetching statistics: \(error)")
}
```

## Data Models

### KoolingConfiguration

```swift
public struct KoolingConfiguration {
    public let accessToken: String
    public let environment: KoolingEnvironment
    
    public init(accessToken: String, environment: KoolingEnvironment)
}
```

### KoolingEnvironment

```swift
public enum KoolingEnvironment: CaseIterable {
    case production
    case staging
}
```

### TripFilters

```swift
public struct TripFilters {
    public let transportationMode: Int?    // 1=Car, 11=Walk, etc.
    public let vehicleType: String?        // "electric", "hybrid", etc.
    public let fuelType: String?           // "electric", "petrol", etc.
    public let week: Int?                  // Week number
    public let month: Int?                 // Month number (1-12)
    public let year: Int?                  // Year
    public let pageSize: Int?              // Items per page (1-100)
    public let cursor: String?             // Pagination cursor
}
```

### TripPreview

```swift
public struct TripPreview: Decodable {
    public let itinid: String              // Trip ID
    public let distance: String            // Distance in meters
    public let startdate: String           // Start date
    public let enddate: String             // End date
    public let defraco2emissions: String   // CO2 emissions
    public let absolutepoints: String      // Points earned
    public let firstlong: String?          // Start longitude
    public let firstlat: String?           // Start latitude
    public let lastlong: String?           // End longitude
    public let lastlat: String?            // End latitude
    public let transportationmode: Int     // Transportation mode
    public let timestamp: String?          // Timestamp
    public let vehicletype: String         // Vehicle type
    public let fueltype: String            // Fuel type
    public let isEnhance: Bool             // Enhanced mode
}
```

### Trip

```swift
public struct Trip: Codable {
    public let itinid: String?                     // Trip ID
    public let vehicletype: String?                // Vehicle type
    public let distance: String?                   // Distance in meters
    public let transportationmode: Int?            // Transportation mode
    public let co2benchmarkrating: Double?        // CO2 benchmark rating
    public let defraco2emissions: String?          // CO2 emissions
    public let ecodrivingscore: String?            // Eco driving score
    public let defraconversionfactor: String?      // DEFRA conversion factor
    public let firstlat: String?                   // Start latitude
    public let firstlong: String?                  // Start longitude
    public let fueltype: String?                   // Fuel type
    public let kooldrivingpoints: String?          // Kool driving points
    public let kooldrivingpointsperkm: String?     // Points per km
    public let lastlat: String?                    // End latitude
    public let lastlong: String?                   // End longitude
    public let points: String?                     // Total points
    public let absolutepoints: String?             // Absolute points
    public let absolutepointsperkm: String?        // Absolute points per km
    public let startdate: String?                  // Start date
    public let enddate: String?                    // End date
    public let timestamp: String?                  // Timestamp
    public let year: Int?                          // Year
    public let month: Int?                         // Month
    public let week: Int?                          // Week
    public let is_enhance: Bool?                   // Enhanced mode
    public let other_trip_vehicle_name: String?    // Other vehicle name
    public let gpx: String?                        // GPX data
}
```

### GeneralStatistics

```swift
public struct GeneralStatistics: Codable {
    public let transportationmode: Int        // Transportation mode
    public let fueltype: String               // Fuel type
    public let vehicletype: String            // Vehicle type
    public var defraco2emissions: Double      // CO2 emissions
    public var kooldrivingpoints: Double      // Kool driving points
    public var absolutepoints: Double         // Absolute points
    public var points: Double                 // Total points
    public var pointsPerKm: Double            // Points per km
    public var distance: Double               // Distance in meters
    public var distanceInKM: Double           // Distance in km
    public var savedco2e: Double              // Saved CO2 emissions
    public var ecodrivingscore: Double        // Eco driving score
    
    public enum Filter {
        case month
        case year
        case all
    }
}
```

## Error Handling

### KoolingSDKError

```swift
public enum KoolingSDKError: LocalizedError {
    case notConfigured              // SDK not configured
    case invalidConfiguration       // Invalid configuration
    case invalidAccessToken         // Invalid access token
    case networkUnavailable         // Network unavailable
    case permissionDenied          // Permissions denied
    case trackingAlreadyActive     // Tracking already active
    case trackingNotActive         // Tracking not active
    case serviceUnavailable        // Service unavailable
    case invalidTripId             // Invalid trip ID
    case invalidPageSize           // Invalid page size
    case unknown(Error)            // Unknown error
}
```

### Error Handling Example

```swift
do {
    let trips = try await KoolingSDKManager.shared.getTrips()
    // Handle success
} catch KoolingSDKError.notConfigured {
    // SDK not configured
    print("Please configure the SDK first")
} catch KoolingSDKError.networkUnavailable {
    // Network error
    print("Network unavailable")
} catch KoolingSDKError.permissionDenied {
    // Permissions denied
    print("Location permissions required")
} catch {
    // Other errors
    print("Error: \(error.localizedDescription)")
}
```

## Transportation Modes

| Mode | Description |
|------|-------------|
| 1    | Car         |
| 2    | Bus         |
| 3    | Train       |
| 4    | Bike        |
| 5    | Motorcycle  |
| 6    | Taxi        |
| 7    | Running     |
| 8    | Walking     |
| 9    | Plane       |
| 10   | Boat        |
| 11   | Walk        |

## Complete Example

```swift
import UIKit
import KoolingSDK

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKoolingSDK()
    }
    
    private func setupKoolingSDK() {
        // Configure SDK
        let configuration = KoolingConfiguration(
            accessToken: "your-access-token",
            environment: .production
        )
        
        do {
            try KoolingSDKManager.shared.configure(with: configuration)
            print("SDK configured successfully")
        } catch {
            print("Configuration failed: \(error)")
            return
        }
        
        // Start tracking
        startTracking()
    }
    
    private func startTracking() {
        do {
            try KoolingSDKManager.shared.startTracking(from: self)
            print("Tracking started")
        } catch {
            print("Failed to start tracking: \(error)")
        }
    }
    
    private func fetchTrips() {
        Task {
            do {
                // Fetch recent trips
                let trips = try await KoolingSDKManager.shared.getTrips(pageSize: 20)
                print("Fetched \(trips.count) trips")
                
                // Fetch monthly statistics
                let stats = try await KoolingSDKManager.shared.getStatistics(for: .month)
                print("Monthly stats: \(stats.count) entries")
                
                // Update UI on main thread
                DispatchQueue.main.async {
                    self.updateUI(with: trips, stats: stats)
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    private func updateUI(with trips: [TripPreview], stats: [GeneralStatistics]) {
        // Update your UI here
    }
}
```

## Best Practices

1. **Always configure the SDK** before using any tracking functions
2. **Handle permissions gracefully** - provide fallback UI if permissions are denied
3. **Use async/await** for all network operations
4. **Implement proper error handling** for all SDK calls
5. **Test on real devices** - location tracking doesn't work in simulators
6. **Monitor battery usage** - inform users about background location usage
7. **Respect user privacy** - clearly explain why location data is needed

## Troubleshooting

### Common Issues

1. **SDK not configured error**
   - Make sure to call `configure()` before any other SDK methods

2. **Location permissions denied**
   - Check Info.plist permissions are properly set
   - Guide users to Settings to enable location access
   - Ensure NSLocationTemporaryUsageDescriptionDictionary is properly configured

3. **Tracking not working**
   - Ensure device location services are enabled
   - Check that app has proper background location permissions
   - Verify all background modes are enabled (fetch, bluetooth-central, location)

4. **Network errors**
   - Verify access token is valid
   - Check network connectivity
   - Ensure correct environment is selected

5. **Framework linking errors**
   - Ensure both KoolingSDK.xcframework and Alamofire.xcframework are set to "Do Not Embed"
   - Check that frameworks are properly added to "Frameworks, Libraries, and Embedded Content"
   - Clean build folder (Cmd+Shift+K) and rebuild if needed

6. **Duplicate symbol errors**
   - Make sure frameworks are set to "Do Not Embed"
   - Remove any manually embedded Alamofire if you have it elsewhere in project

7. **Deployment target errors**
   - Ensure your app's iOS Deployment Target is set to 15.0 or higher
   - Check that all targets in your project have consistent deployment targets
   - KoolingSDK requires minimum iOS 15.0

### Debug Mode

Enable debug logging during development:

```swift
// Enable debug logging (if available)
KoolingSDKManager.shared.enableDebugLogging = true
```

### Checking Permissions in Code

You can check permission status programmatically:

```swift
import CoreLocation
import HealthKit

// Check Location Permission
let locationStatus = CLLocationManager().authorizationStatus
switch locationStatus {
case .authorizedAlways, .authorizedWhenInUse:
    print("Location permission granted")
case .denied, .restricted:
    print("Location permission denied")
case .notDetermined:
    print("Location permission not determined")
@unknown default:
    print("Unknown location permission status")
}

// Check Health Permission
let healthStore = HKHealthStore()
let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
let healthStatus = healthStore.authorizationStatus(for: stepType)
switch healthStatus {
case .sharingAuthorized:
    print("Health permission granted")
case .sharingDenied:
    print("Health permission denied")
case .notDetermined:
    print("Health permission not determined")
@unknown default:
    print("Unknown health permission status")
}
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please contact:
- Email: support@kooling.net
- Documentation: https://docs.kooling.net
- GitHub Issues: https://github.com/your-org/KoolingSDK/issues 
