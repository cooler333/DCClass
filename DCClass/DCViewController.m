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

#pragma mark - Layout MGMT

#define SYSTEM_VERSION_LESS_THAN(X) ([[[UIDevice currentDevice] systemVersion] compare:X options:NSNumericSearch] == NSOrderedAscending)

- (CGFloat)getStatusBarHeight {
  CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
  if (SYSTEM_VERSION_LESS_THAN(@"8.0") && UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
    statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.width;
  }
  return statusBarHeight > 0.0f ? statusBarHeight : 20.0f;
}

- (CGFloat)getStatusBarWidth {
  if (SYSTEM_VERSION_LESS_THAN(@"8.0") && UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
    return [UIScreen mainScreen].bounds.size.height;
  }
  return [UIScreen mainScreen].bounds.size.width;
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
