//
//  DCViewController.h
//  DCClass
//
//  Created by Дмитрий Утьманов on 26/02/15.
//  Copyright (c) 2015 cooler. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "DCCheckDevice.h"


@interface DCViewController : UIViewController


//@property(nonatomic,readonly) CGRect rect;
@property(nonatomic,strong,readonly) NSDictionary *dataDictionary;

- (void)configureViewForDataDictionary:(NSDictionary *)dataDictionary;
- (void)cleanView;

- (CGFloat)statusBarHeight;
- (CGFloat)heightForLabel:(UILabel *)label withMaxWidth:(CGFloat)width;
- (CGSize)sizeForLabel:(UILabel *)label withMaxWidth:(CGFloat)width;


@end
