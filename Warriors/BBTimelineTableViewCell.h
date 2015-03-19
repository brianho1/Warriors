//
//  BBTimelineTableViewCell.h
//  BoboiOs
//
//  Created by Duc Ho on 2/24/15.
//  Copyright (c) 2015 self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "Person.h"

@interface BBTimelineTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eventPicture;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekdayLabel;

@end
