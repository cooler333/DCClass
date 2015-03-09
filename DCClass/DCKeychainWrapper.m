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
  return [super keychainStringFromMatchingIdentifier:kTokenStringKeychainKey];
}

+ (BOOL)setKeychainTokenString:(NSString *)tokenString {
  return [super createKeychainValue:tokenString forIdentifier:kTokenStringKeychainKey];
}

+ (void)deleteKeychainTokenString {
  [self deleteItemFromKeychainWithIdentifier:kTokenStringKeychainKey];
}

+ (NSString *)keychainIDString {
  return [super keychainStringFromMatchingIdentifier:kIDStringKeychainKey];
}

+ (BOOL)setKeychainIDString:(NSString *)IDString {
  return [super createKeychainValue:IDString forIdentifier:kIDStringKeychainKey];
}

+ (void)deleteKeychainIDString {
  [self deleteItemFromKeychainWithIdentifier:kIDStringKeychainKey];
}

@end
