//
//  DCKeychainWrapper.h
//  DCClass iOS Example
//
//  Created by Dmitriy Utmanov on 08/03/15.
//  Copyright (c) 2015 Dmitriy Utmanov. All rights reserved.
//


#import "KeychainWrapper.h"

// Used to specify the token key used in accessing the Keychain.
#define kTokenStringKeychainKey @"tokenStringKeychainKey"
#define kIDStringKeychainKey @"IDStringKeychainKey"


@interface DCKeychainWrapper : KeychainWrapper

+ (NSString *)keychainTokenString;
+ (OSStatus)setKeychainTokenString:(NSString *)tokenString;
+ (void)deleteKeychainTokenString;

+ (NSString *)keychainIDString;
+ (OSStatus)setKeychainIDString:(NSString *)IDString;
+ (void)deleteKeychainIDString;

@end
