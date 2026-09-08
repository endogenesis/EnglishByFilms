//
//  TestHelpers.swift
//  EnglishByFilmsTests
//
//  Created by Mikalai Tsyhankou on 26/08/2026.
//

import Testing

/// Yields until the condition becomes true, so a test can synchronize with a
/// task suspended inside a mock without sleeping.
func waitUntil(
    _ condition: () -> Bool,
    maxYields: Int = 10_000,
    sourceLocation: SourceLocation = #_sourceLocation
) async {
    var yields = 0
    while !condition(), yields < maxYields {
        await Task.yield()
        yields += 1
    }

    let conditionMet = condition()
    #expect(conditionMet, "Condition was not met after \(maxYields) yields", sourceLocation: sourceLocation)
}

/// Compares errors by their debug descriptions because the app's error enums
/// do not conform to Equatable.
func expectSameError(
    _ actual: some Error,
    _ expected: some Error,
    sourceLocation: SourceLocation = #_sourceLocation
) {
    #expect(
        String(reflecting: actual) == String(reflecting: expected),
        "Expected \(expected), got \(actual)",
        sourceLocation: sourceLocation
    )
}

func expectThrows<Failure: Error, Value>(
    _ expected: Failure,
    sourceLocation: SourceLocation = #_sourceLocation,
    _ body: () async throws -> Value
) async {
    do {
        _ = try await body()
        Issue.record("Expected \(expected) to be thrown", sourceLocation: sourceLocation)
    } catch {
        expectSameError(error, expected, sourceLocation: sourceLocation)
    }
}
