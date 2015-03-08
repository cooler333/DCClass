//
//  DCKeychainWrapper.m
//  DCClass iOS Example
//
//  Created by Dmitriy Utmanov on 08/03/15.
//  Copyright (c) 2015 Dmitriy Utmanov. All rights reserved.
//


#import "DCKeychainWrapper.h"


@implementation DCKeychainWrapper

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

@end
