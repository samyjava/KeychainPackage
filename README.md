# KeychainPackage

This package is a wrapper over Keychain API to make it easier to use.
It supports two types of Credential: InternetCredential and GenericCredential.
GenericCredential: use when you want to store just account, secret, and optional additional info. You can fetch this Credential by account and additionalInfo later.
InternetCredential: use when you want to store more information about server and port rather than generic credentials.
The secret can be every encodable to utf8 sensitive data like passwords or API tokens.
