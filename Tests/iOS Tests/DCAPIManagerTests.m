//
//  iOS_Test_Tests.m
//  iOS Test Tests
//
//  Created by Dmitriy Utmanov on 09/03/15.
//  Copyright (c) 2015 Dmitriy Utmanov. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <DCClass/DCAPIManager.h>

NSString * const DCClassTestsBaseURLString = @"https://httpbin.org/";


@interface APIManagerTests : XCTestCase

@end


@implementation APIManagerTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
  [DCAPIManager setSharedManagerWithBaseURL:[NSURL URLWithString:DCClassTestsBaseURLString]];
}

- (void)tearDown {
  [[DCAPIManager sharedManager] invalidateSessionCancelingTasks:YES];
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testDateFormatter {
  // Set the flag to YES
  if ([DCAPIManager sharedManager].dateFormatter == nil) {
    XCTAssert(NO, @"Not Pass");
  }
  XCTAssert(YES, @"Pass");
}

- (void)testBaseURL {
  NSString *absoluteString = [DCAPIManager sharedManager].baseURL.absoluteString;
  if (absoluteString == nil) {
    XCTAssert(NO, @"Not Pass");
  }
  XCTAssert(YES, @"Pass");
}

@end
