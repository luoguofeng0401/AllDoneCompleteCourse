//
//  AuthError.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/24.
//

import Foundation
import FirebaseAuth

enum AuthError: LocalizedError {
    case invalidCredentials
    case missingFields
    case userNotFound
    case emailAlreadyInUse
    case weakPassword
    case tooManyRequests
    case networkError
    case empty
    case unknown(Error)
}

extension AuthError: AppError {
    var title: String {
        "Authentication Error"
    }
    
    var message: String {
        return switch self {
        case .invalidCredentials:
            "Invalid email or password. Please try again."
        case .missingFields:
            "All fields must be filled out."
        case .userNotFound:
            "No account found for this mail."
        case .emailAlreadyInUse:
            "This email is already in use"
        case .weakPassword:
            "Your password is too weak. Try a stronger one."
        case .tooManyRequests:
            "You've made too many attempts. Please wait and try again later."
        case .networkError:
            "A network error occurred.  Check tour connection and try again."
        case .empty:
                .empty
        case .unknown(let error):
            error.localizedDescription
        }
    }
}

extension AuthError {
    static func fromFirebaseError(_ error: NSError) -> AppError {
        guard let errorCode = AuthErrorCode(rawValue: error.code) else {
            return AuthError.unknown(error)
        }
        return switch errorCode {
        case .wrongPassword, .invalidEmail:
            AuthError.invalidCredentials
        case .userNotFound:
            AuthError.userNotFound
        case .emailAlreadyInUse:
            AuthError.emailAlreadyInUse
        case .weakPassword:
            AuthError.weakPassword
        case .tooManyRequests:
            AuthError.tooManyRequests
        case .networkError:
            AuthError.networkError
        default:
            AuthError.unknown(error)
        }
    }
}

extension AuthError {
    static var mock: Error {
        Self.invalidCredentials
    }
}
