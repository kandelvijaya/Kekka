//
//  Result.swift
//  Kekka
//
//  Created by Vijaya Prakash Kandel on 08.01.18.
//  Copyright © 2018 com.kandelvijaya. All rights reserved.
//

import Foundation

public typealias KResult<T> = Result<T>

/**
 Encapsulates contextual computation (computations that can fail or succeed, i.e async task, divsion by 0, etc).
 This is equivalent to the `Optional<T>` standard type but with added failure context. The client might
 want to notify user what went wrong or decide to do something else depending on various error.
 */
public enum Result<T> {

    case success(value: T)
    case failure(error: Error)

}

public extension Result {

    /**
     Takes a contextual (might fail) transform `T -> Result<U>` where T is the internal
     item type when current Result represents success.
     - parameter transform: `T -> Result<U>`
     - returns: `Result<U>`. If current Result has error case, then we return as is.
     */
    public func flatMap<U>(_ transform: (T) -> Result<U>) -> Result<U> {
        let transformed = map(transform)
        return flatten(transformed)
    }

    /**
     Takes a normal transform `T -> U` where T is the internal item type when current Result
     represent success.
     - parameter transform: `T -> U`
     - returns: `Result<U>` with the transformed value if current Result represents success.
     Else, it returns the failure as is.
     */
    public func map<U>(_ transform: (T) -> U) -> Result<U> {
        switch self {
        case let .success(v):
            return .success(value: transform(v))
        case let .failure(e):
            return .failure(error: e)
        }
    }

    private func flatten<A>(_ input: Result<Result<A>>) -> Result<A> {
        switch input {
        case let .success(v):
            return v
        case let .failure(e):
            return .failure(error: e)
        }
    }

}

