//
//  DCColor.h
//  DCClass
//
//  Created by Дмитрий Утьманов on 26/02/15.
//  Copyright (c) 2015 cooler. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface DCColor : UIColor


+ (instancetype)testColor;
+ (instancetype)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue alpha:(CGFloat)alpha;


+ (instancetype)orangeColor;

+ (instancetype)darkBlueColor;
+ (instancetype)darkBlueTextColor;

+ (instancetype)greenColor;
+ (instancetype)darkGreenColor;

+ (instancetype)redColor;
+ (instancetype)darkRedColor;

@end
