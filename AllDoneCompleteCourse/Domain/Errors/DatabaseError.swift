//
//  DatabaseError.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/24.
//

import Foundation
import FirebaseFirestore

enum DatabaseError: LocalizedError {
    case missingField
    case documentDoesNotFound
    case permissionDenised
    case networkError
    case unknown(Error)
}

extension DatabaseError: AppError {
    var title: String {
        "Todo Error"
    }
    
    var message: String {
        return switch self {
        case .missingField:
            "Some required fields are missing. Please complete all fields and try again."
        case .documentDoesNotFound:
            "The required todo item was not found."
        case .permissionDenised:
            "You do not have  permission to perform this action."
        case .networkError:
            "A network error occurred while trying to access your todos. Check your connection and try again."
        case .unknown(let error):
            error.localizedDescription
        }
    }
}

extension DatabaseError {
    static func fromFirebaseError(_ error: NSError) -> AppError {
        let errorCode = FirestoreErrorCode.Code(rawValue: error.code)
        return switch errorCode {
        case .notFound:
            DatabaseError.documentDoesNotFound
        case .permissionDenied:
            DatabaseError.permissionDenised
        case .unavailable, .deadlineExceeded:
            DatabaseError.networkError
        default:
            DatabaseError.unknown(error)
        }
    }
}


