//
//  Credentials.swift
//  KeychainWrapper
//
//  Created by Yasaman Farahani Saba on 12/21/19.
//  Copyright © 2019 Dream Catcher. All rights reserved.
//

import Foundation


public struct InternetCredential {
    var account: String
    var password: String
    var server: String
    var port: Int?
    var additionalInfo: String?
}


public struct GenericCredential {
    var account: String
    var password: String
    var additionalInfo: String?
}
