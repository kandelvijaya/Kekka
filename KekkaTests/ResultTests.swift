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
        XCTAssertEqual(output, .success(value: 24))
    }

    func testWhenResultWithFailureIsMapped_thenOutputIsResultWithInitialFailure() {
        let failInt = Result<Int>.failure(error: IntError.testError)
        let output = failInt.map { "\($0)" }
        XCTAssertEqual(output, .failure(error: IntError.testError))
    }

    func testWhenResultWithFailureIsMappedSuccessively_thenOutputIsResultWithFirstFailure() {
        let failInt = Result<Int>.failure(error: IntError.testError)
        let output = failInt.map { $0 * 2 }.map { "\(0)" }.map { $0.uppercased() }
        XCTAssertEqual(output, .failure(error: IntError.testError))
    }

    func testWhenIntResultWithSuccessIsMappedToDivBy2_thenItProducesDoubleWrappedResult() {
        let initialInt = Result<Int>.success(value: 12)
        let output = initialInt.map(divBy2)
        let expected = Result.success(value: Result<Int>.success(value: 6))
        XCTAssertEqual(output, expected)
    }

    // As seen above, chaining becomes tedious if the result is double wrapped
    // `initialInt.map(divBy2).map {  $0.map(divBy2) }`
    // This is exactly why we have `flatMap`.g
    // The above becomes `intitialInt.flatMap(divBy2).flatMap(divBy2)`
    func testWhenIntResultWithSuccesIsFlatMappedToDivBy2_thenItProducesSingleWrappedResult() {
        let initialInt = Result<Int>.success(value: 12)
        let output = initialInt.flatMap(divBy2)
        let expected = Result<Int>.success(value: 6)
        XCTAssertEqual(output, expected)
    }

    func testWhenIntResultWithSuccessIsFlatMappedToDivBy0ThenDivBy2_thenItProducesResultWithDivFailure() {
        let initialInt = Result<Int>.success(value: 12)
        let output = initialInt.flatMap(divBy2).flatMap(divBy0).flatMap(divBy2)
        let expected = Result<Int>.failure(error: IntError.cannotDivideByZero)
        XCTAssertEqual(output, expected)
    }

    //MARK:- Equality Tests

    func test_whenResultWithSameIntsAreCompared_thenTheyAreEqual() {
        let a = Result.success(value: 1)
        let b = Result.success(value: 1)
        XCTAssertEqual(a, b)
    }

    func test_whenResultWithSameErrorsAreCompared_thenTheyAreEqual() {
        let a = Result<Int>.failure(error: TestError.cantDivideByTwo)
        let b = Result<Int>.failure(error: TestError.cantDivideByTwo)
        XCTAssertEqual(a, b)
    }

    func test_whenResultWithSameErrorWithAssociatedTypesAreCompared_thenTheyAreEqual() {
        let a = Result<Int>.failure(error: TestError.unknown("some error"))
        let b = Result<Int>.failure(error: TestError.unknown("some error"))
        XCTAssertEqual(a, b)
    }

    func test_whenResultWithErrorsWithDifferentValueForAssocaitedTypesAreCompared_thenTheyAreNotEqual() {
        XCTAssertNotEqual(Result<Int>.failure(error: TestError.unknown("a")),
                          Result<Int>.failure(error: TestError.unknown("b")))
    }

    func test_whenResultWithDifferentErrorAreComapred_thenTheyAreNotEqual() {
        XCTAssertNotEqual(Result<String>.failure(error: TestError.cantDivideByTwo),
                          Result<String>.failure(error: TestError.cantRepresentComplexNumber))
    }

    func test_whenResultStringsWithDifferentValuesAreCompared_thenTheyAreNotEqual() {
        XCTAssertNotEqual(Result<String>.success(value: "hello"),
                          Result<String>.success(value: "there"))
    }

    func test_whenResultWithErrorAndValueAreCompared_thenTheyAreNotEqual() {
        XCTAssertNotEqual(Result<String>.success(value: "a"),
                          Result<String>.failure(error: TestError.unknown("a")))
    }

    enum TestError: Error {
        case cantDivideByTwo
        case cantRepresentComplexNumber
        case unknown(String)
    }

}

