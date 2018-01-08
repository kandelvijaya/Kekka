//
//  ResultTests.swift
//  KekkaTests
//
//  Created by Vijaya Prakash Kandel on 08.01.18.
//  Copyright © 2018 com.kandelvijaya. All rights reserved.
//

import XCTest
@testable import Kekka

final class ResultTTests: XCTestCase {

    enum IntError: Error {
        case testError
        case cannotDivideByZero
    }

    private func divBy0(_ a: Int) -> Result<Int> {
        return .failure(error: IntError.cannotDivideByZero)
    }

    private func divBy2(_ a: Int) -> Result<Int> {
        return .success(value: a / 2)
    }

    func testWhenResultWithSuccessIsMapped_thenOutputIsResultWithTransformation() {
        let resultInt = Result<Int>.success(value: 12)
        let output = resultInt.map { $0 * 2 }
        assertEqual(output, Result<Int>.success(value: 24))
    }

    func testWhenResultWithFailureIsMapped_thenOutputIsResultWithInitialFailure() {
        let failInt = Result<Int>.failure(error: IntError.testError)
        let output = failInt.map { "\($0)" }
        assertEqual(output, Result<String>.failure(error: IntError.testError))
    }

    func testWhenResultWithFailureIsMappedSuccessively_thenOutputIsResultWithFirstFailure() {
        let failInt = Result<Int>.failure(error: IntError.testError)
        let output = failInt.map { ($0 * 2) }.map { "\(0)" }.map { $0.uppercased() }
        assertEqual(output, Result<String>.failure(error: IntError.testError))
    }

    func testWhenIntResultWithSuccessIsMappedToDivBy2_thenItProducesDoubleWrappedResult() {
        let initialInt = Result<Int>.success(value: 12)
        let output = initialInt.map(divBy2)
        let expected = Result.success(value: Result<Int>.success(value: 6))
        assertEqual(output, expected)
    }

    // As seen above, chaining becomes tedious if the result is double wrapped
    // `initialInt.map(divBy2).map {  $0.map(divBy2) }`
    // This is exactly why we have `flatMap`.g
    // The above becomes `intitialInt.flatMap(divBy2).flatMap(divBy2)`
    func testWhenIntResultWithSuccesIsFlatMappedToDivBy2_thenItProducesSingleWrappedResult() {
        let initialInt = Result<Int>.success(value: 12)
        let output = initialInt.flatMap(divBy2)
        let expected = Result<Int>.success(value: 6)
        assertEqual(output, expected)
    }

    func testWhenIntResultWithSuccessIsFlatMappedToDivBy0ThenDivBy2_thenItProducesResultWithDivFailure() {
        let initialInt = Result<Int>.success(value: 12)
        let output = initialInt.flatMap(divBy2).flatMap(divBy0).flatMap(divBy2)
        let expected = Result<Int>.failure(error: IntError.cannotDivideByZero)
        assertEqual(output, expected)
    }

    private func assertEqual<T: Equatable>(_ lhs: Result<T>, _ rhs: Result<T>)  {
        switch (lhs, rhs) {
        case (let .success(lv), let .success(rv)):
            XCTAssertEqual(lv, rv)
        case (let .failure(le), let .failure(re)):
            XCTAssertEqual(le.localizedDescription, re.localizedDescription)
        default:
            XCTFail("\(lhs) is not equal to \(rhs)")
        }
    }

    private func assertEqual<T: Equatable>(_ lhs: Result<Result<T>>, _ rhs: Result<Result<T>>)  {
        switch (lhs, rhs) {
        case (let .success(lv), let .success(rv)):
            assertEqual(lv, rv)
        case (let .failure(le), let .failure(re)):
            XCTAssertEqual(le.localizedDescription, re.localizedDescription)
        default:
            XCTFail("\(lhs) is not equal to \(rhs)")
        }
    }
}

