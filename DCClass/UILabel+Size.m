//
//  UILabel+Size.m
//  
//
//  Created by Дмитрий Утьманов on 10/04/15.
//
//


#import "UILabel+Size.h"


@implementation UILabel (Size)

- (CGFloat)heightWithMaxWidth:(CGFloat)width {
  return [self sizeWithMaxWidth:width].height;
}
- (CGSize)sizeWithMaxWidth:(CGFloat)width {
  return [self sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
}

@end
