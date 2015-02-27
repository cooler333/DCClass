//
//  DCTableViewCell.m
//  InSmile
//
//  Created by Дмитрий Утьманов on 29/10/14.
//  Copyright (c) 2014 Dmitry Utmanov. All rights reserved.
//


#import "DCTableViewCell.h"


@implementation DCTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  [self configureCellHighlighed];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
  [super setHighlighted:highlighted animated:animated];
  [self configureCellHighlighed];
}

- (void)configureCellHighlighed {
  if (self.selected == YES || self.highlighted == YES) {
    [self configureCellForHighlighedState:YES];
  } else {
    [self configureCellForHighlighedState:NO];
  }
}

- (void)configureCellForHighlighedState:(BOOL)isHighlighed {
  // ...
}

- (CGFloat)heightForCell {
  return 44.0f;
}

- (CGFloat)heightForLabel:(UILabel *)label andWidth:(CGFloat)width {
  CGSize size = [label sizeThatFits:CGSizeMake(width, FLT_MAX)];
  return size.height;
}

- (void)configureCellForDataDictionary:(NSDictionary *)dataDictionary {
  // ...
}

@end
