//
//  AppDelegate.h
//  DCClass iOS Example
//
//  Created by Dmitriy Utmanov on 08/03/15.
//  Copyright (c) 2015 Dmitriy Utmanov. All rights reserved.
//


#import "MenuTableViewCell.h"

#import "DCColor.h"
#import "UILabel+Size.h"


static CGFloat const kMenuTableViewCellMinHeight = 44.0f;


@interface MenuTableViewCell ()

@property(nonatomic) UILabel *titleLabel;

@end


@implementation MenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    [self updateView];
    [self configureCellForHighlighedState:NO];
  }
  return self;
}

- (void)configureCell {
  CGRect rect = self.contentView.bounds;
  CGFloat width = CGRectGetWidth(rect);
  
  CGFloat textLabelWidth = width - 30.0f * 2.0f;
  CGFloat textLabelHeght = [self.titleLabel heightWithMaxWidth:textLabelWidth];
  
  CGFloat contentHeight = (kMenuTableViewCellMinHeight - 23.0f * 2.0f);
  CGFloat textLabelTop = 0.0f;
  if (textLabelHeght < contentHeight) {
    textLabelTop = (contentHeight - textLabelHeght) / 2.0f;
  }
  self.titleLabel.frame = CGRectMake(30.0f, 23.0f + textLabelTop, textLabelWidth, textLabelHeght);

}

- (CGFloat)heightForCell {
  [super heightForCell];
  
  CGFloat height = CGRectGetMaxY(self.titleLabel.frame);
  height += 23.0f;
  
  if (height < kMenuTableViewCellMinHeight) {
    height = kMenuTableViewCellMinHeight;
  }
  return height;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  
  self.titleLabel.text = nil;
  
  [self updateView];
}

- (void)updateView {
  // Do some additional actions
}

- (void)configureCellForHighlighedState:(BOOL)isHighlighed {
  // Change color for highlighed state
  self.titleLabel.backgroundColor = [DCColor clearColor];
  
  if (isHighlighed) {
    self.contentView.backgroundColor = [DCColor cyanColor];
    self.titleLabel.textColor = [DCColor grayColor];
  } else {
    self.contentView.backgroundColor = [DCColor blueColor];
    self.titleLabel.textColor = [DCColor cyanColor];
  }
}

@end
