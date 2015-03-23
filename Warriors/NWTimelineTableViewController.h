//
//  NWTimeineTableViewController.h
//  Warriors
//
//  Created by Duc Ho on 3/18/15.
//  Copyright (c) 2015 brianhollc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface NWTimelineTableViewController : UITableViewController

@property (strong, nonatomic) Person *personToPass;
@property (strong, nonatomic) Event *eventToPass;

@end
