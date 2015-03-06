//
//  DCSideMenuViewController.h
//  DCClass
//
//  Created by Дмитрий Утьманов on 26/02/15.
//  Copyright (c) 2015 cooler. All rights reserved.
//


#import "DCViewController.h"


@protocol DCSideMenuViewControllerDataSource <NSObject>

- (UIViewController *)viewControllerForMenuItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@protocol DCSideMenuViewControllerDelegate <NSObject>

- (void)willSelectMenuItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)didSelectMenuItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface DCSideMenuViewController : DCViewController

@property(nonatomic,readonly) NSIndexPath *selectedMenuItemIndexPath;

@property(nonatomic) CGFloat menuWidthInPercent;

@property(nonatomic,weak) id <DCSideMenuViewControllerDataSource> dataSource;
@property(nonatomic,weak) id <DCSideMenuViewControllerDelegate>   delegate;

- (instancetype)initWithMenuVC:(UIViewController *)menuVC;

- (void)selectMenuItemAtIndexPath:(NSIndexPath *)indexPath;

@end
