//
//  NetworkError.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//
import SwiftUI

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingError
    case unAuthorized
    
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid Responce From Server"
        case .serverError(let code):
            return "Server Error: \(code)"
        case .decodingError:
            return "Json Decode Error"
        case .unAuthorized:
            return "User not found"
        }
    }
}
