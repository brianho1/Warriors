//
//  UICollectionViewWaterfallCell.h
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface CHTCollectionViewWaterfallCell : UICollectionViewCell
@property (nonatomic, copy) NSString *displayString;
@property (strong, nonatomic) NSMutableArray *eventsWithPics;
@property (nonatomic, strong) IBOutlet UILabel *displayLabel;
@property (strong, nonatomic, readonly) UIImageView *imageView;
@property (nonatomic) NSInteger item;
@end
