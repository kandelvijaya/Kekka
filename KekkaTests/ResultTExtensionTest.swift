//
//  ResultTExtensionTest.swift
//  KekkaTests
//
//  Created by Vijaya Prakash Kandel on 21.10.18.
//  Copyright © 2018 com.kandelvijaya. All rights reserved.
//

import XCTest
@testable import Kekka

final class ResultTExtensionTests: XCTestCase {

    enum TError: Error {
        case someError
    }

    //MARK:- value? error? extraction

    func test_whenResultHasValue_thenItCanBeExtracted() {
        XCTAssertEqual(Result<Int>.success(12).value, .some(12))
    }

    func test_whenResultHasValue_thenErrorCannotBeExtracted() {
        XCTAssertNil(Result<Int>.success(12).error)
    }

    func test_whenResultHasError_thenValueCannotBeExtracted() {
        XCTAssertNil(Result<Int>.failure(TError.someError).value)
    }

    func test_whenResultHasError_thenValueCanBeExtracted() {
        let extractedError = Result<Int>.failure(TError.someError).error
        let eventualType = extractedError as? TError
        XCTAssertEqual(eventualType, TError.someError)
    }

    // MARK:- succeeded / failed extraction

    func test_whenResultHasValue_thenItSucceeded() {
        XCTAssertTrue(Result<Int>.success(12).succeeded)
    }

    func test_whenResultHasValue_thenItIsNotFailed() {
        XCTAssertFalse(Result<Int>.success(12).failed)
    }

    func test_whenResultHasError_thenItIsFailed() {
        XCTAssertTrue(Result<Int>.failure(TError.someError).failed)
    }

    func test_whenResultHasError_thenItIsNotSucceeded() {
        XCTAssertFalse(Result<Int>.failure(TError.someError).succeeded)
    }

    // MARK:- Creation of result from Error types

    func test_errorCanBe_turnedIntoResult() {
        let intResultError: Result<Int> = TError.someError.result()
        XCTAssertEqual(intResultError.error as? TError, TError.someError)
    }

    // MARK:- Mapping on error

    func test_whenResultHasError_thenMapErrorTransforms() {
        enum SomeOtherError: Error {
            case other(from: String)
        }

        let mappedError = Result<Int>.failure(TError.someError).mapError { SomeOtherError.other(from: String(describing: $0)) }

        let gotError = mappedError.error as? SomeOtherError
        let expectedError = SomeOtherError.other(from: String(describing: TError.someError))

        XCTAssertNotNil(gotError)
        XCTAssertTrue(gotError!.isEqual(to: expectedError))
    }

    func test_whenResultHasValue_thenMapErrorDoesnotTransform() {
        enum SomeOtherError: Error {
            case other(from: String)
        }

        let mappedError = Result<Int>.success(12).mapError {
            SomeOtherError.other(from: String(describing: $0))
        }

        XCTAssertEqual(mappedError.value, 12)
        XCTAssertFalse(mappedError.failed)
    }

}
