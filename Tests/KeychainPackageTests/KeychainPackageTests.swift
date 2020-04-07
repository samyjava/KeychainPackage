import XCTest
@testable import KeychainPackage

final class KeychainPackageTests: XCTestCase {
    let wrappper = KeychainWrapper()
    var internetCredential: InternetCredential?
    var genericCredential: GenericCredential?
    override func setUp() {
        wrappper.deleteAllTestData(for: "testaccount")
        wrappper.deleteAllTestData(for: "testaccount2")
    }
    override func tearDown() {
        wrappper.deleteAllTestData(for: "testaccount")
        wrappper.deleteAllTestData(for: "testaccount2")
    }
    
    func testInternetCredentialWithAccountAndServer() {
        self.internetCredential = InternetCredential(account: "testaccount", secret: "Aa123456", server: "http://google.com", port: nil, additionalInfo: nil)
        do {
            try wrappper.add(credential: internetCredential!)
            let fetchedCredential = try wrappper.fetchInternetCredential(account: "testaccount", server: "http://google.com", port: nil, additionalInfo: nil)
            XCTAssertEqual(internetCredential, fetchedCredential)
        } catch {
            XCTFail()
        }
    }
    
    func testInternetCredentialWithAccountAndServerAndAdditionalInfo() {
        self.internetCredential = InternetCredential(account: "testaccount", secret: "Aa123456", server: "http://google.com", port: nil, additionalInfo: "SamJavadizadeh")
        do {
            try wrappper.add(credential: internetCredential!)
            let fetchedCredential = try wrappper.fetchInternetCredential(account: "testaccount", server: "http://google.com", port: nil, additionalInfo: "SamJavadizadeh")
            XCTAssertEqual(internetCredential, fetchedCredential)
        } catch {
            XCTFail()
        }
    }
    
    func testInternetCredentialWithAccountAndServerAndPort() {
        self.internetCredential = InternetCredential(account: "testaccount", secret: "Aa123456", server: "http://google.com", port: 100, additionalInfo: nil)
        do {
            try wrappper.add(credential: internetCredential!)
            let fetchedCredential = try wrappper.fetchInternetCredential(account: "testaccount", server: "http://google.com", port: 100, additionalInfo: nil)
            XCTAssertEqual(internetCredential, fetchedCredential)
        } catch {
            XCTFail()
        }
    }
    
    func testInternetCredentialNotFoundFetch() {
        self.internetCredential = InternetCredential(account: "testaccount", secret: "Aa123456", server: "http://google.com", port: 100, additionalInfo: nil)
        do {
            try wrappper.add(credential: internetCredential!)
            _ = try wrappper.fetchInternetCredential(account: "testaccount2", server: "http://google.com", port: 100, additionalInfo: nil)
            XCTFail()
        } catch {
            XCTAssertEqual(error as! KeychainWrapperError, KeychainWrapperError.notFound)
        }
    }
    
    func testInternetCredentialDeletion() {
        self.internetCredential = InternetCredential(account: "testaccount", secret: "Aa123456", server: "http://google.com", port: 100, additionalInfo: nil)
        do {
            try wrappper.add(credential: internetCredential!)
            try wrappper.deleteInternetCredential(for: self.internetCredential!)
            _ = try wrappper.fetchInternetCredential(account: "testaccount", server: "http://google.com", port: 100, additionalInfo: nil)
            
        } catch {
            XCTAssertEqual(error as! KeychainWrapperError, KeychainWrapperError.notFound)
        }
    }
    
    func testInternetCredentialUpdateServer() {
        self.internetCredential = InternetCredential(account: "testaccount", secret: "Aa123456", server: "http://google.com", port: nil, additionalInfo: nil)
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
    
    func testInternetCredentialUpdateAccount() {
        self.internetCredential = InternetCredential(account: "testaccount", secret: "Aa123456", server: "http://google.com", port: nil, additionalInfo: nil)
        do {
            try wrappper.add(credential: internetCredential!)
            try wrappper.updateInternetCredential(for: self.internetCredential!, account: "testaccount2", server: nil, port: nil, additionalInfo: nil)
            let fetchedCredential = try wrappper.fetchInternetCredential(account: "testaccount2", server: "http://google.com", port: nil, additionalInfo: nil)
            XCTAssertNotEqual(internetCredential, fetchedCredential)
            XCTAssertEqual(fetchedCredential.account, "testaccount2")
        } catch {
            XCTFail()
        }
    }
    
    func testInternetCredentialUpdatePort() {
        self.internetCredential = InternetCredential(account: "testaccount", secret: "Aa123456", server: "http://google.com", port: 10, additionalInfo: nil)
        do {
            try wrappper.add(credential: internetCredential!)
            try wrappper.updateInternetCredential(for: self.internetCredential!, account: nil, server: "http://google.com", port: 20, additionalInfo: nil)
            let fetchedCredential = try wrappper.fetchInternetCredential(account: "testaccount", server: "http://google.com", port: 20, additionalInfo: nil)
            XCTAssertNotEqual(internetCredential, fetchedCredential)
            XCTAssertEqual(fetchedCredential.port, 20)
        } catch {
            XCTFail()
        }
    }
    
    func testInternetCredentialUpdateAdditionalInfo() {
        self.internetCredential = InternetCredential(account: "testaccount", secret: "Aa123456", server: "http://google.com", port: nil, additionalInfo: "MOREINFO")
        do {
            try wrappper.add(credential: internetCredential!)
            try wrappper.updateInternetCredential(for: self.internetCredential!, account: nil, server: "http://google.com", port: nil, additionalInfo: "MOREINFO2")
            let fetchedCredential = try wrappper.fetchInternetCredential(account: "testaccount", server: "http://google.com", port: nil, additionalInfo: "MOREINFO2")
            XCTAssertNotEqual(internetCredential, fetchedCredential)
            XCTAssertEqual(fetchedCredential.additionalInfo, "MOREINFO2")
        } catch {
            XCTFail()
        }
    }
    
    func testInternetCredentialUpdateAdditionalInfoFromNil() {
        self.internetCredential = InternetCredential(account: "testaccount", secret: "Aa123456", server: "http://google.com", port: nil, additionalInfo: nil)
        do {
            try wrappper.add(credential: internetCredential!)
            try wrappper.updateInternetCredential(for: self.internetCredential!, account: nil, server: "http://google.com", port: nil, additionalInfo: "MOREINFO2")
            let fetchedCredential = try wrappper.fetchInternetCredential(account: "testaccount", server: "http://google.com", port: nil, additionalInfo: "MOREINFO2")
            XCTAssertNotEqual(internetCredential, fetchedCredential)
            XCTAssertEqual(fetchedCredential.additionalInfo, "MOREINFO2")
        } catch {
            XCTFail()
        }
    }
    
    func testInternetCredentialUpdateAllProperties() {
        self.internetCredential = InternetCredential(account: "testaccount", secret: "Aa123456", server: "http://google.com", port: 10, additionalInfo: "MOREINFO")
        do {
            try wrappper.add(credential: internetCredential!)
            try wrappper.updateInternetCredential(for: self.internetCredential!, account: "testaccount2", server: "http://yahoo.com", port: 20, additionalInfo: "MOREINFO2")
            let fetchedCredential = try wrappper.fetchInternetCredential(account: "testaccount2", server: "http://yahoo.com", port: 20, additionalInfo: "MOREINFO2")
            XCTAssertNotEqual(internetCredential, fetchedCredential)
            XCTAssertEqual(fetchedCredential.account, "testaccount2")
            XCTAssertEqual(fetchedCredential.server, "http://yahoo.com")
            XCTAssertEqual(fetchedCredential.port, 20)
            XCTAssertEqual(fetchedCredential.additionalInfo, "MOREINFO2")
        } catch {
            XCTFail()
        }
    }
    
    func testGenericCredentialWithAccountAndServer() {
        self.genericCredential = GenericCredential(account: "testaccount", secret: "Aa123456",  additionalInfo: nil)
        do {
            try wrappper.add(credential: genericCredential!)
            let fetchedCredential = try wrappper.fetchGenericCredential(account: "testaccount",  additionalInfo: nil)
            XCTAssertEqual(genericCredential, fetchedCredential)
        } catch {
            XCTFail()
        }
    }
    
    func testGenericCredentialWithAccountAndAdditionalInfo() {
        self.genericCredential = GenericCredential(account: "testaccount", secret: "Aa123456",  additionalInfo: "SamJavadizadeh")
        do {
            try wrappper.add(credential: genericCredential!)
            let fetchedCredential = try wrappper.fetchGenericCredential(account: "testaccount",  additionalInfo: "SamJavadizadeh")
            XCTAssertEqual(genericCredential, fetchedCredential)
        } catch {
            XCTFail()
        }
    }
    
    func testGenericCredentialNotFoundFetch() {
        self.genericCredential = GenericCredential(account: "testaccount", secret: "Aa123456", additionalInfo: nil)
        do {
            try wrappper.add(credential: genericCredential!)
            _ = try wrappper.fetchGenericCredential(account: "testaccount2", additionalInfo: nil)
            XCTFail()
        } catch {
            XCTAssertEqual(error as! KeychainWrapperError, KeychainWrapperError.notFound)
        }
    }
    
    func testGenericCredentialDeletion() {
        self.genericCredential = GenericCredential(account: "testaccount", secret: "Aa123456", additionalInfo: nil)
        do {
            try wrappper.add(credential: genericCredential!)
            try wrappper.deleteGenericCredential(for: self.genericCredential!)
            _ = try wrappper.fetchGenericCredential(account: "testaccount", additionalInfo: nil)
            
        } catch {
            XCTAssertEqual(error as! KeychainWrapperError, KeychainWrapperError.notFound)
        }
    }
    
    func testGenericCredentialUpdateAccount() {
        self.genericCredential = GenericCredential(account: "testaccount", secret: "Aa123456",  additionalInfo: nil)
        do {
            try wrappper.add(credential: genericCredential!)
            try wrappper.updateGenericCredential(for: self.genericCredential!, account: "testaccount2", additionalInfo: nil)
            let fetchedCredential = try wrappper.fetchGenericCredential(account: "testaccount2",  additionalInfo: nil)
            XCTAssertNotEqual(genericCredential, fetchedCredential)
            XCTAssertEqual(fetchedCredential.account, "testaccount2")
        } catch {
            XCTFail()
        }
    }
    
    func testGenericCredentialUpdateAdditionalInfo() {
        self.genericCredential = GenericCredential(account: "testaccount", secret: "Aa123456",  additionalInfo: "MOREINFO")
        do {
            try wrappper.add(credential: genericCredential!)
            try wrappper.updateGenericCredential(for: self.genericCredential!, account: nil,  additionalInfo: "MOREINFO2")
            let fetchedCredential = try wrappper.fetchGenericCredential(account: "testaccount",  additionalInfo: "MOREINFO2")
            XCTAssertNotEqual(genericCredential, fetchedCredential)
            XCTAssertEqual(fetchedCredential.additionalInfo, "MOREINFO2")
        } catch {
            XCTFail()
        }
    }
    
    func testGenericCredentialUpdateAdditionalInfoFromNil() {
        self.genericCredential = GenericCredential(account: "testaccount", secret: "Aa123456",  additionalInfo: nil)
        do {
            try wrappper.add(credential: genericCredential!)
            try wrappper.updateGenericCredential(for: self.genericCredential!, account: nil,  additionalInfo: "MOREINFO2")
            let fetchedCredential = try wrappper.fetchGenericCredential(account: "testaccount",  additionalInfo: "MOREINFO2")
            XCTAssertNotEqual(genericCredential, fetchedCredential)
            XCTAssertEqual(fetchedCredential.additionalInfo, "MOREINFO2")
        } catch {
            XCTFail()
        }
    }
    
    
    static var allTests = [
        ("testInternetCredentialWithAccountAndServer", testInternetCredentialWithAccountAndServer),
    ]
}
