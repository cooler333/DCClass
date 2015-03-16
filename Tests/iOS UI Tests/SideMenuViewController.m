//
//  AppDelegate.h
//  DCClass iOS Example
//
//  Created by Dmitriy Utmanov on 08/03/15.
//  Copyright (c) 2015 Dmitriy Utmanov. All rights reserved.
//


#import "SideMenuViewController.h"

#import "DCNavigationController.h"
#import "DCColor.h"

#import "MenuViewController.h"
#import "ViewController.h"
#import "APIManagerExampleViewController.h"


@interface SideMenuViewController () <DCSideMenuViewControllerDataSource, DCSideMenuViewControllerDelegate>

@end


@implementation SideMenuViewController

- (instancetype)initWithMenuVC:(UIViewController *)menuVC {
  self = [super initWithMenuVC:menuVC];
  if (self) {
    self.delegate = self;
    self.dataSource = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self selectMenuItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
}

#pragma mark - DCSideMenuViewControllerDataSource

- (UIViewController *)viewControllerForMenuItemAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.row) {
    case 0: {
      APIManagerExampleViewController *contentVC = [[APIManagerExampleViewController alloc] init];
      DCNavigationController *contentNVC = [[DCNavigationController alloc] initWithRootViewController:contentVC];
      contentNVC.navigationBar.tintColor = [DCColor grayColor];
      contentNVC.navigationBar.barTintColor = [DCColor orangeColor];
      
      return contentNVC;
      break;
    }
    case 1: {
      ViewController *contentVC = [[ViewController alloc] init];
      contentVC.view.backgroundColor = [DCColor pinkColor];
            
      DCNavigationController *contentNVC = [[DCNavigationController alloc] initWithRootViewController:contentVC];
      contentNVC.navigationBar.tintColor = [DCColor grayColor];
      contentNVC.navigationBar.barTintColor = [DCColor orangeColor];
      return contentNVC;
      break;
    }
    case 2: {
      ViewController *contentVC = [[ViewController alloc] init];
      contentVC.view.backgroundColor = [DCColor redColor];
      
      ViewController *contentVC2 = [[ViewController alloc] init];
      contentVC2.view.backgroundColor = [DCColor yellowColor];
      
      DCNavigationController *contentNVC = [[DCNavigationController alloc] initWithRootViewController:contentVC];
      [contentNVC pushViewController:contentVC2 animated:NO];
      contentNVC.navigationBar.tintColor = [DCColor grayColor];
      contentNVC.navigationBar.barTintColor = [DCColor orangeColor];
      return contentNVC;
      break;
    }
  }
  return nil;
}

#pragma mark - DCSideMenuViewControllerDelegate

- (void)willDeselectMenuItemAtIndexPath:(NSIndexPath *)indexPath {
  // Save data or another custom actions
}

- (void)didDeselectMenuItemAtIndexPath:(NSIndexPath *)indexPath {
  [[(MenuViewController *)self.menuViewController tableView] deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)willSelectMenuItemAtIndexPath:(NSIndexPath *)indexPath {
  // Prepare data or another custom actions
}

- (void)didSelectMenuItemAtIndexPath:(NSIndexPath *)indexPath {
  [[(MenuViewController *)self.menuViewController tableView] selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

@end
