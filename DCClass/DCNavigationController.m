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

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.edgesForExtendedLayout = UIRectEdgeNone;
  
  UINavigationBar *navBar = self.navigationBar;
  navBar.barStyle = UIBarStyleDefault;
  navBar.translucent = NO;
  navBar.shadowImage = [[UIImage alloc] init];
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
  return UIBarPositionTopAttached;
}

@end
