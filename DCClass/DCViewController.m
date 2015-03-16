//
//  DCViewController.m
//  DCClass
//
//  Created by Дмитрий Утьманов on 26/02/15.
//  Copyright (c) 2015 cooler. All rights reserved.
//


#import "DCViewController.h"


@implementation DCViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
//  self.automaticallyAdjustsScrollViewInsets = NO;
//  self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self _configureView];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self _configureView];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  [self _configureView];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  [self _configureView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  [self _cleanView];
}

- (void)dealloc {
  [self _cleanView];
}

#pragma mark - Layout MGMT

- (void)_configureView {
  CGRect rect = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
  if (!CGRectEqualToRect(rect, self.rect)) {
    _rect = rect;
    [self configureView];
  }
}

- (void)configureView {
  [NSException raise:NSInternalInconsistencyException format:@"You must override \"%@\" method in a \"%@\" ", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
}

- (CGFloat)statusBarHeight {
  CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
  return MIN(statusBarSize.width, statusBarSize.height);
}

- (CGFloat)heightForLabel:(UILabel *)label withMaxWidth:(CGFloat)width {
  return [self sizeForLabel:label withMaxWidth:width].height;
}

- (CGSize)sizeForLabel:(UILabel *)label withMaxWidth:(CGFloat)width {
  return [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
}

#pragma mark - Memory MGMT

- (void)_cleanView {
  if(self.isViewLoaded && self.view.window == nil) {
    [self cleanView];
    self.view = nil;
  }
}

- (void)cleanView {
  [NSException raise:NSInternalInconsistencyException format:@"You must override \"%@\" method in a \"%@\" ", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
}

#pragma mark - Data MGMT

- (void)configureViewForDataDictionary:(NSDictionary *)dataDictionary {
  _dataDictionary = [NSDictionary dictionary];
  if (dataDictionary != nil) {
    _dataDictionary = [NSDictionary dictionaryWithDictionary:dataDictionary];
  }
}

@end
