//
//  Event.h
//  Warriors
//
//  Created by Duc Ho on 3/19/15.
//  Copyright (c) 2015 brianhollc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * picture;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Person *person;

@end
