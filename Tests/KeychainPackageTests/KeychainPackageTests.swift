import XCTest
@testable import KeychainPackage

final class KeychainPackageTests: XCTestCase {
    let wrappper = KeychainWrapper()
    var internetCredential: InternetCredential?
    override func setUp() {
        wrappper.deleteAllTestData(for: "testaccount")
    }
    override func tearDown() {
        if self.internetCredential != nil {
            do {
                try wrappper.deleteInternetCredential(for: internetCredential!)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func testInternetCredentialWithAccountAndServer() {
        self.internetCredential = InternetCredential(account: "testaccount", password: "Aa123456", server: "http://google.com", port: nil, additionalInfo: nil)
        do {
            try wrappper.add(credential: internetCredential!)
            let fetchedCredential = try wrappper.fetchInternetCredential(account: "testaccount", server: "http://google.com", port: nil, additionalInfo: nil)
            XCTAssertEqual(internetCredential, fetchedCredential)
        } catch {
            XCTFail()
        }
    }

    func testInternetCredentialWithAccountAndServerAndAdditionalInfo() {
        self.internetCredential = InternetCredential(account: "testaccount", password: "Aa123456", server: "http://google.com", port: nil, additionalInfo: "SamJavadizadeh")
        do {
            try wrappper.add(credential: internetCredential!)
            let fetchedCredential = try wrappper.fetchInternetCredential(account: "testaccount", server: "http://google.com", port: nil, additionalInfo: "SamJavadizadeh")
            XCTAssertEqual(internetCredential, fetchedCredential)
        } catch {
            XCTFail()
        }
    }
    
    func testInternetCredentialWithAccountAndServerAndPort() {
        self.internetCredential = InternetCredential(account: "testaccount", password: "Aa123456", server: "http://google.com", port: 100, additionalInfo: nil)
        do {
            try wrappper.add(credential: internetCredential!)
            let fetchedCredential = try wrappper.fetchInternetCredential(account: "testaccount", server: "http://google.com", port: 100, additionalInfo: nil)
            XCTAssertEqual(internetCredential, fetchedCredential)
        } catch {
            XCTFail()
        }
    }
    
    func testInternetCredentialDeletion() {
        self.internetCredential = InternetCredential(account: "testaccount", password: "Aa123456", server: "http://google.com", port: 100, additionalInfo: nil)
        do {
            try wrappper.add(credential: internetCredential!)
            try wrappper.deleteInternetCredential(for: self.internetCredential!)
            _ = try wrappper.fetchInternetCredential(account: "testaccount", server: "http://google.com", port: 100, additionalInfo: nil)
            
        } catch {
            XCTAssertEqual(error as! KeychainWrapperError, KeychainWrapperError.notFound)
        }
    }
    
    func testInternetCredentialUpdateServer() {
        self.internetCredential = InternetCredential(account: "testaccount", password: "Aa123456", server: "http://google.com", port: nil, additionalInfo: nil)
        do {
            try wrappper.add(credential: internetCredential!)
            try wrappper.updateInternetCredential(for: self.internetCredential!, account: nil, server: "http://yahoo.com", port: nil, additionalInfo: nil)
            let fetchedCredential = try wrappper.fetchInternetCredential(account: "testaccount", server: "http://yahoo.com", port: nil, additionalInfo: nil)
            XCTAssertNotEqual(internetCredential, fetchedCredential)
            XCTAssertEqual(fetchedCredential.server, "http://yahoo.com")
        } catch {
            XCTFail()
        }
    }
    
    static var allTests = [
        ("testInternetCredentialWithAccountAndServer", testInternetCredentialWithAccountAndServer),
    ]
}
