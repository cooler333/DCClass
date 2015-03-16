//
//  DCBundleHelper.h
//  
//
//  Created by Дмитрий Утьманов on 12/03/15.
//
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kDCImageBundleKey @"ImageBundle.bundle"


@interface DCBundleHelper : NSObject

+ (NSBundle *)bundleWithIdentifier:(NSString *)identifier;
+ (UIImage *)getImageNamed:(NSString *)imageName;

@end
