//
//  Credentials.swift
//  KeychainWrapper
//
//  Created by Yasaman Farahani Saba on 12/21/19.
//  Copyright © 2019 Dream Catcher. All rights reserved.
//

import Foundation


public struct InternetCredential: Equatable {
    var account: String
    var secret: String
    var server: String
    var port: Int?
    var additionalInfo: String?
}


public struct GenericCredential: Equatable {
    var account: String
    var secret: String
    var additionalInfo: String?
}
