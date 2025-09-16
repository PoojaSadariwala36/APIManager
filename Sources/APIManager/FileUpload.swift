//
//  FileUpload.swift
//  APIManager
//
//  Created by Pooja Sadariwala on 15/09/25.
//

import Foundation

public struct FileUpload {
    public let data: Data
    public let fileName: String
    public let mimeType: String
    
    public init(data: Data, fileName: String, mimeType: String) {
        self.data = data
        self.fileName = fileName
        self.mimeType = mimeType
    }
    
    public init(url: URL, fileName: String? = nil, mimeType: String? = nil) throws {
        self.data = try Data(contentsOf: url)
        self.fileName = fileName ?? url.lastPathComponent
        self.mimeType = mimeType ?? url.mimeType
    }
}

public extension URL {
    var mimeType: String {
        let pathExtension = self.pathExtension.lowercased()
        switch pathExtension {
        case "jpg", "jpeg":
            return "image/jpeg"
        case "png":
            return "image/png"
        case "gif":
            return "image/gif"
        case "pdf":
            return "application/pdf"
        case "txt":
            return "text/plain"
        case "json":
            return "application/json"
        case "xml":
            return "application/xml"
        case "zip":
            return "application/zip"
        default:
            return "application/octet-stream"
        }
    }
}

public protocol FileUploadEndpoint: Endpoint {
    var fileUpload: FileUpload { get }
    var additionalFields: [String: String]? { get }
}
