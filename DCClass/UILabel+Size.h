//
//  UILabel+Size.h
//  
//
//  Created by Дмитрий Утьманов on 10/04/15.
//
//


#import <UIKit/UIKit.h>


@interface UILabel (Size)

- (CGFloat)heightWithMaxWidth:(CGFloat)width;
- (CGSize)sizeWithMaxWidth:(CGFloat)width;

@end
