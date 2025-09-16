// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public actor APIManager {
    public static let shared = APIManager()
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    public init(session: URLSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    private init() {
        self.session = URLSession.shared
        self.decoder = JSONDecoder()
    }
    
    private func checkNetworkConnectivity() async throws {
        if #available(iOS 12.0, macOS 10.14, watchOS 5.0, tvOS 12.0, *) {
            let isConnected = await NetworkReachability.shared.checkConnectivity()
            guard isConnected else {
                throw APIError.networkUnavailable
            }
        }
    }
    
    public func request<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T {
        try await checkNetworkConnectivity()
        
        guard let url = endpoint.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.timeoutInterval = endpoint.timeoutInterval ?? 30.0
        endpoint.headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
    
    public func requestVoid(_ endpoint: Endpoint) async throws {
        try await checkNetworkConnectivity()
        
        guard let url = endpoint.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.timeoutInterval = endpoint.timeoutInterval ?? 30.0
        endpoint.headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }
    }
    
    public func requestData(_ endpoint: Endpoint) async throws -> Data {
        try await checkNetworkConnectivity()
        
        guard let url = endpoint.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.timeoutInterval = endpoint.timeoutInterval ?? 30.0
        endpoint.headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }
        
        return data
    }
    
    public func requestWithMetadata<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> APIResponse<T> {
        try await checkNetworkConnectivity()
        
        guard let url = endpoint.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.timeoutInterval = endpoint.timeoutInterval ?? 30.0
        endpoint.headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            let headers = Dictionary<String, String>(uniqueKeysWithValues: httpResponse.allHeaderFields.compactMap { key, value in
                guard let keyString = key as? String, let valueString = value as? String else { return nil }
                return (keyString, valueString)
            })
            
            return APIResponse(
                data: decodedData,
                statusCode: httpResponse.statusCode,
                headers: headers,
                url: httpResponse.url
            )
        } catch {
            throw APIError.decodingError
        }
    }
    
    public func requestVoidWithMetadata(_ endpoint: Endpoint) async throws -> APIResponseMetadata {
        try await checkNetworkConnectivity()
        
        guard let url = endpoint.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.timeoutInterval = endpoint.timeoutInterval ?? 30.0
        endpoint.headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }
        
        let headers = Dictionary<String, String>(uniqueKeysWithValues: httpResponse.allHeaderFields.compactMap { key, value in
            guard let keyString = key as? String, let valueString = value as? String else { return nil }
            return (keyString, valueString)
        })
        
        return APIResponseMetadata(
            statusCode: httpResponse.statusCode,
            headers: headers,
            url: httpResponse.url
        )
    }
    
    public func requestWithRetry<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T {
        let config = endpoint.retryConfiguration ?? RetryConfiguration.default
        var lastError: Error?
        
        for attempt in 0...config.maxRetries {
            do {
                return try await request(endpoint, as: type)
            } catch APIError.serverError(let statusCode) {
                lastError = APIError.serverError(statusCode: statusCode)
                if !config.retryableStatusCodes.contains(statusCode) || attempt == config.maxRetries {
                    throw APIError.serverError(statusCode: statusCode)
                }
            } catch {
                lastError = error
                if attempt == config.maxRetries {
                    throw error
                }
            }
            
            if attempt < config.maxRetries {
                let delay = min(config.baseDelay * pow(config.multiplier, Double(attempt)), config.maxDelay)
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        }
        
        throw lastError ?? APIError.unknown(NSError(domain: "APIManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"]))
    }
    
    public func requestVoidWithRetry(_ endpoint: Endpoint) async throws {
        let config = endpoint.retryConfiguration ?? RetryConfiguration.default
        var lastError: Error?
        
        for attempt in 0...config.maxRetries {
            do {
                try await requestVoid(endpoint)
                return
            } catch APIError.serverError(let statusCode) {
                lastError = APIError.serverError(statusCode: statusCode)
                if !config.retryableStatusCodes.contains(statusCode) || attempt == config.maxRetries {
                    throw APIError.serverError(statusCode: statusCode)
                }
            } catch {
                lastError = error
                if attempt == config.maxRetries {
                    throw error
                }
            }
            
            if attempt < config.maxRetries {
                let delay = min(config.baseDelay * pow(config.multiplier, Double(attempt)), config.maxDelay)
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        }
        
        throw lastError ?? APIError.unknown(NSError(domain: "APIManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"]))
    }
    
    public func uploadFile(_ endpoint: FileUploadEndpoint) async throws -> Data {
        try await checkNetworkConnectivity()
        
        guard let url = endpoint.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = endpoint.timeoutInterval ?? 30.0
        
        // Create multipart form data
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add file data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(endpoint.fileUpload.fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(endpoint.fileUpload.mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(endpoint.fileUpload.data)
        body.append("\r\n".data(using: .utf8)!)
        
        // Add additional fields
        if let additionalFields = endpoint.additionalFields {
            for (key, value) in additionalFields {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(value)\r\n".data(using: .utf8)!)
            }
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        // Add additional headers
        endpoint.headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }
        
        return data
    }
    
    public func downloadFile(_ endpoint: Endpoint, to destinationURL: URL) async throws -> URL {
        try await checkNetworkConnectivity()
        
        guard let url = endpoint.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = endpoint.timeoutInterval ?? 30.0
        endpoint.headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }
        
        try data.write(to: destinationURL)
        return destinationURL
    }
}
