//
//  URLProtocolStub.swift
//  EnglishByFilmsTests
//
//  Created by Mikalai Tsyhankou on 26/08/2026.
//

import Foundation
import Synchronization

nonisolated struct RecordedRequest: Sendable {
    let url: URL?
    let httpMethod: String?
    let headers: [String: String]
    let body: Data?

    var path: String {
        url?.path() ?? ""
    }

    func queryValue(for name: String) -> String? {
        guard let url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }

        return components.queryItems?.first { $0.name == name }?.value
    }
}

/// Intercepts URLSession requests for hosts registered by a test. Each test
/// registers its own unique host, which keeps parallel tests independent.
nonisolated final class URLProtocolStub: URLProtocol {
    typealias Handler = @Sendable (RecordedRequest) throws -> (statusCode: Int, data: Data)

    private struct State {
        var handlersByHost: [String: Handler] = [:]
        var recordedRequests: [RecordedRequest] = []
    }

    private static let state = Mutex(State())

    static func makeSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        return URLSession(configuration: configuration)
    }

    static func setHandler(forHost host: String, _ handler: @escaping Handler) {
        state.withLock { $0.handlersByHost[host] = handler }
    }

    static func recordedRequests(forHost host: String) -> [RecordedRequest] {
        state.withLock { state in
            state.recordedRequests.filter { $0.url?.host() == host }
        }
    }

    override class func canInit(with request: URLRequest) -> Bool {
        guard let host = request.url?.host() else {
            return false
        }

        return state.withLock { $0.handlersByHost[host] != nil }
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        let recorded = RecordedRequest(
            url: request.url,
            httpMethod: request.httpMethod,
            headers: request.allHTTPHeaderFields ?? [:],
            body: Self.bodyData(from: request)
        )

        guard let url = request.url,
              let host = url.host(),
              let handler = Self.state.withLock({ state -> Handler? in
                  state.recordedRequests.append(recorded)
                  return state.handlersByHost[host]
              }) else {
            client?.urlProtocol(self, didFailWithError: URLError(.unsupportedURL))
            return
        }

        do {
            let (statusCode, data) = try handler(recorded)
            guard let response = HTTPURLResponse(
                url: url,
                statusCode: statusCode,
                httpVersion: "HTTP/1.1",
                headerFields: nil
            ) else {
                client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
                return
            }

            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}

    // URLSession exposes POST bodies to URLProtocol only through a stream.
    private static func bodyData(from request: URLRequest) -> Data? {
        if let body = request.httpBody {
            return body
        }

        guard let stream = request.httpBodyStream else {
            return nil
        }

        stream.open()
        defer { stream.close() }

        var data = Data()
        let bufferSize = 4096
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer { buffer.deallocate() }

        while stream.hasBytesAvailable {
            let count = stream.read(buffer, maxLength: bufferSize)
            guard count > 0 else {
                break
            }

            data.append(buffer, count: count)
        }

        return data
    }
}
