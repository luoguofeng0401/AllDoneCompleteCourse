//
//  Error+AsAppError.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/24.
//

import FirebaseAuth
import FirebaseFirestore

extension Error? {
    func asAppError() -> AppError {
        guard let error = self else {
            return AuthError.empty
        }
        
        if let AppError = error as? AppError {
            return AppError
        }
        let nsError = error as NSError
        if nsError.domain == AuthErrorDomain {
            return AuthError.fromFirebaseError(nsError)
        } else if nsError.domain == FirestoreErrorDomain {
            return DatabaseError.fromFirebaseError(nsError)
        }
        return AuthError.unknown(nsError)
    }
}
