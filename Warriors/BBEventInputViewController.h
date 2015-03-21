//
//  BBEventInputViewController.h
//  NetworkingWarriors
//
//  Created by Duc Ho on 3/11/15.
//  Copyright (c) 2015 brianhollc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "HPGrowingTextView.h"

@interface BBEventInputViewController : UIViewController  <HPGrowingTextViewDelegate>{
    HPGrowingTextView *textView;
}

-(void)resignTextView;

@property (strong, nonatomic) Person * person;

@end
