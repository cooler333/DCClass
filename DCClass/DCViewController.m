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
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  [self _cleanView];
}

- (void)dealloc {
  [self _cleanView];
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
