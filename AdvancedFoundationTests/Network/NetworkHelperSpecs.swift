class NetworkHelperHelperSpecs: QuickSpec {
    
    // FUTUREWORK: Test the cache function
    
    // COMMENT: Change it to server to use real web service.
    private static let api = APIMocker.mocker
    private static let invalidAPI = "http://test"
    
    var results: Dictionary<String, NetworkHelperSpecsTask> = [:]
    
    override func spec() {
        let networkHelper = NetworkHelper(identifier: "NetworkHelper")
        if NetworkHelperHelperSpecs.api == .mocker {
            let urlSessionMocker = URLSessionMocker()
            urlSessionMocker.urlSessionDelegate = networkHelper
            networkHelper.normalSession = urlSessionMocker
            networkHelper.backgroundSession = urlSessionMocker
        }
        networkHelper.networkHelperDelegate = self
        afterEach {
            networkHelper.reset()
        }
        describe("has isNetworkAvailable") {
            it("is true") {
                expect(NetworkHelper.isNetworkAvailable) == true
            }
        }
        describe("has standard") {
            it("is not nil") {
                expect(NetworkHelper.standard).toNot(beNil())
            }
        }
        describe("calls init(identifier:cache)") {
            it("returns object") {
                expect(NetworkHelper(identifier: "ID", cache: URLCache.shared)).toNot(beNil())
            }
        }
        describe("calls get(fromURL:with:asDownloadTask)") {
            context("with valid url and header") {
                it("receives response") { [unowned self] in
                    let identifier = networkHelper.get(fromURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkHelperHelperSpecs.api.header)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.header?.eTag).toEventually(equal("Success"))
                }
                it("receives data") { [unowned self] in
                    let identifier = networkHelper.get(fromURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkHelperHelperSpecs.api.header)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.data?.count).toEventually(equal("Success".data(using: .utf8)?.count))
                }
            }
            context("with invalid url") {
                it("receives error") { [unowned self] in
                    let identifier = networkHelper.get(fromURL: NetworkHelperHelperSpecs.invalidAPI, with: NetworkHelperHelperSpecs.api.header)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.error).toEventuallyNot(beNil())
                }
            }
            context("with invalid header") {
                it("receives error") { [unowned self] in
                    let identifier = networkHelper.get(fromURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkRequestHeader())!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.error).toEventuallyNot(beNil())
                }
            }
            context("with type as a download task") {
                it("receives percentage") { [unowned self] in
                    let identifier = networkHelper.get(fromURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkHelperHelperSpecs.api.header, asDownloadTask: true)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.percentage).toEventuallyNot(beNil())
                }
                it("receives url") { [unowned self] in
                    let identifier = networkHelper.get(fromURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkHelperHelperSpecs.api.header, asDownloadTask: true)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.url).toEventuallyNot(beNil())
                }
            }
            context("with type as a normal task") {
                it("receives response") { [unowned self] in
                    let identifier = networkHelper.get(fromURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkHelperHelperSpecs.api.header, asDownloadTask: false)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.header?.eTag).toEventually(equal("Success"))
                }
                it("receives data") { [unowned self] in
                    let identifier = networkHelper.get(fromURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkHelperHelperSpecs.api.header, asDownloadTask: false)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.data?.count).toEventually(equal("Success".data(using: .utf8)?.count))
                }
            }
        }
        describe("calls post(toURL:with:with:asUploadTask)") {
            context("with valid url, form data and header") {
                it("receives response") { [unowned self] in
                    let identifier = networkHelper.post(toURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkHelperHelperSpecs.api.formData, with: NetworkHelperHelperSpecs.api.header)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.header?.eTag).toEventually(equal("Success"))
                }
                it("receives data") { [unowned self] in
                    let identifier = networkHelper.post(toURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkHelperHelperSpecs.api.formData, with: NetworkHelperHelperSpecs.api.header)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.data?.count).toEventually(equal("Success".data(using: .utf8)?.count))
                }
            }
            context("with invalid url") {
                it("receives error") { [unowned self] in
                    let identifier = networkHelper.post(toURL: NetworkHelperHelperSpecs.invalidAPI, with: NetworkHelperHelperSpecs.api.formData, with: NetworkHelperHelperSpecs.api.header)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.error).toEventuallyNot(beNil())
                }
            }
            context("with invalid header") {
                it("receives error") { [unowned self] in
                    let identifier = networkHelper.post(toURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkHelperHelperSpecs.api.formData, with: NetworkRequestHeader())!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.error).toEventuallyNot(beNil())
                }
            }
            context("with invalid form data") {
                it("receives error") { [unowned self] in
                    let identifier = networkHelper.post(toURL: NetworkHelperHelperSpecs.api.rawValue, with: FormData(fields: []), with: NetworkHelperHelperSpecs.api.header)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.error).toEventuallyNot(beNil())
                }
            }
            context("with type as an upload task") {
                it("receives response") { [unowned self] in
                    let identifier = networkHelper.post(toURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkHelperHelperSpecs.api.formData, with: NetworkHelperHelperSpecs.api.header, asUploadTask: true)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.header?.eTag).toEventually(equal("Success"))
                }
                it("receives data") { [unowned self] in
                    let identifier = networkHelper.post(toURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkHelperHelperSpecs.api.formData, with: NetworkHelperHelperSpecs.api.header, asUploadTask: true)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.data?.count).toEventually(equal("Success".data(using: .utf8)?.count))
                }
            }
            context("with type as a normal task") {
                it("receives response") { [unowned self] in
                    let identifier = networkHelper.post(toURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkHelperHelperSpecs.api.formData, with: NetworkHelperHelperSpecs.api.header, asUploadTask: false)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.header?.eTag).toEventually(equal("Success"))
                }
                it("receives data") { [unowned self] in
                    let identifier = networkHelper.post(toURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkHelperHelperSpecs.api.formData, with: NetworkHelperHelperSpecs.api.header, asUploadTask: false)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.data?.count).toEventually(equal("Success".data(using: .utf8)?.count))
                }
            }
        }
        describe("calls post(toURL:with:as:with:asUploadTask)") {
            context("with valid url, body and header") {
                it("receives response") { [unowned self] in
                    let identifier = networkHelper.post(toURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkHelperHelperSpecs.api.body, as: .text, with: NetworkHelperHelperSpecs.api.header)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.header?.eTag).toEventually(equal("Success"))
                }
                it("receives data") { [unowned self] in
                    let identifier = networkHelper.post(toURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkHelperHelperSpecs.api.body, as: .text, with: NetworkHelperHelperSpecs.api.header)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.data?.count).toEventually(equal("Success".data(using: .utf8)?.count))
                }
            }
            context("with invalid url") {
                it("receives error") { [unowned self] in
                    let identifier = networkHelper.post(toURL: NetworkHelperHelperSpecs.invalidAPI, with: NetworkHelperHelperSpecs.api.body, as: .text, with: NetworkHelperHelperSpecs.api.header)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.error).toEventuallyNot(beNil())
                }
            }
            context("with invalid header") {
                it("receives error") { [unowned self] in
                    let identifier = networkHelper.post(toURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkHelperHelperSpecs.api.body, as: .text, with: NetworkRequestHeader())!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.error).toEventuallyNot(beNil())
                }
            }
            context("with invalid body") {
                it("receives error") { [unowned self] in
                    let identifier = networkHelper.post(toURL: NetworkHelperHelperSpecs.api.rawValue, with: Data(), as: .text, with: NetworkHelperHelperSpecs.api.header)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.error).toEventuallyNot(beNil())
                }
            }
            context("with type as an upload task") {
                it("receives response") { [unowned self] in
                    let identifier = networkHelper.post(toURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkHelperHelperSpecs.api.body, as: .text, with: NetworkHelperHelperSpecs.api.header, asUploadTask: true)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.header?.eTag).toEventually(equal("Success"))
                }
                it("receives data") { [unowned self] in
                    let identifier = networkHelper.post(toURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkHelperHelperSpecs.api.body, as: .text, with: NetworkHelperHelperSpecs.api.header, asUploadTask: true)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.data?.count).toEventually(equal("Success".data(using: .utf8)?.count))
                }
            }
            context("with type as a normal task") {
                it("receives response") { [unowned self] in
                    let identifier = networkHelper.post(toURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkHelperHelperSpecs.api.body, as: .text, with: NetworkHelperHelperSpecs.api.header, asUploadTask: false)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.header?.eTag).toEventually(equal("Success"))
                }
                it("receives data") { [unowned self] in
                    let identifier = networkHelper.post(toURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkHelperHelperSpecs.api.body, as: .text, with: NetworkHelperHelperSpecs.api.header, asUploadTask: false)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.data?.count).toEventually(equal("Success".data(using: .utf8)?.count))
                }
            }
        }
        describe("calls delete(atURL:with)") {
            context("with valid url and header") {
                it("receives response") { [unowned self] in
                    let identifier = networkHelper.delete(atURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkHelperHelperSpecs.api.header)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.header?.eTag).toEventually(equal("Success"))
                }
                it("receives data") { [unowned self] in
                    let identifier = networkHelper.delete(atURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkHelperHelperSpecs.api.header)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.data?.count).toEventually(equal("Success".data(using: .utf8)?.count))
                }
            }
            context("with invalid url") {
                it("receives error") { [unowned self] in
                    let identifier = networkHelper.delete(atURL: NetworkHelperHelperSpecs.invalidAPI, with: NetworkHelperHelperSpecs.api.header)!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.error).toEventuallyNot(beNil())
                }
            }
            context("with invalid header") {
                it("receives error") { [unowned self] in
                    let identifier = networkHelper.delete(atURL: NetworkHelperHelperSpecs.api.rawValue, with: NetworkRequestHeader())!
                    self.results[identifier] = NetworkHelperSpecsTask()
                    expect(self.results[identifier]?.error).toEventuallyNot(beNil())
                }
            }
        }
        describe("calls reset()") {
            it("has no task") {
                _ = networkHelper.get(fromURL: NetworkHelperHelperSpecs.invalidAPI, with: NetworkHelperHelperSpecs.api.header)!
                networkHelper.reset()
                expect(networkHelper.tasks.count) == 0
            }
        }
        describe("calls clearCache()") {
            // TODO: Test the cache function
        }
        describe("calls clearCache(forURL)") {
            // TODO: Test the cache function
        }
        describe("calls append(_:toCacheOf)") {
            // COMMENT: This has been tested in other functions.
        }
        describe("calls findTask(of)") {
            // COMMENT: This has been tested in other tests.
        }
        describe("calls remove(_)") {
            // COMMENT: This has been tested in other tests.
        }
        describe("calls dispatchError(for:withMessage)") {
            // COMMENT: This has been tested in other tests.
        }
    }
    
}

import Quick
import Nimble
@testable import AdvancedFoundation