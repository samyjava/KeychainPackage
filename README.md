# KeychainPackage
![Swift](https://github.com/samyjava/KeychainPackage/workflows/Swift/badge.svg) [![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
## This package is a wrapper over Keychain API to make it easier to use.
If you want to store your user's secrets, you have to put these secrets in Keychain encrypted database. But Keychain API is not straightforward to use! So you can use this wrapper over the API and get rid of the complexity of Keychain.

## Usage
Like any other database, four primary operations(CRUD) are available.
* add
* fetch
* update
* delete

There are two types of Credential: InternetCredential and GenericCredential. 
- GenericCredential: use when you want to store just account, secret, and optional additional info. You can fetch this Credential by account and additionalInfo later.
- InternetCredential: use when you want to store more information about server and port rather than generic credentials.
The secret can be every encodable to utf8 sensitive data like passwords or API tokens.

## Requirements
* Xcode 11.x
* Swift 5.x

## Installation
KeychainPackage doesn't contain any external dependencies.
The installation is available just by Swift Package Manager.
[Adding Package Dependencies to Your App](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) 

## References
[Keychain Services](https://developer.apple.com/documentation/security/keychain_services)
