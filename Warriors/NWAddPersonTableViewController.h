//
//  NWAddPersonTableViewController.h
//  Warriors
//
//  Created by Duc Ho on 3/18/15.
//  Copyright (c) 2015 brianhollc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "HPGrowingTextView.h"
#import "Person.h"

@interface NWAddPersonTableViewController : UIViewController <HPGrowingTextViewDelegate>{
    HPGrowingTextView *textView;
}

-(void)resignTextView;


@property (strong, nonatomic) Event * event;
@property (strong, nonatomic) Person *person;

@end
