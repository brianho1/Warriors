//
//  NWGoalViewController.m
//  Warriors
//
//  Created by Duc Ho on 3/28/15.
//  Copyright (c) 2015 brianhollc. All rights reserved.
//

#import "NWGoalViewController.h"
#import "UIAlertView+RWBlock.h"
#import "UIButton+RWBlock.h"

@import EventKit;

@interface NWGoalViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic) int lastStep;
@property (nonatomic) int stepValue;
@property (weak, nonatomic) IBOutlet UITextField *goalTextField;
@property (strong, nonatomic) UITableView *tableview;
@property (strong, nonatomic) EKEventStore *eventStore;
// Indicates whether app has access to event store.
@property (nonatomic) BOOL isAccessToEventStoreGranted;
// The data source for the table view
@property (strong, nonatomic) NSMutableArray *todoItems;
@property (strong, nonatomic) EKCalendar *calendar;
@property (copy, nonatomic) NSArray *reminders;


@end

@implementation NWGoalViewController

#pragma mark - Custom accessors

// 1
- (EKEventStore *)eventStore {
    if (!_eventStore) {
        _eventStore = [[EKEventStore alloc] init];
    }
    return _eventStore;
}

- (EKCalendar *)calendar {
    if (!_calendar) {
        
        // 1
        NSArray *calendars = [self.eventStore calendarsForEntityType:EKEntityTypeReminder];
        
        // 2
        NSString *calendarTitle = @"Be a Warrior!";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", calendarTitle];
        NSArray *filtered = [calendars filteredArrayUsingPredicate:predicate];
        
        if ([filtered count]) {
            _calendar = [filtered firstObject];
        } else {
            
            // 3
            _calendar = [EKCalendar calendarForEntityType:EKEntityTypeReminder eventStore:self.eventStore];
            _calendar.title = @"Be a Warrior!";
            _calendar.source = self.eventStore.defaultCalendarForNewReminders.source;
            
            // 4
            NSError *calendarErr = nil;
            BOOL calendarSuccess = [self.eventStore saveCalendar:_calendar commit:YES error:&calendarErr];
            if (!calendarSuccess) {
                // Handle error
            }
        }
    }
    return _calendar;
}

- (NSMutableArray *)todoItems {
    if (!_todoItems) {
        _todoItems = [@[@"Meet Caleb Hicks!", @"Slack to Chase Wasden", @"Send an email to Ben Norris!", @"Call a Random Person"] mutableCopy];
    }
    return _todoItems;
}

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Set Goal and Plan";
    UIImageView *iv = [[UIImageView alloc] initWithFrame:self.view.frame];
    iv.image = [UIImage imageNamed:@"blurrybackground.jpg"];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.clipsToBounds = YES;
    [self.goalTextField setBorderStyle:UITextBorderStyleNone];
//    self.goalTextField.layer.borderWidth
    [self.view insertSubview:iv atIndex:0];
    self.slider.maximumValue = 20;
    self.slider.minimumValue = 0;
    self.slider.value = 3;
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.stepValue = 1.0f;
    self.lastStep = (self.slider.value) / self.stepValue;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height - 200)];
    //add a header Label
    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    UILabel *subHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 20)];
    headerLabel.text = @"Plan on your next meeting";
    subHeaderLabel.text = @"Click 🔔 to sync with Apple Reminders";
    subHeaderLabel.backgroundColor = [UIColor clearColor];
    subHeaderLabel.font = [UIFont fontWithName:@"Avenir-Light" size:10];
    headerLabel.font = [UIFont fontWithName:@"Avenir-Light" size:20];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    subHeaderLabel.textAlignment = NSTextAlignmentCenter;
    [headview addSubview:headerLabel];
    [headview addSubview:subHeaderLabel];
    headview.backgroundColor = [UIColor grayColor];
    self.tableview.tableHeaderView = headview;
    self.tableview.layer.backgroundColor = [[UIColor clearColor] CGColor];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:self.tableview];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableview addGestureRecognizer:longPress];
    [self updateAuthorizationStatusToAccessEventStore];
    
    [self fetchReminders];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchReminders)
                                                 name:EKEventStoreChangedNotification object:nil];

    
}

- (void)sliderValueChanged:(UISlider *)sender {
    float newStep = roundf((self.slider.value) / self.stepValue);
    self.slider.value = newStep * self.stepValue;
    self.goalTextField.text = [NSString stringWithFormat:@"%ld",(long)roundf(sender.value)];
//    NSLog(@"slider value = %f", sender.value);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.todoItems count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier forIndexPath:indexPath];
    // Update cell content from data source.
    NSString *object = self.todoItems[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = object;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:20];
    cell.layer.backgroundColor = [[UIColor clearColor] CGColor];
    if (![self itemHasReminder:object]) {
        // Add a button as accessory view that says 'Add Reminder'.
        UIButton *addReminderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        addReminderButton.frame = CGRectMake(0.0, 0.0, 50, 30.0);
        [addReminderButton setTitle:@"🔔" forState:UIControlStateNormal];
        
        [addReminderButton addActionblock:^(UIButton *sender) {
            [self addReminderForToDoItem:object];
        } forControlEvents:UIControlEventTouchUpInside];
        
        cell.accessoryView = addReminderButton;
    } else {
        cell.accessoryView = nil;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", object];
        NSArray *reminders = [self.reminders filteredArrayUsingPredicate:predicate];
        EKReminder *reminder = [reminders firstObject];
        cell.imageView.image = (reminder.isCompleted) ? [UIImage imageNamed:@"checkmarkOn"] : [UIImage imageNamed:@"checkmarkOff"];
        
        if (reminder.dueDateComponents) {
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDate *dueDate = [calendar dateFromComponents:reminder.dueDateComponents];
            cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:dueDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *toDoItem = self.todoItems[indexPath.row];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", toDoItem];
    
    // Assume there are no duplicates...
    NSArray *results = [self.reminders filteredArrayUsingPredicate:predicate];
    EKReminder *reminder = [results firstObject];
    reminder.completed = !reminder.isCompleted;
    
    NSError *error;
    [self.eventStore saveReminder:reminder commit:YES error:&error];
    if (error) {
        // Handle error
    }
    
    cell.imageView.image = (reminder.isCompleted) ? [UIImage imageNamed:@"checkmarkOn"] : [UIImage imageNamed:@"checkmarkOff"];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *todoItem = self.todoItems[indexPath.row];
    
    // Remove to-do item.
    [self.todoItems removeObject:todoItem];
    [self deleteReminderForToDoItem:todoItem];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - IBActions

- (IBAction)addButtonPressed:(id)sender {
    
    // Display an alert view with a text input.
    UIAlertView *inputAlertView = [[UIAlertView alloc] initWithTitle:@"Add a new to-do item:" message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Add", nil];
    
    inputAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    __weak NWGoalViewController *weakSelf = self;
    
    // Add a completion block (using our category to UIAlertView).
    [inputAlertView setCompletionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        // If user pressed 'Add'...
        if (buttonIndex == 1) {
            
            UITextField *textField = [alertView textFieldAtIndex:0];
            NSString *string = [textField.text capitalizedString];
            [weakSelf.todoItems addObject:string];
            
            NSUInteger row = [weakSelf.todoItems count] - 1;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [weakSelf.tableview insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
    
    [inputAlertView show];
}

- (IBAction)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tableview];
    NSIndexPath *indexPath = [self.tableview indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshotFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableview addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                    // Black out.
                    cell.backgroundColor = [UIColor blackColor];
                } completion:nil];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [self.todoItems exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.tableview moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                
                // Undo the black-out effect we did.
                cell.backgroundColor = [UIColor clearColor];
                
            } completion:^(BOOL finished) {
                
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            sourceIndexPath = nil;
            break;
        }
    }
}

#pragma mark - Reminders

- (void)updateAuthorizationStatusToAccessEventStore {
    // 2
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    
    switch (authorizationStatus) {
            // 3
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted: {
            self.isAccessToEventStoreGranted = NO;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Access Denied"
                                                                message:@"This app doesn't have access to your Reminders." delegate:nil
                                                      cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alertView show];
            [self.tableview reloadData];
            break;
        }
            
            // 4
        case EKAuthorizationStatusAuthorized:
            self.isAccessToEventStoreGranted = YES;
            [self.tableview reloadData];
            break;
            
            // 5
        case EKAuthorizationStatusNotDetermined: {
            __weak NWGoalViewController *weakSelf = self;
            [self.eventStore requestAccessToEntityType:EKEntityTypeReminder
                                            completion:^(BOOL granted, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    weakSelf.isAccessToEventStoreGranted = granted;
                                                    [weakSelf.tableview reloadData];
                                                });
                                            }];
            break;
        }
    }
}

- (void)addReminderForToDoItem:(NSString *)item {
    // 1
    if (!self.isAccessToEventStoreGranted)
        return;
    
    // 2
    EKReminder *reminder = [EKReminder reminderWithEventStore:self.eventStore];
    reminder.title = item;
    reminder.calendar = self.calendar;
//    reminder.dueDateComponents = [self dateComponentsForDefaultDueDate];
    reminder.dueDateComponents = nil;
    // 3
    NSError *error = nil;
    BOOL success = [self.eventStore saveReminder:reminder commit:YES error:&error];
    if (!success) {
        // Handle error.
    }
    
    // 4
    NSString *message = (success) ? @"Reminder was successfully added!" : @"Failed to add reminder!";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
    [alertView show];
}

- (void)fetchReminders {
    if (self.isAccessToEventStoreGranted) {
        // 1
        NSPredicate *predicate =
        [self.eventStore predicateForRemindersInCalendars:@[self.calendar]];
        
        // 2
        [self.eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders) {
            // 3
            self.reminders = reminders;
            dispatch_async(dispatch_get_main_queue(), ^{
                // 4
                [self.tableview reloadData];
            });
        }];
    }
}

- (void)deleteReminderForToDoItem:(NSString *)item {
    // 1
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", item];
    NSArray *results = [self.reminders filteredArrayUsingPredicate:predicate];
    
    // 2
    if ([results count]) {
        [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSError *error = nil;
            // 3
            BOOL success = [self.eventStore removeReminder:obj commit:NO error:&error];
            if (!success) {
                // Handle delete error
            }
        }];
        
        // 4
        NSError *commitErr = nil;
        BOOL success = [self.eventStore commit:&commitErr];
        if (!success) {
            // Handle commit error.
        }
    }
}

#pragma mark - Helper methods

/** @brief Returns a customized snapshot of a given view. */
- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

- (NSDateComponents *)dateComponentsForDefaultDueDate {
    NSDateComponents *oneDayComponents = [[NSDateComponents alloc] init];
    oneDayComponents.day = 1;
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *tomorrow = [gregorianCalendar dateByAddingComponents:oneDayComponents toDate:[NSDate date] options:0];
    
    NSUInteger unitFlags = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *tomorrowAt4PM = [gregorianCalendar components:unitFlags fromDate:tomorrow];
    tomorrowAt4PM.hour = 16;
    tomorrowAt4PM.minute = 0;
    tomorrowAt4PM.second = 0;
    
    return tomorrowAt4PM;
}

- (BOOL)itemHasReminder:(NSString *)item {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", item];
    NSArray *filtered = [self.reminders filteredArrayUsingPredicate:predicate];
    return (self.isAccessToEventStoreGranted && [filtered count]);
}

- (IBAction)backPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
