//
//  DCBundleHelper.m
//  
//
//  Created by Дмитрий Утьманов on 12/03/15.
//
//


#import "DCBundleHelper.h"

#import "DCLog.h"


@implementation DCBundleHelper

+ (NSBundle *)bundleWithIdentifier:(NSString *)identifier {
  static NSBundle *classBundle  = nil;
  static NSBundle *momentBundle = nil;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    Class aClass = [self class];
    classBundle = [NSBundle bundleForClass:aClass];
    
    NSString *bundlePath = [classBundle pathForResource:identifier ofType:@"bundle"];
    momentBundle = [NSBundle bundleWithPath:bundlePath];
  });
  
  DCLog(@"momentBundle: %@", momentBundle);
  DCLog(@"classBundle: %@", classBundle);
  
  return momentBundle ?: classBundle;
}

+ (UIImage *)getImageNamed:(NSString *)name fromBundleWithIdentifier:(NSString *)identifier {
  NSURL *bundleURL = [NSURL URLWithString:[self bundleWithIdentifier:identifier].bundlePath];
  
  NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
  NSString *str = [bundle pathForResource:@"menu_icon" ofType:@"png"];
  
  NSString *imagePath = [NSString stringWithFormat:@"%@", name];
  UIImage *image = [UIImage imageNamed:str];
  return image;
}

@end
