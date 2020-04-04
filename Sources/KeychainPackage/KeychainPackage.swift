
import Foundation
import Security

public struct KeychainWrapper {
    
    
    /// Add an Internet Credential to Keychain database
    /// - Parameter credential: `InternetCredential` to be saved
    /// - Throws:
    ///     - `KeychainWrapperError.unexpectedPasswordData` if `credential.password` cannot convert to `UTF8` data
    ///     - `KeychainWrapperError.unhandledError` if any unexpected error occure in `Keychain` API
    func add(credential: InternetCredential) throws {
        guard let passwordData = credential.password.data(using: .utf8) else {
            throw KeychainWrapperError.unexpectedPasswordData
        }
        var query: [String:Any] = [kSecClass as String: kSecClassInternetPassword,
                                   kSecAttrAccount as String: credential.account,
                                   kSecAttrServer as String: credential.server,
                                   kSecValueData as String: passwordData
        ]
        
        if let port = credential.port {
            query[kSecAttrPort as String] = port
        }
        
        if let info = credential.additionalInfo {
            query[kSecAttrLabel as String] = info
        }else {
            query[kSecAttrLabel as String] = ""
        }
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainWrapperError.unhandledError(status: status)
        }
    }
    
    
    /// Fetch an Internet Credential from the Keychain database. It searches on the database by filter provided through parameters.
    /// - Parameters:
    ///   - account: the account that we are looking for its credential
    ///   - server: the server that this account belongs to
    ///   - port: the port number - optional
    ///   - additionalInfo: additional key for searching - optional
    /// - Throws:
    ///     - `KeychainWrapperError.notFound` couldn't find any data by this parameters
    ///     - `KeychainWrapperError.unhandledError` if any unexpected error occure in `Keychain` API with associated value `status`
    ///     - `KeychainWrapperError.unexpectedPasswordData` if there is a problem in converting back data from database
    func fetchInternetCredential(account: String, server: String, port: Int?, additionalInfo: String?) throws -> InternetCredential {
        var query: [String:Any] = [kSecClass as String: kSecClassInternetPassword,
                                   kSecAttrAccount as String: account,
                                   kSecAttrServer as String: server,
                                   kSecMatchLimit as String: kSecMatchLimitOne,
                                   kSecReturnAttributes as String: true,
                                   kSecReturnData as String: true]
        if let port = port {
            query[kSecAttrPort as String] = port
        }
        if let info = additionalInfo {
            query[kSecAttrLabel as String] = info
        }
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status != errSecItemNotFound else {
            throw KeychainWrapperError.notFound
        }
        guard status == errSecSuccess else {
            throw KeychainWrapperError.unhandledError(status: status)
        }
        guard let existingItem = result as? [String:Any],
            let existingPasswordData = existingItem[kSecValueData as String] as? Data,
            let existingPassword = String(data: existingPasswordData, encoding: .utf8),
            let existingAccount = existingItem[kSecAttrAccount as String] as? String,
            let existingServer = existingItem[kSecAttrServer as String] as? String else {
                throw KeychainWrapperError.unexpectedPasswordData
        }
        let fetchedPort = existingItem[kSecAttrPort as String] as? Int
        let existingPort = fetchedPort == 0 ? nil : fetchedPort
        let fetchedExistingInfo = existingItem[kSecAttrLabel as String] as? String
        let existingInfo = fetchedExistingInfo == "" ? nil : fetchedExistingInfo
        let credentioal = InternetCredential(account: existingAccount,
                                             password: existingPassword,
                                             server: existingServer,
                                             port: existingPort,
                                             additionalInfo: existingInfo)
        
        return credentioal
    }
    
    /// Update an Internet Credential - any parameter that not nil will update
    /// - Parameters:
    ///   - item: item that you want to update
    ///   - account: new account - optional
    ///   - server: new server - optional
    ///   - port: new port number - optional
    ///   - additionalInfo: new key - optional
    /// - Throws:
    ///     - `KeychainWrapperError.notFound`  couldn't find any data by this item
    ///     - `KeychainWrapperError.unhandledError`  if any unexpected error occure in `Keychain` API with associated value `status`
    func updateInternetCredential(for item: InternetCredential, account: String?, server: String?, port: Int?, additionalInfo: String?) throws {
        var query: [String:Any] = [kSecClass as String: kSecClassInternetPassword,
                                   kSecAttrAccount as String: item.account,
                                   kSecAttrServer as String: item.server,
                                   kSecMatchLimit as String: kSecMatchLimitOne]
        if let port = item.port {
            query[kSecAttrPort as String] = port
        }
        if let info = item.additionalInfo {
            query[kSecAttrLabel as String] = info
        }
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        guard status != errSecItemNotFound else {
            throw KeychainWrapperError.notFound
        }
        guard status == errSecSuccess else {
            throw KeychainWrapperError.unhandledError(status: status)
        }
        
        var attributes: [String:Any] = [:]

        if let server = server {
            attributes[kSecAttrServer as String] = server
        }
        if let port = port {
            attributes[kSecAttrPort as String] = port
        }
        if let additionalInfo = additionalInfo {
            attributes[kSecAttrLabel as String] = additionalInfo
        }
        if let account = account {
            attributes[kSecAttrAccount as String] = account
        }
        let newStatus = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard newStatus == errSecSuccess else {
            throw KeychainWrapperError.unhandledError(status: newStatus)
        }
    }
    
    /// Delete an existing Internet Credential from database
    /// - Parameter item: item you want to delete
    /// - Throws:
    ///     - `KeychainWrapperError.unhandledError` if any unexpected error occure in `Keychain` API with associated value `status`
    func deleteInternetCredential(for item: InternetCredential) throws {
        var query: [String:Any] = [kSecClass as String: kSecClassInternetPassword,
                                   kSecAttrAccount as String: item.account,
                                   kSecAttrServer as String: item.server,
                                   kSecMatchLimit as String: kSecMatchLimitOne]
        
        if let port = item.port {
            query[kSecAttrPort as String] = port
        }
        if let info = item.additionalInfo {
            query[kSecAttrLabel as String] = info
        }
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else {
            throw KeychainWrapperError.unhandledError(status: status)
        }
    }
    
    
    /// Add a Generic Credential to Keychain database
    /// - Parameter credential: `GenericCredential` to be saved
    /// - Throws:
    ///     - `KeychainWrapperError.unexpectedPasswordData` if `credential.password` cannot convert to `UTF8` data
    ///     - `KeychainWrapperError.unhandledError` if any unexpected error occure in `Keychain` API
    func add(credential: GenericCredential) throws {
        guard let passwordData = credential.password.data(using: .utf8) else {
            throw KeychainWrapperError.unexpectedPasswordData
        }
        var query: [String:Any] = [kSecClass as String: kSecClassGenericPassword,
                                   kSecAttrAccount as String: credential.account,
                                   kSecValueData as String: passwordData]
        
        if let info = credential.additionalInfo {
            query[kSecAttrLabel as String] = info
        } else {
            query[kSecAttrLabel as String] = ""
        }
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainWrapperError.unhandledError(status: status)
        }
    }
    
    /// Fetch a Generic Credential from the Keychain database. It searches on the database by filter provided through parameters.
    /// - Parameters:
    ///   - account: the account that we are looking for its credential
    ///   - additionalInfo: additional key for searching - optional
    /// - Throws:
    ///     - `KeychainWrapperError.notFound` couldn't find any data by this parameters
    ///     - `KeychainWrapperError.unhandledError` if any unexpected error occure in `Keychain` API with associated value `status`
    ///     - `KeychainWrapperError.unexpectedPasswordData` if there is a problem in converting back data from database
    func fetchGenericCredential(account: String, additionalInfo: String?) throws -> GenericCredential {
        var query: [String:Any] = [kSecClass as String: kSecClassGenericPassword,
                                   kSecAttrAccount as String: account,
                                   kSecMatchLimit as String: kSecMatchLimitOne,
                                   kSecReturnData as String: true,
                                   kSecReturnAttributes as String: true]
        if let info = additionalInfo {
            query[kSecAttrLabel as String] = info
        }
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status != errSecItemNotFound else {
            throw KeychainWrapperError.notFound
        }
        guard status == errSecSuccess else {
            throw KeychainWrapperError.unhandledError(status: status)
        }
        guard let existingItem = result as? [String:Any],
            let existingData = existingItem[kSecValueData as String] as? Data,
            let existingPassword = String(data: existingData, encoding: .utf8),
            let existingAccount = existingItem[kSecAttrAccount as String] as? String else {
                throw KeychainWrapperError.unexpectedPasswordData
        }
        let existingAdditionalInfo = existingItem[kSecAttrLabel as String] as? String
        
        let genericCredential = GenericCredential(account: existingAccount,
                                                  password: existingPassword,
                                                  additionalInfo: existingAdditionalInfo)
        return genericCredential
    }
    
    
    /// Update a Generic Credential - any parameter that not nil will update
    /// - Parameters:
    ///   - item: item that you want to update
    ///   - account: new account - optional
    ///   - additionalInfo: new key - optional
    /// - Throws:
    ///     - `KeychainWrapperError.notFound`  couldn't find any data by this item
    ///     - `KeychainWrapperError.unhandledError`  if any unexpected error occure in `Keychain` API with associated value `status`
    func updateGenericCredential(for item: GenericCredential, account: String?, additionalInfo: String?) throws {
        var query: [String:Any] = [kSecClass as String: kSecClassGenericPassword,
                                   kSecAttrAccount as String: item.account,
                                   kSecMatchLimit as String: kSecMatchLimitOne]
        
        if let info = item.additionalInfo {
            query[kSecAttrLabel as String] = info
        }
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        guard status != errSecItemNotFound else {
            throw KeychainWrapperError.notFound
        }
        guard status == errSecSuccess else {
            throw KeychainWrapperError.unhandledError(status: status)
        }
        var newQuery: [String:Any] = [:]
        
        if let account = account {
            newQuery[kSecAttrAccount as String] = account
        }
        
        if let additionalInfo = additionalInfo {
            newQuery[kSecAttrLabel as String] = additionalInfo
        }
        let newStatus = SecItemUpdate(query as CFDictionary, newQuery as CFDictionary)
        guard newStatus == errSecSuccess else {
            throw KeychainWrapperError.unhandledError(status: status)
        }
    }
    
    /// Delete an existing Generic Credential from database
    /// - Parameter item: item you want to delete
    /// - Throws:
    ///     - `KeychainWrapperError.unhandledError` if any unexpected error occure in `Keychain` API with associated value `status`
    func deleteGenericCredential(for item: GenericCredential) throws {
        var query: [String:Any] = [kSecClass as String: kSecClassGenericPassword,
                                   kSecAttrAccount as String: item.account,
                                   kSecMatchLimit as String: kSecMatchLimitOne]
        
        if let info = item.additionalInfo {
            query[kSecAttrLabel as String] = info
        }
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else {
            throw KeychainWrapperError.unhandledError(status: status)
        }
    }
    
    func deleteAllTestData(for account: String) {
        #if DEBUG
        let query: [String:Any] = [kSecClass as String: kSecClassInternetPassword,
                                   kSecAttrAccount as String: account,
                                   kSecMatchLimit as String: kSecMatchLimitAll]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("********************************** \(status) **********************************")
        }
        
        let query2: [String:Any] = [kSecClass as String: kSecClassGenericPassword,
                                   kSecAttrAccount as String: account,
                                   kSecMatchLimit as String: kSecMatchLimitAll]
        
        let status2 = SecItemDelete(query2 as CFDictionary)
        if status2 != errSecSuccess {
            print("********************************** \(status2) **********************************")
        }
        #endif
    }
}
