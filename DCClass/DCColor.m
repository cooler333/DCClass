//
//  DCColor.m
//  DCClass
//
//  Created by Дмитрий Утьманов on 26/02/15.
//  Copyright (c) 2015 cooler. All rights reserved.
//


#import "DCColor.h"


@implementation DCColor

// ...

+ (instancetype)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue alpha:(CGFloat)alpha {
  return (DCColor *)[super colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

+ (instancetype)testColor {
  return [self colorWithR:255.0f G:0.0f B:0.0f alpha:0.5f];
}

// ...

+ (instancetype)cyanColor {
  return [self colorWithR:90 G:200 B:250 alpha:1.0];
}

+ (instancetype)blueColor {
  return [self colorWithR:0 G:122 B:255 alpha:1.0];
}

+ (instancetype)yellowColor {
  return [self colorWithR:255 G:204 B:0 alpha:1.0];
}

+ (instancetype)greenColor {
  return [self colorWithR:76 G:217 B:100 alpha:1.0];
}

+ (instancetype)orangeColor {
  return [self colorWithR:255 G:149 B:0 alpha:1.0];
}

+ (instancetype)redColor {
  return [self colorWithR:255 G:59 B:48 alpha:1.0];
}

+ (instancetype)pinkColor {
  return [self colorWithR:255 G:45 B:85 alpha:1.0];
}

+ (instancetype)grayColor {
  return [self colorWithR:142 G:142 B:147 alpha:1.0];
}

@end
