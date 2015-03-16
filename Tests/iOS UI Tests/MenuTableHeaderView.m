//
//  AppDelegate.h
//  DCClass iOS Example
//
//  Created by Dmitriy Utmanov on 08/03/15.
//  Copyright (c) 2015 Dmitriy Utmanov. All rights reserved.
//


#import "MenuTableHeaderView.h"

#import "DCColor.h"


@interface MenuTableHeaderView ()

@end


@implementation MenuTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [DCColor cyanColor];
    
    // Add Subview
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  // Configure View
}

@end
