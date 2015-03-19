//
//  ViewController.m
//  DCClass iOS Example
//
//  Created by Dmitriy Utmanov on 08/03/15.
//  Copyright (c) 2015 Dmitriy Utmanov. All rights reserved.
//


#import "ViewController.h"

static NSString * const kCellReuseIdentifier = @"CellReuseIdentifier";

typedef NS_ENUM(NSUInteger, DCClassList) {
  DCClassListAPIManager = 0,
  DCClassListColor,
  DCClassListKeychainWrapper,
};


@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic) UITableView *tableView;

@end


@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
}

#pragma mark - Private Methods

- (NSString *)getTitleForRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.row) {
    case DCClassListAPIManager:
      return @"APIManager";
      break;
      
    case DCClassListColor:
      return @"Color";
      break;
      
    case DCClassListKeychainWrapper:
      return @"KeychainWrapper";
      break;
      
//    case DCClassListNavigationController:
//      return @"NavigationController";
//      break;
      
//    case DCClassListSideMenuViewController:
//      return @"SideMenuViewController";
//      break;
      
//    case DCClassListTableViewCell:
//      return @"TableViewCell";
//      break;
      
//    case DCClassListViewController:
//      return @"ViewController";
//      break;
      
    default:
      return nil;
      break;
  }
}

#pragma mark - DCViewControllerProtocol

- (void)cleanView {
  
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
  return cell;
}

@end
