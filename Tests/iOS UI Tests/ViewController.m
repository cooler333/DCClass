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
  
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
  
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.view addSubview:self.tableView];
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
  cell.textLabel.text = [self getTitleForRowAtIndexPath:indexPath];
  return cell;
}

@end
