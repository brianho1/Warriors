//
//  BBModalSearchViewController.h
//  Warriors
//
//  Created by Duc Ho on 3/18/15.
//  Copyright (c) 2015 brianhollc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@protocol BBModalSearchViewControllerDelegate;

@interface BBModalSearchViewController : UIViewController

@property (nonatomic, weak) id<BBModalSearchViewControllerDelegate> delegate;

@end

@protocol BBModalSearchViewControllerDelegate <NSObject>

- (void)doneWithSearch:(Person *)person;

@end