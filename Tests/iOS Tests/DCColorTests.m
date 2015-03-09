//
//  DCColorTests.m
//  DCClass Tests
//
//  Created by Dmitriy Utmanov on 09/03/15.
//  Copyright (c) 2015 Dmitriy Utmanov. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "DCColor.h"


@interface DCColorTests : XCTestCase

@end


@implementation DCColorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testColor {
  // This is an example of a functional test case.
  DCColor *color = [DCColor colorWithR:0.0f G:150.0f B:255.0f alpha:0.5f];
  CGFloat red;
  CGFloat green;
  CGFloat blue;
  CGFloat alpha;
  [color getRed:&red green:&green blue:&blue alpha:&alpha];
  
  
  CGFloat _red = 0.0f/255.0f;
  red  = round( red * 1000.0f)/1000.0f;
  _red = round( _red * 1000.0f)/1000.0f;

  CGFloat _green = 150.0f/255.0f;
  green  = round( green * 1000.0f)/1000.0f;
  _green = round( _green * 1000.0f)/1000.0f;
  
  CGFloat _blue = 255.0f/255.0f;
  blue  = round( blue * 1000.0f)/1000.0f;
  _blue = round( _blue * 1000.0f)/1000.0f;
  
  CGFloat _alpha = 0.5f;
  
  BOOL isEqual = red == _red && green == _green && blue == _blue && alpha == _alpha;
  XCTAssertTrue(isEqual, @"Pass");
}

@end
