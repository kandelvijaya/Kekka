//
//  FullyTypedResultTests.swift
//  KekkaTests
//
//  Created by Vijaya Prakash Kandel on 21.10.18.
//  Copyright © 2018 com.kandelvijaya. All rights reserved.
//

import Foundation
import XCTest
@testable import Kekka

final class FullyTypedResultTests: XCTestCase {

    enum SomeError: Error {
        case divideByZero
        case other
    }

    func test_fullyTypedResultCanEmitResultType() {
        let res = ResultTyped<Int, SomeError>.success(12)
        XCTAssertEqual(res.untyped.value, 12)
    }

    func test_fullyTypedResultWithErrorCanEmitResultType() {
        let res = ResultTyped<Int, SomeError>.failure(SomeError.divideByZero)
        let error = res.untyped.error as? SomeError
        XCTAssertNotNil(error)
        XCTAssertTrue(error!.isEqual(to: SomeError.divideByZero))
    }

    func test_fullyTypedResultCanBeCompared() {
        XCTAssertEqual(ResultTyped<Int, SomeError>.success(12), .success(12))
        XCTAssertNotEqual(ResultTyped<Int, SomeError>.success(12), .success(13))

        XCTAssertEqual(ResultTyped<Int, SomeError>.failure(SomeError.divideByZero), .failure(SomeError.divideByZero))
        XCTAssertNotEqual(ResultTyped<Int, SomeError>.failure(SomeError.divideByZero), .failure(SomeError.other))

        XCTAssertNotEqual(ResultTyped<Int, SomeError>.success(12), .failure(SomeError.other))
    }

}
