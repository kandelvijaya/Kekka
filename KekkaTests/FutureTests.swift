//
//  FutureTests.swift
//  KekkaTests
//
//  Created by Vijaya Prakash Kandel on 08.01.18.
//  Copyright © 2018 com.kandelvijaya. All rights reserved.
//

import XCTest
@testable import Kekka

final class FutureTTests: XCTestCase {

    // Future is a Experssion. You have to evaluate with `execute()` to make it work.
    func testWhenFutureIsCreatedWithEventualValue_thenTheChainedThenBlockIsNotExecutedIfExecuteIsNotInvoked() {
        let futureMeTrue = Future(true)
        futureMeTrue.then { status -> Void in
            XCTFail("""
                    All Futures are curried expression. They don't execute unless `execute()` is called on them.
                    This test is supposed assert when `execute()` is not called then this block is not executed.
                    """)
        }
    }
    func testWhenFutureIsCreatedWithEventualValue_thenTheChainedBindBlockIsNotExecutedIfExecuteIsNotInvoked() {
        let futureMeTrue = Future(true)
        _ = futureMeTrue.bind { status -> Future<Bool> in
            XCTFail("""
                    All Futures are curried expression. They don't execute unless `execute()` is called on them.
                    This test is supposed assert when `execute()` is not called then this block is not executed.
                    """)
            return Future(true)
        }
    }

    func testWhenFutureWithBlockIsCreated_thenTheChainedMethodIsNotCalledWithoutExplicitExecuteInvocation() {
        let futureMeTrueBlock = Future<Bool>{ aCompletion in
            aCompletion?(true)
        }

        futureMeTrueBlock.then { Bool -> Void in
            XCTFail("""
                    All Futures are curried expression. They don't execute unless `execute()` is called on them.
                    This test is supposed assert when `execute()` is not called then this block is not executed.
                    """)
        }
    }

    func testWhenFutureWithBlockIsCreated_thenTheChainedMethodViaBindIsNotCalledWithoutExplicitExecuteInvocation() {
        let futureMeTrueBlock = Future<Bool>{ aCompletion in
            aCompletion?(true)
        }

        _ = futureMeTrueBlock.bind { Bool -> Future<Bool> in
            XCTFail("""
                    All Futures are curried expression. They don't execute unless `execute()` is called on them.
                    This test is supposed assert when `execute()` is not called then this block is not executed.
                    """)
            return Future(true)
        }
    }

    func testWhenEventulValuedFutureExists_thenTheyCanBeCopiedSafely() {
        let chocolateLeftAfterMatteoAte2: (Int) -> Int = { $0 - 2 }
        let futureMe4Chocolates = Future(4).then(chocolateLeftAfterMatteoAte2)
        let toExecuteFuture = futureMe4Chocolates

        futureMe4Chocolates.then { x -> Void in
            XCTFail("This shouldn't be executed. This is not related to whoever copied this one.")
        }

        toExecuteFuture.then { x -> Void in
            XCTAssertEqual(x, 2)
        }

        toExecuteFuture.execute()
    }

    // Creation, Execution of Future
    func testWhenFutureIsCreatedFromEventualValue_thenFutureIsCreated() {
        let future12 = Future(12)
        future12.then { x -> Void in
            XCTAssertEqual(x, 12)
            }.execute()
    }

    func testWhenFutureIsCreatedFromEventualValue_thenItCanBeChainedWithOtherFunctionThatTakesTheValueTypeViaThen() {
        let future12 = Future(12)
        let multiplyBy12: (Int) -> Int = { $0 * 12 }
        let divideBy12 : (Int) -> Int = { $0 / 12 }
        future12.then(multiplyBy12).then(divideBy12).then { result -> Void in
            XCTAssertEqual(12, result)
            }.execute()
    }

    // Binding Futures
    func testWhenEventualFutureIsBindedWithOtherFuture_thenEvaluationExecutesBothFuturesInCreationOrder() {
        let future12 = Future(12)
        let giveMeMultiply12Future: (Int) -> Future<Int> = { Future($0 * 12) }
        let divideBy12Future: (Int) -> Future<Int> = { Future($0 / 12) }

        let expression = future12.bind(giveMeMultiply12Future).bind(divideBy12Future)
        expression.then { result -> Void in
            XCTAssertEqual(result, 12)
            }.execute()
    }

    // Reference Count test

    func testWhenNetworFutureIsCopied_thenTheReferenceCountOfTheHolderObjectIsUnique() {
        let zurl = URL(string: "https://www.kandelvijaya.com")!
        var network = Network()
        let firstFuture = network.get(from: zurl)
        let secondFuture = firstFuture
        let thirdFuture = network.get(from: zurl)

        XCTAssertTrue(isKnownUniquelyReferenced(&network))
    }

}


final class Network {

    public enum NetworkError: Error {
        case unknown
    }

    // Completion block here below is the actual work. Calling the completion of the completion block
    // might sound recursive but it isn't. This is how we build more complex closure; thus expression.
    public func get(from url: URL) -> Future<Result<Data>> {
        return Future { aCompletion in
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                if let d = data, error == nil {
                    aCompletion?(.success(d))
                } else if let e = error {
                    aCompletion?(.failure(e))
                } else {
                    aCompletion?(.failure(NetworkError.unknown))
                }
            }
            dataTask.resume()
        }
    }

}

