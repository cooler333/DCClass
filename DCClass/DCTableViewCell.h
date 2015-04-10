//
//  DCTableViewCell.h
//  InSmile
//
//  Created by Дмитрий Утьманов on 29/10/14.
//  Copyright (c) 2014 Dmitry Utmanov. All rights reserved.
//


#import <UIKit/UIKit.h>


@protocol DCTableViewCellProtocol <NSObject>

@required
- (void)configureCell;

@end


@interface DCTableViewCell : UITableViewCell <DCTableViewCellProtocol>

@property(nonatomic,readonly) CGRect rect;

- (CGFloat)heightForCell;
- (void)configureCellForHighlighedState:(BOOL)isHighlighed;
- (void)configureCell;
- (void)updateView;


- (void)configureCellForDataDictionary:(NSDictionary *)dataDictionary;


@end
