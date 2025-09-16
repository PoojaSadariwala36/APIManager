# APIManager

A lightweight, zero-dependency Swift package for making HTTP requests with URLSession and async/await. Built with modern Swift concurrency and designed for simplicity and performance.

## Features

- 🚀 **Zero Dependencies** - Uses only Foundation and URLSession
- ⚡ **Async/Await Support** - Modern Swift concurrency
- 🔒 **Thread-Safe** - Actor-based design
- 🎯 **Type-Safe** - Generic methods with Codable support
- 🔄 **Retry Mechanism** - Configurable retry with exponential backoff
- 📊 **Response Metadata** - Access to status codes, headers, and URLs
- 📁 **File Upload/Download** - Built-in support for file operations
- ⏱️ **Timeout Configuration** - Per-request timeout settings
- 🌐 **Query Parameters** - Built-in URL query parameter support
- 📡 **Network Reachability** - Automatic network connectivity checking
- 🎨 **Customizable** - Custom URLSession and JSONDecoder support

## Requirements

- iOS 13.0+
- macOS 10.15+
- watchOS 6.0+
- tvOS 13.0+
- Swift 5.5+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/APIManager.git", from: "1.0.0")
]
```

Or add it through Xcode:
1. File → Add Package Dependencies
2. Enter the repository URL
3. Select the version and add to your target

## Quick Start

### Basic Usage

```swift
import APIManager

// Define your endpoint
struct UserEndpoint: Endpoint {
    let userId: Int
    
    var baseURL: String { "https://jsonplaceholder.typicode.com" }
    var path: String { "/users/\(userId)" }
    var method: HTTPMethod { .GET }
    var headers: [String: String]? { ["Content-Type": "application/json"] }
    var body: Data? { nil }
    var queryParameters: [String: String]? { nil }
    var timeoutInterval: TimeInterval? { nil }
}

// Define your model
struct User: Codable {
    let id: Int
    let name: String
    let email: String
    let username: String
}

// Make a request
Task {
    do {
        let user = try await APIManager.shared.request(UserEndpoint(userId: 1), as: User.self)
        print("User: \(user.name)")
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}
```

## Advanced Features

### Custom Configuration

```swift
// Custom URLSession and JSONDecoder
let customSession = URLSession(configuration: .default)
let customDecoder = JSONDecoder()
customDecoder.dateDecodingStrategy = .iso8601

let apiManager = APIManager(
    session: customSession,
    decoder: customDecoder
)
```


### Retry Mechanism

```swift
// Custom retry configuration
struct RetryableEndpoint: Endpoint {
    // ... other properties
    
    var retryConfiguration: RetryConfiguration? {
        RetryConfiguration(
            maxRetries: 3,
            baseDelay: 1.0,
            maxDelay: 60.0,
            multiplier: 2.0,
            retryableStatusCodes: [408, 429, 500, 502, 503, 504]
        )
    }
}

// Use retry methods
let user = try await APIManager.shared.requestWithRetry(RetryableEndpoint(), as: User.self)
```

### Response Metadata

```swift
// Get response with metadata
let response = try await APIManager.shared.requestWithMetadata(UserEndpoint(userId: 1), as: User.self)

print("Status Code: \(response.statusCode)")
print("Headers: \(response.headers)")
print("URL: \(response.url)")
print("Data: \(response.data)")
```

### File Upload

```swift
struct FileUploadEndpoint: FileUploadEndpoint {
    let fileUpload: FileUpload
    let additionalFields: [String: String]?
    
    var baseURL: String { "https://api.example.com" }
    var path: String { "/upload" }
    var method: HTTPMethod { .POST }
    var headers: [String: String]? { nil }
    var body: Data? { nil }
    var queryParameters: [String: String]? { nil }
    var timeoutInterval: TimeInterval? { nil }
}

// Upload a file
let fileData = Data(contentsOf: fileURL)
let fileUpload = FileUpload(data: fileData, fileName: "image.jpg", mimeType: "image/jpeg")

let endpoint = FileUploadEndpoint(
    fileUpload: fileUpload,
    additionalFields: ["description": "Profile picture"]
)

let response = try await APIManager.shared.uploadFile(endpoint)
```

### File Download

```swift
// Download a file
let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
let destinationURL = documentsPath.appendingPathComponent("downloaded-file.jpg")

let downloadedURL = try await APIManager.shared.downloadFile(
    UserEndpoint(userId: 1),
    to: destinationURL
)
```

### Network Reachability

```swift
import APIManager

// Check network connectivity
let isConnected = await NetworkReachability.shared.checkConnectivity()
print("Network connected: \(isConnected)")

// Monitor network status (iOS 12.0+)
@StateObject private var reachability = NetworkReachability.shared

// In SwiftUI
VStack {
    if reachability.isConnected {
        Text("Connected via \(reachability.connectionType)")
    } else {
        Text("No Internet Connection")
    }
}

// Automatic network checking in API calls
do {
    let user = try await APIManager.shared.request(UserEndpoint(userId: 1), as: User.self)
    // This automatically checks network connectivity before making the request
} catch APIError.networkUnavailable {
    print("No network connection available")
}
```

### Query Parameters

```swift
struct UsersListEndpoint: Endpoint {
    let page: Int
    let limit: Int
    
    var baseURL: String { "https://jsonplaceholder.typicode.com" }
    var path: String { "/users" }
    var method: HTTPMethod { .GET }
    var headers: [String: String]? { ["Content-Type": "application/json"] }
    var body: Data? { nil }
    var queryParameters: [String: String]? {
        ["_page": "\(page)", "_limit": "\(limit)"]
    }
    var timeoutInterval: TimeInterval? { nil }
}

// This will create: https://jsonplaceholder.typicode.com/users?_page=1&_limit=10
let users = try await APIManager.shared.request(UsersListEndpoint(page: 1, limit: 10), as: [User].self)
```

### POST Request with Body

```swift
struct CreateUserRequest: Encodable {
    let name: String
    let email: String
}

struct CreateUserEndpoint: Endpoint {
    let requestBody: CreateUserRequest
    
    var baseURL: String { "https://jsonplaceholder.typicode.com" }
    var path: String { "/users" }
    var method: HTTPMethod { .POST }
    var headers: [String: String]? { ["Content-Type": "application/json"] }
    var body: Data? { requestBody.toJSONData() }
    var queryParameters: [String: String]? { nil }
    var timeoutInterval: TimeInterval? { nil }
}

let newUser = CreateUserRequest(name: "John Doe", email: "john@example.com")
let createdUser = try await APIManager.shared.request(CreateUserEndpoint(requestBody: newUser), as: User.self)
```

## Error Handling

The package provides comprehensive error handling through the `APIError` enum:

```swift
public enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(statusCode: Int)
    case networkUnavailable
    case unknown(Error)
}
```

```swift
do {
    let user = try await APIManager.shared.request(UserEndpoint(userId: 1), as: User.self)
} catch APIError.networkUnavailable {
    print("No network connection available")
} catch APIError.serverError(let statusCode) {
    print("Server error with status code: \(statusCode)")
} catch APIError.decodingError {
    print("Failed to decode response")
} catch {
    print("Other error: \(error.localizedDescription)")
}
```

## HTTP Methods

The package supports all standard HTTP methods:

```swift
public enum HTTPMethod: String {
    case GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS
}
```

## Thread Safety

APIManager is implemented as an actor, making it thread-safe by default. You can safely call its methods from any thread without additional synchronization.

## Performance

- **Zero Dependencies**: No external dependencies means faster build times and smaller app size
- **Actor-based**: Leverages Swift's actor system for safe concurrency
- **URLSession**: Built on Apple's optimized URLSession for maximum performance
- **Memory Efficient**: Minimal memory footprint with efficient data handling

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

If you encounter any issues or have questions, please open an issue on GitHub.

---

Made with ❤️ for the Swift community
