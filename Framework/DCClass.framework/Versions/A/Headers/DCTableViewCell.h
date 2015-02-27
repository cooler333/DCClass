//
//  DCTableViewCell.h
//  InSmile
//
//  Created by Дмитрий Утьманов on 29/10/14.
//  Copyright (c) 2014 Dmitry Utmanov. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface DCTableViewCell : UITableViewCell

- (void)configureCellForDataDictionary:(NSDictionary *)dataDictionary;
- (CGFloat)heightForCell;
- (CGFloat)heightForLabel:(UILabel *)label andWidth:(CGFloat)width;
- (void)configureCellForHighlighedState:(BOOL)isHighlighed;

@end
