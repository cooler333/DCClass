//
//  AppDelegate.h
//  DCClass iOS Example
//
//  Created by Dmitriy Utmanov on 08/03/15.
//  Copyright (c) 2015 Dmitriy Utmanov. All rights reserved.
//


#import "MenuViewController.h"

#import "MenuTableViewCell.h"
#import "MenuTableHeaderView.h"

#import "DCColor.h"
#import "DCSideMenuViewController.h"


@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic) UITableView *tableView;

@end


@implementation MenuViewController

static NSString * const kMenuTableViewCellReuseIdentifier = @"MenuTableViewCellReuseIdentifier";
static NSString * const kPrototypeMenuTableViewCellReuseIdentifier = @"kPrototypeMenuTableViewCellReuseIdentifier";

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [DCColor blueColor];
  
  self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  self.tableView.backgroundColor = [DCColor blueColor];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  [self.tableView registerClass:[MenuTableViewCell class] forCellReuseIdentifier:kPrototypeMenuTableViewCellReuseIdentifier];
  [self.tableView registerClass:[MenuTableViewCell class] forCellReuseIdentifier:kMenuTableViewCellReuseIdentifier];

  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  
  self.tableView.tableHeaderView = [[MenuTableHeaderView alloc] initWithFrame:CGRectZero];
  
  [self.view addSubview:self.tableView];
  
  [self configureView];
}

- (void)configureView {
  self.tableView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.rect), CGRectGetHeight(self.rect));
  UIView *view = self.tableView.tableHeaderView;
  view.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.rect), 92.0f);
  self.tableView.tableHeaderView = view;
}

- (void)cleanView {
  // ...
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPrototypeMenuTableViewCellReuseIdentifier];
  CGRect rect = cell.contentView.bounds;
  rect.size.width = CGRectGetWidth(self.tableView.frame);
  cell.contentView.bounds = rect;
  [self configureTableViewCell:cell forRowAtIndexPath:indexPath];
  CGFloat height = [cell heightForCell];
  return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMenuTableViewCellReuseIdentifier];
  [self configureTableViewCell:cell forRowAtIndexPath:indexPath];
  return cell;
}

- (void)configureTableViewCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger index = indexPath.row;
  
  NSMutableString *str = [[NSMutableString alloc] initWithString:@"Start."];
  for (NSInteger i = 0; i < index; i++) {
    [str appendString:@" New String."];
  }
  MenuTableViewCell *c = (MenuTableViewCell *)cell;
  c.textLabel.text = str;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  DCSideMenuViewController *smvc = (DCSideMenuViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
  [smvc selectMenuItemAtIndexPath:indexPath];
}

@end
