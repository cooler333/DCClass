//
//  KeychainWrapper.h
//  ChristmasKeeper
//
//  Created by Ray Wenderlich on 12/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


@import Foundation;
@import Security;
#import <CommonCrypto/CommonHMAC.h>


// Used to specify the token key used in accessing the Keychain.
#define kTokenStringKeychainKey @"tokenStringKeychainKey"
#define kIDStringKeychainKey @"IDStringKeychainKey"

// Used to specify the application used in accessing the Keychain.
#define kAppNameStringKeychainKey [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

// Used to help secure the pass.
// Ideally, this is randomly generated, but to avoid the unnecessary complexity and overhead of storing the Salt separately, we will standardize on this key.
// !!KEEP IT A SECRET!!
#define kSaltHash @"Ffm0vSOB1pv2wvGa2wvdj7RLHV8GrfxaZ84oGA8RsKdNRpxdAojXYg9iAjGadj7RLHV8GrfxaZ84oGA8RsKdNRpxdAojXYg9iAj"


@interface KeychainWrapper : NSObject

// Generic exposed method to search the keychain for a given value. Limit one result per search.
+ (NSData *)searchKeychainCopyMatchingIdentifier:(NSString *)identifier;

// Calls searchKeychainCopyMatchingIdentifier: and converts to a string value.
+ (NSString *)keychainStringFromMatchingIdentifier:(NSString *)identifier;

// Simple method to compare a passed in hash value with what is stored in the keychain.
// Optionally, we could adjust this method to take in the keychain key to look up the value.
//+ (BOOL)compareKeychainValueForMatchingPIN:(NSUInteger)pinHash;
+ (NSString *)keychainTokenString;
+ (BOOL)setKeychainTokenString:(NSString *)tokenString;
+ (void)deleteKeychainTokenString;

+ (NSString *)keychainIDString;
+ (BOOL)setKeychainIDString:(NSString *)IDString;
+ (void)deleteKeychainIDString;

// Default initializer to store a value in the keychain.  
// Associated properties are handled for you - setting Data Protection Access, Company Identifer (to uniquely identify string, etc).
+ (BOOL)createKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier;

// Updates a value in the keychain. If you try to set the value with createKeychainValue: and it already exists,
// this method is called instead to update the value in place.
+ (BOOL)updateKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier;

// Delete a value in the keychain.
+ (void)deleteItemFromKeychainWithIdentifier:(NSString *)identifier;

// Generates an SHA256 (much more secure than MD5) hash.
+ (NSString *)securedSHA256DigestHashForPass:(NSString *)passHash;
+ (NSString*)computeSHA256DigestForString:(NSString*)input;

@end
