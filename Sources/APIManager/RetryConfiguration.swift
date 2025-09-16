//
//  RetryConfiguration.swift
//  APIManager
//
//  Created by Pooja Sadariwala on 15/09/25.
//

import Foundation

public struct RetryConfiguration {
    public let maxRetries: Int
    public let baseDelay: TimeInterval
    public let maxDelay: TimeInterval
    public let multiplier: Double
    public let retryableStatusCodes: Set<Int>
    
    public init(
        maxRetries: Int = 3,
        baseDelay: TimeInterval = 1.0,
        maxDelay: TimeInterval = 60.0,
        multiplier: Double = 2.0,
        retryableStatusCodes: Set<Int> = [408, 429, 500, 502, 503, 504]
    ) {
        self.maxRetries = maxRetries
        self.baseDelay = baseDelay
        self.maxDelay = maxDelay
        self.multiplier = multiplier
        self.retryableStatusCodes = retryableStatusCodes
    }
    
    public static let `default` = RetryConfiguration()
}

public extension Endpoint {
    var retryConfiguration: RetryConfiguration? { nil }
}
