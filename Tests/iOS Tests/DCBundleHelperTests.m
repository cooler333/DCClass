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
#import <DCClass/DCLog.h>


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
  NSBundle *bundle = [DCBundleHelper mainBundle];
  DCLog(@"bundle: %@", bundle);
  XCTAssert(bundle != nil, @"Pass");
}

- (void)testImageFromBundle {
  UIImage *menuIconImage = [DCBundleHelper getImageNamed:@"menu_icon.png"];
  DCLog(@"image: %@", menuIconImage);
  XCTAssertTrue(menuIconImage != nil, @"Pass");
}

@end
