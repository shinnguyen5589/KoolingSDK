# KoolingSDK

A lightweight iOS SDK for location tracking and activity monitoring. Perfect for apps that need to track user trips and provide analytics.

## 📋 Requirements

- iOS 15.0+
- Swift 5.0+
- Xcode 13.0+

## 📦 Installation

### Swift Package Manager

Add KoolingSDK to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/shinnguyen5589/KoolingSDK.git", from: "1.0.4")
]
```

Or add it directly in Xcode:
1. File → Add Package Dependencies
2. Enter URL: `https://github.com/shinnguyen5589/KoolingSDK.git`
3. Select version: `1.0.4` or later
4. Add to your target

## 🔧 Setup

### Required Permissions (Info.plist)

Add the following permissions to your **Info.plist** file to ensure the SDK works correctly:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>bluetooth-central</string>
    <string>location</string>
</array>
<key>NSLocationTemporaryUsageDescriptionDictionary</key>
<dict>
    <key>LocationAccuracyAuthorizationDescription</key>
    <string>Please enable precise location. Turn-by-turn directions only work when precise location data is available.</string>
</dict>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Please accept location permission to use app location functionality</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Please accept location permission to use app location functionality</string>
<key>Privacy - Location Always and When In Use Usage Description</key>
<string>Please accept location permission to use app location functionality</string>
<key>NSHealthShareUsageDescription</key>
<string>This app uses HealthKit to determine walking and running distances</string>
<key>NSBluetoothAlwaysUsageDescription</key>
<string>This app uses Bluetooth to connect to nearby devices</string>
```

**Explanation:**
- `<key>UIBackgroundModes</key>`: Enables background fetch, Bluetooth, and location updates while the app is in the background.
- `<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>`, `<key>NSLocationWhenInUseUsageDescription</key>`, `<key>Privacy - Location Always and When In Use Usage Description</key>`: Required for requesting location permissions from the user.
- `<key>NSLocationTemporaryUsageDescriptionDictionary</key>`: (iOS 14+) Explains why precise location is needed.
- `<key>NSHealthShareUsageDescription</key>`: Required if your app uses HealthKit features (step/distance tracking).
- `<key>NSBluetoothAlwaysUsageDescription</key>`: Required if your app uses Bluetooth LE features.

> **Note:** These permissions are **mandatory** for the SDK to function properly. If any are missing, location tracking or activity monitoring may not work as expected.

### Required Capabilities

In your Xcode project, go to **Signing & Capabilities** and add the following:

- **Background Modes**: Enable
  - [x] Background fetch
  - [x] Location updates
  - [x] Uses Bluetooth LE accessories
- **HealthKit**: Enable
  - [x] HealthKit Background Delivery

> See the screenshot below for reference:
>
> ![Xcode Capabilities Example](docs/background-modes-healthkit.png)

---

## 🚀 Quick Start

### 1. Import the SDK

```swift
import KoolingSDK
```

### 2. Configure in AppDelegate

```swift
import KoolingSDK

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // Configure environment (optional - defaults to staging)
    #if DEBUG
        KoolingSDKManager.shared.configure(environment: .staging)
    #else
        KoolingSDKManager.shared.configure(environment: .production)
    #endif
    
    // Setup logging (optional)
    KoolingSDKManager.shared.setupLog { level, message in
        print("[KoolingSDK] \(level): \(message)")
    }
    
    return true
}
```

### 3. Start tracking

```swift
// In your view controller
KoolingSDKManager.shared.startTracking(
    token: "user_access_token",
    viewController: self
) {
    // Tracking started successfully
    print("✅ Location tracking active")
}
```

### 4. Check status

```swift
if KoolingSDKManager.shared.isTracking {
    // Show "Stop" button
} else {
    // Show "Start" button
}
```

## 📱 Features

- **Background Location Tracking** - Works even when app is closed
- **Activity Monitoring** - Detects walking, driving, cycling
- **Automatic Permissions** - Handles location permission requests
- **Network Integration** - Built-in API client with authentication
- **Debug Tools** - Built-in logging and debug UI

## 🔧 API Reference

### Core Methods

| Method | Description |
|--------|-------------|
| `configure(environment:)` | Set SDK environment (staging/production) |
| `startTracking(token:viewController:completion:)` | Start location tracking |
| `stopTracking(completion:)` | Stop location tracking |
| `isTracking` | Check if tracking is active |
| `buildNetworkClient()` | Create network client with current config |

### Configuration

| Property | Description |
|----------|-------------|
| `baseUrlString` | Get current base URL for API requests |
| `shared` | Singleton instance |

### Network Types

| Type | Description |
|------|-------------|
| `KoolingNetworkClient` | Protocol for making API requests |
| `KoolingNetworkRequest<E>` | Request model with parameters |
| `KoolingNetworkError` | Network error types |
| `EmptyParameters` | Empty request body |
| `KoolingHttpMethod` | HTTP methods (get, post, put, delete, patch) |
| `TokenProvider` | Protocol for providing authentication tokens |
| `HttpHeader` | HTTP header constants |

> **Note**: Default environment is staging. Configure production environment in release builds.

## 💡 Usage Examples

### Basic Tracking

```swift
import KoolingSDK

class TrackingViewController: UIViewController {
    
    @IBAction func startTrackingTapped(_ sender: UIButton) {
        KoolingSDKManager.shared.startTracking(
            token: "REPLACE_ME_WITH_PROVIDED_DEMO_TOKEN",
            viewController: self
        ) {
            sender.setTitle("Stop Tracking", for: .normal)
        }
    }
    
    @IBAction func stopTrackingTapped(_ sender: UIButton) {
        KoolingSDKManager.shared.stopTracking {
            sender.setTitle("Start Tracking", for: .normal)
        }
    }
}
```

### Building Your API Layer

The SDK provides a clean architecture for making API calls. Here's how to structure your API classes following the same pattern used in the main app:

#### Network Client Helper

Create a helper function to build your network client with proper configuration:

```swift
import Foundation
import KoolingSDK
import Alamofire

func buildNetworkClient() -> KoolingNetworkClient {
    // Configure JSON encoding/decoding with snake_case conversion
    let jsonEncoder = JSONEncoder()
    jsonEncoder.keyEncodingStrategy = .convertToSnakeCase

    let jsonDecoder = JSONDecoder()
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

    // Configure query parameters encoding
    let queryParameters = URLEncodedFormParameterEncoder(
        encoder: URLEncodedFormEncoder(
            arrayEncoding: .noBrackets,
            boolEncoding: .literal,
            keyEncoding: .convertToSnakeCase
        ),
        destination: .queryString
    )

    // Create and return the network client
    return KoolingNetworkClientImplementation(
        baseUrlString: KoolingSDKManager.shared.baseUrlString,
        eventMonitors: [UnauthorisedUserEventMonitor()],
        jsonEncoder: jsonEncoder,
        jsonDecoder: jsonDecoder,
        parameterEncoder: queryParameters
    )
}
```

**What this does:**
- **JSON Encoding**: Converts Swift camelCase to snake_case for API requests
- **JSON Decoding**: Converts API snake_case responses to Swift camelCase
- **Query Parameters**: Properly encodes URL query parameters
- **Base URL**: Uses the configured environment (staging/production)
- **Event Monitors**: Handles unauthorized access automatically

> **Note**: You'll need to create an `UnauthorisedUserEventMonitor` class to handle 401 responses. This can be as simple as navigating to your login screen when authentication fails.

#### TripsApi Class

Create a class to handle all trip-related API calls:

```swift
import Foundation
import KoolingSDK

class TripsApi {
    // Define your API endpoints
    private let path = "/ios/trips"
    private func path(_ tripId: String) -> String {
        "\(path)/\(tripId)"
    }

    // Use the SDK's network client
    private let networkClient: KoolingNetworkClient = buildNetworkClient()

    // Define query parameters for filtering and pagination
    struct Query: Encodable {
        private(set) var transportationmode: Int? = nil    // Filter by transport mode (1=car, 2=bus, etc.)
        private(set) var vehicletype: String? = nil        // Filter by vehicle type (car, motorcycle, etc.)
        private(set) var fueltype: String? = nil           // Filter by fuel type (petrol, diesel, electric, etc.)
        private(set) var week: Int? = nil                  // Filter by week number (1-52)
        private(set) var month: Int? = nil                 // Filter by month (1-12)
        private(set) var year: Int? = nil                  // Filter by year (e.g., 2024)
        private(set) var perPage: Int? = nil               // Number of items per page for pagination
        private(set) var cursor: String? = nil             // Cursor for pagination (next page token)
    }

    // Get paginated list of trips with filtering options
    // Returns: PagedResponse<TripPreview> with trips data and pagination info
    func getTrips(query: Query) async throws -> PagedResponse<TripPreview> {
        try await networkClient.sendAuthenticated(
            KoolingNetworkRequest(
                endpoint: path,
                method: .get,
                parameters: query
            )
        )
    }

    // Get detailed information about a specific trip
    // Parameters: tripId - The unique identifier of the trip
    // Returns: Response<Trip> with complete trip details
    func getTrip(tripId: String) async throws -> Response<Trip> {
        try await networkClient.sendAuthenticated(
            KoolingNetworkRequest(
                endpoint: path(tripId),
                method: .get,
                parameters: Optional<String>.none
            )
        )
    }

    // Data structure for updating trip information
    struct UpdateTrip : Encodable {
        let transportationmode: Int    // Transport mode (1=car, 2=bus, etc.)
        let fueltype: String?          // Fuel type (petrol, diesel, electric, etc.)
    }

    // Update trip details (transport mode and fuel type)
    // Parameters: tripId - Trip to update, body - New trip data
    // Returns: Response<Trip> with updated trip information
    func updateTrip(tripId: String, body: UpdateTrip) async throws -> Response<Trip> {
        try await networkClient.sendAuthenticated(
            KoolingNetworkRequest(
                endpoint: path(tripId),
                method: .put,
                parameters: body
            )
        )
    }
}

// Helper extensions for building queries
extension TripsApi.Query {
    init(pageSize: Int) {
        perPage = pageSize
    }

    func filter(by vehicle: Vehicle) -> TripsApi.Query {
        var other = self
        other.transportationmode = vehicle.transportationmode <= 0 ? nil : vehicle.transportationmode
        other.fueltype = vehicle.fueltype.isEmpty ? nil : vehicle.fueltype
        return other
    }

    func filter(week: Int? = nil, month: Int? = nil, year: Int? = nil) -> TripsApi.Query {
        var other = self
        other.year = year
        other.month = month
        other.week = week
        return other
    }

    func with(cursor: String?) -> TripsApi.Query {
        var other = self
        other.cursor = cursor
        return other
    }
}
```

#### StatisticsApi Class

Create a class to handle statistics API calls:

```swift
import Foundation
import KoolingSDK

class StatisticsApi {
    private func path(_ path: String) -> String {
        "/ios/statistics/\(path)"
    }

    private let networkClient: KoolingNetworkClient = buildNetworkClient()

    // Get general statistics for different time periods
    // Parameters: filter - .month (current month), .year (current year), .all (all time)
    // Returns: Response<[GeneralStatistics]> with aggregated statistics
    func getGeneralStatistics(for filter: GeneralStatistics.Filter) async throws -> Response<[GeneralStatistics]> {
        struct Query: Encodable {
            let year: Int?    // Year for filtering (e.g., 2024)
            let month: Int?   // Month for filtering (1-12)
        }

        // Get current date components for automatic filtering
        let componentes = Calendar.shared.dateComponents([.year, .month, .weekOfYear], from: Date.now)
        let query = switch filter {
        case .month:
            Query(year: componentes.year, month: componentes.month)  // Current month
        case .year:
            Query(year: componentes.year, month: nil)                 // Current year
        case .all:
            Query(year: nil, month: nil)                              // All time
        }

        return try await networkClient.sendAuthenticated(
            KoolingNetworkRequest(
                endpoint: path("general"),
                method: .get,
                parameters: query
            )
        )
    }

    // Get yearly statistics with detailed breakdown
    // Parameters: year - The year to get statistics for
    // Returns: Response<[DistanceTimeStatistics]> with yearly data
    func getStatistics(year: Int) async throws -> Response<[DistanceTimeStatistics]> {
        try await getStatistics(path: path("trips-by-year/\(year)"))
    }

    // Get monthly statistics for a specific year
    // Parameters: year - The year, month - The month (1-12)
    // Returns: Response<[DistanceTimeStatistics]> with monthly data
    func getStatistics(year: Int, month: Int) async throws -> Response<[DistanceTimeStatistics]> {
        try await getStatistics(path: path("trips-by-month/\(year)/\(month)"))
    }

    // Get weekly statistics for a specific year
    // Parameters: year - The year, week - The week number (1-52)
    // Returns: Response<[DistanceTimeStatistics]> with weekly data
    func getStatistics(year: Int, week: Int) async throws -> Response<[DistanceTimeStatistics]> {
        try await getStatistics(path: path("trips-by-week/\(year)/\(week)"))
    }

    // Private helper method to avoid code duplication
    // Generic method that handles the actual API call for all statistics endpoints
    private func getStatistics<T: Decodable>(path: String) async throws -> Response<[T]> {
        try await networkClient.sendAuthenticated(
            KoolingNetworkRequest(
                endpoint: path,
                method: .get,
                parameters: Optional<String>.none
            )
        )
    }
}
```

#### KoolingApi Class

Create a class to handle user profile and authentication:

```swift
import Foundation
import KoolingSDK

class KoolingApi {
    private let networkClient: KoolingNetworkClient = buildNetworkClient()

    // Authenticate user with email and password
    // Parameters: data - LoginRequestModel with email and password
    // Returns: LoginResponse with access token and user info
    // Note: This endpoint doesn't require authentication
    func login(data: LoginRequestModel) async throws -> LoginResponse {
        try await networkClient.send(
            KoolingNetworkRequest(
                endpoint: "/login",
                method: .post,
                parameters: data
            )
        )
    }

    // Get current user's profile information
    // Returns: Response<User> with user details (name, email, settings, etc.)
    // Note: Requires valid authentication token
    func profile() async throws -> Response<User> {
        try await networkClient.sendAuthenticated(
            KoolingNetworkRequest(
                endpoint: "/profile",
                method: .get,
                parameters: Optional<String>.none
            )
        )
    }

    // Enable or disable enhanced tracking mode
    // Parameters: enabled - true to enable enhanced mode, false to disable
    // Returns: Response<User> with updated user profile
    // Note: Enhanced mode provides more detailed tracking data
    func setEnhanceMode(enabled: Bool) async throws -> Response<User> {
        struct User: Encodable {
            struct Account: Encodable {
                let isEnhance: Bool    // Enhanced tracking setting
            }

            let account: Account
            init(enabled: Bool) {
                account = Account(isEnhance: enabled)
            }
        }

        return try await networkClient.sendAuthenticated(
            KoolingNetworkRequest(
                endpoint: "/profile",
                method: .put,
                parameters: User(enabled: enabled)
            )
        )
    }

    // Get list of user's connected Bluetooth devices
    // Returns: Response<[BlueTooth]> with device information
    // Note: Used for enhanced tracking with external sensors
    func bluetooth() async throws -> Response<[BlueTooth]> {
        try await networkClient.sendAuthenticated(
            KoolingNetworkRequest(
                endpoint: "/bluetooth",
                method: .get,
                parameters: Optional<String>.none
            )
        )
    }
}
```

### Key Points to Remember

1. **Always use `buildNetworkClient()`** - This creates a properly configured network client with JSON encoding/decoding and proper error handling
2. **Use `sendAuthenticated()`** for protected endpoints that require user authentication
3. **Use `send()`** for public endpoints like login
4. **Handle errors properly** with try-catch blocks
5. **Use the Query structs** for filtering and pagination
6. **Follow the same pattern** for consistency across your app
7. **Create UnauthorisedUserEventMonitor** to handle 401 responses gracefully

### Error Handling

```swift
do {
    let trips = try await tripsApi.getTrips(querry: querry)
    // Handle success
} catch let error as KoolingNetworkError {
    switch error {
    case .noInternetConnection:
        showAlert("Please check your internet connection")
    case .unauthorized:
        // Handle login required
        navigateToLogin()
    case .apiError(let code, let message):
        showAlert("Error \(code): \(message ?? "Unknown error")")
    default:
        showAlert(error.errorDescription ?? "Something went wrong")
    }
}
```

### Logging Integration

```swift
// Setup custom logging
KoolingSDKManager.shared.setupLog { level, message in
    // Integrate with your logging system
    switch level {
    case "ERROR":
        Crashlytics.log("KoolingSDK Error: \(message)")
    case "WARNING":
        Analytics.log("KoolingSDK Warning: \(message)")
    default:
        print("[KoolingSDK] \(level): \(message)")
    }
}

// Log custom events
KoolingSDKManager.shared.log("User started tracking session")
```

## 🐛 Debugging

### Built-in Logger

```swift
#if DEBUG
    // Show debug panel
    KoolingSDKManager.shared.showLoggerUI(rootViewController: self)
#endif
```

### Custom Logging

```swift
// Integrate with your logging system
KoolingSDKManager.shared.setupLog { level, message in
    // Send to your analytics service
    Analytics.log(level: level, message: message, category: "KoolingSDK")
}
```

## ❗ Troubleshooting

### Common Issues

1. **"Cannot find KoolingSDK"**
   - Make sure you've added the package to your target
   - Check that you've imported `KoolingSDK` in your file

2. **Location permissions not working**
   - Verify Info.plist permissions are added correctly
   - Check that Background Modes capability is enabled

3. **Tracking not starting**
   - Ensure you have a valid access token
   - Check that environment is configured properly
   - Verify network connectivity

4. **Build errors**
   - Make sure you're using iOS 15.0+ and Swift 5.0+
   - Check that all required capabilities are enabled

### Debug Steps

```swift
// 1. Check if SDK is properly imported
import KoolingSDK

// 2. Verify environment configuration
print("Base URL: \(KoolingSDKManager.shared.baseUrlString)")

// 3. Check tracking status
print("Is tracking: \(KoolingSDKManager.shared.isTracking)")

// 4. Test network client
let client = buildNetworkClient()
print("Network client created successfully")

// 5. Enable debug logging
KoolingSDKManager.shared.setupLog { level, message in
    print("[DEBUG] \(level): \(message)")
}
```

## 🤝 Support

- **Email**: support@kooling.net
- **Documentation**: [docs.kooling.net](https://docs.kooling.net)
- **Issues**: Create an issue in this repository

## 📄 License

Proprietary software. See your license agreement for terms of use.

---

