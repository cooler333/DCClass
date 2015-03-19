//
//  DCNavigationController.m
//  InSmile
//
//  Created by Дмитрий Утьманов on 24/09/14.
//  Copyright (c) 2014 Dmitry Utmanov. All rights reserved.
//


#import "DCNavigationController.h"


@interface DCNavigationController () <UINavigationBarDelegate>

@end


@implementation DCNavigationController

@synthesize customTintColor = _customTintColor;
@synthesize customBarTintColor = _customBarTintColor;


- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor greenColor];
  
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.edgesForExtendedLayout = UIRectEdgeNone;
  
  UINavigationBar *navBar = self.navigationBar;
  navBar.barStyle = UIBarStyleDefault;
//  navBar.translucent = NO;
  navBar.shadowImage = [[UIImage alloc] init];
  
  navBar.tintColor = self.customTintColor;
  navBar.barTintColor = self.customBarTintColor;
}

- (void)setCustomTintColor:(UIColor *)customTintColor {
  if (_customTintColor != customTintColor) {
    _customTintColor = customTintColor;
    UINavigationBar *navBar = self.navigationBar;
    navBar.tintColor = customTintColor;
  }
}

- (UIColor *)customTintColor {
  if (_customTintColor) {
    return _customTintColor;
  }
  return self.navigationBar.tintColor;
}


- (void)setCustomBarTintColor:(UIColor *)customBarTintColor {
  if (_customBarTintColor != customBarTintColor) {
    _customBarTintColor = customBarTintColor;
    UINavigationBar *navBar = self.navigationBar;
    navBar.barTintColor = customBarTintColor;
  }
}

- (UIColor *)customBarTintColor {
  if (_customBarTintColor) {
    return _customBarTintColor;
  }
  return self.navigationBar.barTintColor;
}

@end
