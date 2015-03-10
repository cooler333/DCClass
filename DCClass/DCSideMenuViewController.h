//
//  DCSideMenuViewController.h
//  DCClass
//
//  Created by Дмитрий Утьманов on 26/02/15.
//  Copyright (c) 2015 cooler. All rights reserved.
//


#import "DCViewController.h"

typedef NS_ENUM(NSUInteger, DCMenuState) {
  DCMenuStateOpened,
  DCMenuStateClosed,
  DCMenuStateUnknown
};


@protocol DCSideMenuViewControllerDataSource <NSObject>

- (UIViewController *)viewControllerForMenuItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@protocol DCSideMenuViewControllerDelegate <NSObject>

- (void)willDeselectMenuItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)didDeselectMenuItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)willSelectMenuItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)didSelectMenuItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface DCSideMenuViewController : DCViewController

@property(nonatomic,readonly) UIViewController *menuViewController;
@property(nonatomic,readonly) UIView *menuView;

@property(nonatomic,readonly) UIViewController *contentViewController;
@property(nonatomic,readonly) UIView *contentView;

@property(nonatomic,readonly) NSIndexPath *selectedMenuItemIndexPath;
@property(nonatomic,readonly) DCMenuState menuState;

@property(nonatomic) CGFloat menuWidthInPercent;
@property(nonatomic) CGFloat menuTopOffsetInPercent;

@property(nonatomic,weak) id <DCSideMenuViewControllerDataSource> dataSource;
@property(nonatomic,weak) id <DCSideMenuViewControllerDelegate>   delegate;

- (instancetype)initWithMenuVC:(UIViewController *)menuVC;

- (void)selectMenuItemAtIndexPath:(NSIndexPath *)indexPath;

@end
