//
//  DCColor.h
//  DCClass
//
//  Created by Дмитрий Утьманов on 26/02/15.
//  Copyright (c) 2015 cooler. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface DCColor : UIColor

// ...

+ (instancetype)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue alpha:(CGFloat)alpha;
+ (instancetype)testColor;

// ...

+ (instancetype)cyanColor;
+ (instancetype)blueColor;
+ (instancetype)yellowColor;
+ (instancetype)greenColor;
+ (instancetype)orangeColor;
+ (instancetype)redColor;
+ (instancetype)pinkColor;
+ (instancetype)grayColor;

@end
