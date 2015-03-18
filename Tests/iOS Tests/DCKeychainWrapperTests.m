//
//  DCKeychainWrapperTests.m
//  DCClass Tests
//
//  Created by Dmitriy Utmanov on 09/03/15.
//  Copyright (c) 2015 Dmitriy Utmanov. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "DCKeychainWrapper.h"


@interface DCKeychainWrapper (DCKeychainWrapperCategory)

+ (NSMutableDictionary *)setupSearchDirectoryForIdentifier:(NSString *)identifier;
+ (OSStatus)createKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier;
+ (OSStatus)updateKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier;

@end


@interface DCKeychainWrapperTests : XCTestCase

@end


@implementation DCKeychainWrapperTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testKeychain {
  OSStatus create = [DCKeychainWrapper createKeychainValue:@"AAA" forIdentifier:kTokenStringKeychainKey];
  if (create != errSecNotAvailable) {
    XCTAssert(create == 0, @"status != 0: %@", @(create));
    XCTAssert([DCKeychainWrapper keychainTokenString] != nil, @"keychainTokenString");
  }
  

  OSStatus update = [DCKeychainWrapper updateKeychainValue:@"BBB" forIdentifier:kTokenStringKeychainKey];
  if (update != errSecNotAvailable) {
    XCTAssert(update == 0, @"status != 0: %@", @(update));
    XCTAssert([DCKeychainWrapper keychainTokenString] != nil, @"keychainTokenString");
  }
}

- (void)testIDString {
  OSStatus set = [DCKeychainWrapper setKeychainIDString:@"111"];
  if (set != errSecNotAvailable) {
    XCTAssertTrue([DCKeychainWrapper keychainIDString] != nil, @"keychainIDString");
    
    BOOL isSetting = [[DCKeychainWrapper keychainIDString] isEqualToString:@"111"];
    XCTAssertTrue(isSetting, @"Pass");
    
    [DCKeychainWrapper deleteKeychainIDString];
    BOOL isRemoved = [DCKeychainWrapper keychainIDString] == nil;
    XCTAssert(isRemoved, @"Pass");
  }
}

- (void)testTokenString {
  OSStatus set = [DCKeychainWrapper setKeychainTokenString:@"AFADfdfsdLHJDFHjsdjfsdfs"];
  if (set != errSecNotAvailable) {
    XCTAssert([DCKeychainWrapper keychainTokenString] != nil, @"keychainTokenString");

    BOOL isSetting = [[DCKeychainWrapper keychainTokenString] isEqualToString:@"AFADfdfsdLHJDFHjsdjfsdfs"];
    XCTAssert(isSetting, @"Pass");
    
    [DCKeychainWrapper deleteKeychainTokenString];
    BOOL isRemoved = [DCKeychainWrapper keychainTokenString] == nil;
    XCTAssert(isRemoved, @"Pass");
  }
}

@end
