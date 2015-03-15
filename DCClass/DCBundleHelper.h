//
//  DCBundleHelper.h
//  
//
//  Created by Дмитрий Утьманов on 12/03/15.
//
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString * const kDCImageBundleName = @"ImageBundle";


@interface DCBundleHelper : NSObject

+ (NSBundle *)bundleWithIdentifier:(NSString *)identifier;
+ (UIImage *)getImageNamed:(NSString *)name fromBundleWithIdentifier:(NSString *)identifier;

@end
