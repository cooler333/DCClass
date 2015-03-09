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

- (void)testIDString {
  [DCKeychainWrapper setKeychainIDString:@"111"];
  BOOL isSetting = [[DCKeychainWrapper keychainIDString] isEqualToString:@"111"];
  XCTAssertTrue(isSetting, @"Pass");
  
  [DCKeychainWrapper deleteKeychainIDString];
  BOOL isRemoved = [DCKeychainWrapper keychainIDString] == nil;
  XCTAssertTrue(isRemoved, @"Pass");
}

@end
