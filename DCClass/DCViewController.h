//
//  DCViewController.h
//  DCClass
//
//  Created by Дмитрий Утьманов on 26/02/15.
//  Copyright (c) 2015 cooler. All rights reserved.
//


#import <UIKit/UIKit.h>


@protocol DCViewControllerProtocol <NSObject>

@required
- (void)configureView;

@end


@interface DCViewController : UIViewController <DCViewControllerProtocol>


@property(nonatomic,readonly) CGRect rect;


- (void)configureView;
- (void)cleanView;

- (CGFloat)statusBarHeight;
- (CGFloat)heightForLabel:(UILabel *)label withMaxWidth:(CGFloat)width;
- (CGSize)sizeForLabel:(UILabel *)label withMaxWidth:(CGFloat)width;


@end
