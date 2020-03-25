//
//  KeychainWrapperError.swift
//  KeychainWrapper
//
//  Created by Yasaman Farahani Saba on 12/21/19.
//  Copyright © 2019 Dream Catcher. All rights reserved.
//

import Foundation


public enum KeychainWrapperError: Error {
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
    case notFound
}
