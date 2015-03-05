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

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//  [super pushViewController:viewController animated:animated];
//  
//  UINavigationBar *nb = viewController.navigationController.navigationBar;
//  UIImage *backIndicatorImage = [UIImage imageNamed:@"back_bar_button_item"];
//  backIndicatorImage = [backIndicatorImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//  nb.backIndicatorImage = backIndicatorImage;
//  nb.backIndicatorTransitionMaskImage = backIndicatorImage;
//  
//  UIBarButtonItem *nbbbi = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
//  viewController.navigationItem.backBarButtonItem = nbbbi;
//}

@end
