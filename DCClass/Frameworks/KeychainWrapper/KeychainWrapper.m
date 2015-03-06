//
//  KeychainWrapper.m
//  ChristmasKeeper
//
//  Created by Ray Wenderlich on 12/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


#import "KeychainWrapper.h"


@implementation KeychainWrapper
// *** NOTE *** This class is ARC compliant - any references to CF classes must be paired with a "__bridge" statement to 
// cast between Objective-C and Core Foundation Classes.  WWDC 2011 Video "Introduction to Automatic Reference Counting" explains this.
// *** END NOTE ***
+ (NSMutableDictionary *)setupSearchDirectoryForIdentifier:(NSString *)identifier {
    
    // Setup dictionary to access keychain.
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];  
    // Specify we are using a password (rather than a certificate, internet password, etc).
    searchDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    // Uniquely identify this keychain accessor.
    searchDictionary[(__bridge id)kSecAttrService] = kAppNameStringKeychainKey;
	
    // Uniquely identify the account who will be accessing the keychain.
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    searchDictionary[(__bridge id)kSecAttrGeneric] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecAttrAccount] = encodedIdentifier;
	
    return searchDictionary; 
}

+ (NSData *)searchKeychainCopyMatchingIdentifier:(NSString *)identifier {
    
    NSMutableDictionary *searchDictionary = [self setupSearchDirectoryForIdentifier:identifier];
    // Limit search results to one.
    searchDictionary[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
	
    // Specify we want NSData/CFData returned.
    searchDictionary[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
	
    // Search.
    NSData *result = nil;   
    CFTypeRef foundDict = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, &foundDict);
    
    if (status == noErr) {
        result = (__bridge_transfer NSData *)foundDict;
    } else {
        result = nil;
    }
    
    return result;
}

+ (NSString *)keychainStringFromMatchingIdentifier:(NSString *)identifier {
    NSData *valueData = [self searchKeychainCopyMatchingIdentifier:identifier];
    if (valueData) {
        NSString *value = [[NSString alloc] initWithData:valueData encoding:NSUTF8StringEncoding];
        return value;
    } else {
        return nil;
    }
}

+ (NSString *)keychainTokenString {
    return [self keychainStringFromMatchingIdentifier:kTokenStringKeychainKey];
}

+ (BOOL)setKeychainTokenString:(NSString *)tokenString {
    return [self createKeychainValue:tokenString forIdentifier:kTokenStringKeychainKey];
}

+ (void)deleteKeychainTokenString {
    [self deleteItemFromKeychainWithIdentifier:kTokenStringKeychainKey];
}

+ (NSString *)keychainIDString {
    return [self keychainStringFromMatchingIdentifier:kIDStringKeychainKey];
}

+ (BOOL)setKeychainIDString:(NSString *)IDString {
    return [self createKeychainValue:IDString forIdentifier:kIDStringKeychainKey];
}

+ (void)deleteKeychainIDString {
    [self deleteItemFromKeychainWithIdentifier:kIDStringKeychainKey];
}

+ (BOOL)createKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier {
    
    NSMutableDictionary *dictionary = [self setupSearchDirectoryForIdentifier:identifier];
    NSData *valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
    dictionary[(__bridge id)kSecValueData] = valueData;
    
    // Protect the keychain entry so it's only valid when the device is unlocked.
    dictionary[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
    
    // Add.
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
	
    // If the addition was successful, return. Otherwise, attempt to update existing key or quit (return NO).
    if (status == errSecSuccess) {
        return YES;
    } else if (status == errSecDuplicateItem){
        return [self updateKeychainValue:value forIdentifier:identifier];
    } else {
        return NO;
    }
}

+ (BOOL)updateKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier  {
    
    NSMutableDictionary *searchDictionary = [self setupSearchDirectoryForIdentifier:identifier];
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    NSData *valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
    updateDictionary[(__bridge id)kSecValueData] = valueData;
	
    // Update.
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)searchDictionary, (__bridge CFDictionaryRef)updateDictionary);
	
    if (status == errSecSuccess) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)deleteItemFromKeychainWithIdentifier:(NSString *)identifier  {
    NSMutableDictionary *searchDictionary = [self setupSearchDirectoryForIdentifier:identifier];
    CFDictionaryRef dictionary = (__bridge CFDictionaryRef)searchDictionary;
    
    //Delete.
    SecItemDelete(dictionary);
}


//+ (BOOL)compareKeychainValueForMatchingPass:(NSString *)passHash  {
//    if ([[self keychainStringFromMatchingIdentifier:PIN_SAVED] isEqualToString:[self securedSHA256DigestHashForPIN:pinHash]]) {
//        return YES;
//    } else {
//        return NO;
//    }    
//}

// This is where most of the magic happens (the rest of it happens in computeSHA256DigestForString: method below).
// Here we are passing in the hash of the PIN that the user entered so that we can avoid manually handling the PIN itself.
// Then we are extracting the username that the user supplied during setup, so that we can add another unique element to the hash.
// From there, we mash the user name, the passed-in PIN hash, and the secret key (from ChristmasConstants.h) together to create 
// one long, unique string.
// Then we send that entire hash mashup into the SHA256 method below to create a "Digital Digest," which is considered
// a one-way encryption algorithm. "One-way" means that it can never be reverse-engineered, only brute-force attacked.
// The algorthim we are using is Hash = SHA256(Name + Salt + (Hash(PIN))). This is called "Digest Authentication."
+ (NSString *)securedSHA256DigestHashForPass:(NSString *)passHash {
//    // 1
//    NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:USERNAME];
//    name = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    // 2
//    NSString *computedHashString = [NSString stringWithFormat:@"%@%@%@", name, passHash, kSaltHash];
    
    NSString *computedHashString = [NSString stringWithFormat:@"%@%@", passHash, kSaltHash];
    // 3
    NSString *finalHash = [self computeSHA256DigestForString:computedHashString];
    NSLog(@"** Computed hash: %@ for SHA256 Digest: %@", computedHashString, finalHash);
    return finalHash;
}

// This is where the rest of the magic happens.
// Here we are taking in our string hash, placing that inside of a C Char Array, then parsing it through the SHA256 encryption method.
+ (NSString*)computeSHA256DigestForString:(NSString*)input  {
    
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    // This is an iOS5-specific method.
    // It takes in the data, how much data, and then output format, which in this case is an int array.
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    
    // Setup our Objective-C output.
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    // Parse through the CC_SHA256 results (stored inside of digest[]).
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

@end
