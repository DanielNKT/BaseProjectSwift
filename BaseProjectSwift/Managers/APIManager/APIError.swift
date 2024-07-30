//
//  APIError.swift
//  BaseProjectSwift
//
//  Created by Bé Gạo on 21/4/24.
//

import Foundation

enum APIError: Error, RawRepresentable {
    case custom(message: String, detail: String? = nil, code: Int = -1)
    case unexpected
    case invalidJSON
    case invalidUrl
    case unauthorized
    case timeout
    case notExist
    case notAvailable
    case empty
    
    var errorDescription: String {
        switch self {
        case .custom(let message, let detail, _):
            return [message, detail].compactMap { $0 }.joined(separator: "\n")
        case .unexpected:
            return "Unexpected Error"
        case .invalidJSON:
            return "Invalid JSON"
        case .invalidUrl:
            return "Invalid URL"
        case .unauthorized:
            return "Unauthorized"
        case .timeout: return "The request timed out"
        case .notExist:
            return "Not exist"
        case .notAvailable:
            return "Not available"
        case .empty:
            return ""
        }
    }
    
    var rawValue: Int {
        switch self {
        case .custom(_, _, let code):
            return code
        default:
            return 232
        }
    }
    init?(rawValue: Int) {
        nil
    }
}
