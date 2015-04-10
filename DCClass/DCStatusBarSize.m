//
//  DCSize.m
//  
//
//  Created by Дмитрий Утьманов on 10/04/15.
//
//


#import "DCStatusBarSize.h"


@implementation DCStatusBarSize

#define SYSTEM_VERSION_LESS_THAN(X) ([[[UIDevice currentDevice] systemVersion] compare:X options:NSNumericSearch] == NSOrderedAscending)

+ (CGFloat)getHeight {
  CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
  if (SYSTEM_VERSION_LESS_THAN(@"8.0") && UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
    statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.width;
  }
  return statusBarHeight > 0.0f ? statusBarHeight : 20.0f;
}

+ (CGFloat)getWidth {
  if (SYSTEM_VERSION_LESS_THAN(@"8.0") && UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
    return [UIScreen mainScreen].bounds.size.height;
  }
  return [UIScreen mainScreen].bounds.size.width;
}

+ (CGSize)getSize {
  return CGSizeMake([self getWidth], [self getHeight]);
}

@end
