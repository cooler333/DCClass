//
//  DCBundleHelper.m
//  
//
//  Created by Дмитрий Утьманов on 12/03/15.
//
//


#import "DCBundleHelper.h"


@implementation DCBundleHelper

+ (NSBundle *)bundleWithIdentifier:(NSString *)localeIdentifier {
  static NSBundle *classBundle  = nil;
  static NSBundle *momentBundle = nil;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    classBundle = [NSBundle bundleForClass:[self class]];
    
    NSString *bundlePath = [classBundle pathForResource:localeIdentifier ofType:@"bundle"];
    momentBundle = [NSBundle bundleWithPath:bundlePath];
  });
  return momentBundle ?: classBundle;
}

+ (UIImage *)getImageNamed:(NSString *)name fromBundleWithIdentifier:(NSString *)identifier {
  NSString *imagePath = [NSString stringWithFormat:@"%@/%@", [self bundleWithIdentifier:identifier].resourcePath, name];
  UIImage *image = [UIImage imageNamed:imagePath];
  return image;
}

@end
