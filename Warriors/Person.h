//
//  Person.h
//  Warriors
//
//  Created by Duc Ho on 3/18/15.
//  Copyright (c) 2015 brianhollc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * businessCardPic;
@property (nonatomic, retain) NSString * cellPhone;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * linkedIn;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * officePhone;
@property (nonatomic, retain) NSNumber * overallSocre;
@property (nonatomic, retain) NSString * profilePicture;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSSet *events;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
