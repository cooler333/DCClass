//
//  DCBundleHelperTests.m
//  DCClass Tests
//
//  Created by Дмитрий Утьманов on 12/03/15.
//  Copyright (c) 2015 Dmitriy Utmanov. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <DCClass/DCBundleHelper.h>


@interface DCBundleHelperTests : XCTestCase

@end


@implementation DCBundleHelperTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBundle {
  // This is an example of a functional test case.
  NSBundle *bundle = [DCBundleHelper bundleWithIdentifier:kDCImageBundleName];
  XCTAssert(bundle != nil, @"Pass");
  
  NSString *imageName = @"menu_icon";
  UIImage *image = [DCBundleHelper getImageNamed:imageName fromBundleWithIdentifier:kDCImageBundleName];
  XCTAssertTrue(image != nil, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
