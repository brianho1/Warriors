//
//  NWCalendarViewController.m
//  Warriors
//
//  Created by Duc Ho on 3/20/15.
//  Copyright (c) 2015 brianhollc. All rights reserved.
//

#import "NWCalendarViewController.h"
#import "CLWeeklyCalendarView.h"
#import "Event.h"
#import "Person.h"
#import "BBEventInputViewController.h"
#import "BBModalSearchViewController.h"
#import "UIImage+ImageEffects.h"
#import "UIView+UIViewExtension.h"
#import "NWAddPersonTableViewController.h"

@interface NWCalendarViewController () <CLWeeklyCalendarViewDelegate, BBModalSearchViewControllerDelegate>
@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *eventsByDate;
@property (strong, nonatomic) BBModalSearchViewController *modal;

@end

static CGFloat CALENDER_VIEW_HEIGHT = 150.f;

@implementation NWCalendarViewController {
    Event *eventToPass;
    Person *personToPass;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.calendarView];
    self.title = @"Calendar";
    NSDate *date = [NSDate date];
    NSPredicate *pred = [self predicateToRetrieveEventsForDate:date];
        self.eventsByDate = [[Event findAllSortedBy:@"time"
                                          ascending:YES
                                      withPredicate:pred
                                          inContext:[NSManagedObjectContext defaultContext]] mutableCopy];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, -50, self.tableView.frame.size.width, self.tableView.frame.size.height)];
    iv.image = [UIImage imageNamed:@"blurrybackground.jpg"];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.clipsToBounds = YES;

//    [self.tableView.backgroundView addSubview:iv];
    [self.tableView insertSubview:iv atIndex:0];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CLWeeklyCalendarView *)calendarView
{
    if(!_calendarView){
        _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 22 + self.navigationController.navigationBar.frame.size.height, self.view.bounds.size.width, CALENDER_VIEW_HEIGHT)];
        _calendarView.delegate = self;
    }
    return _calendarView;
}




#pragma mark - CLWeeklyCalendarViewDelegate
-(NSDictionary *)CLCalendarBehaviorAttributes
{
    return @{
             CLCalendarWeekStartDay : @2,                 //Start Day of the week, from 1-7 Mon-Sun -- default 1
             //             CLCalendarDayTitleTextColor : [UIColor yellowColor],
             //             CLCalendarSelectedDatePrintColor : [UIColor greenColor],
             };
}



-(void)dailyCalendarViewDidSelect:(NSDate *)date
{
    //You can do any logic after the view select the date
    NSPredicate *pred = [self predicateToRetrieveEventsForDate:date];
    self.eventsByDate = [[Event findAllSortedBy:@"time"
                                      ascending:YES
                                  withPredicate:pred
                                      inContext:[NSManagedObjectContext defaultContext]] mutableCopy];
    [self.tableView reloadData];
}
- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.eventsByDate.count + 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
//                                                            forIndexPath:indexPath];
//    
//    if (cell == nil) {
       UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:@"Cell"];
//    }
//    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Create New";
        cell.detailTextLabel.text = @"Click to generate a new event";
    }
    else {
    Event *event = self.eventsByDate[indexPath.row - 1];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ - %@", event.person.firstName, event.person.lastName,event.title];
    cell.detailTextLabel.text = event.note;
    NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Images"];
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:stringPath withIntermediateDirectories:NO attributes:nil error:&error];
    NSString *fileName = [stringPath stringByAppendingFormat:@"%@.jpg",event.picture];
    UIImage *image = [UIImage imageWithData:[[NSFileManager defaultManager] contentsAtPath:fileName]];
    cell.imageView.image = image;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Please select an option"
                                                                       message:@"Adding a new event for new user or for existing user?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Add New" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self performSegueWithIdentifier:@"addEventForNewUserFromCalendar" sender:self];
                                                              }];
        UIAlertAction* existingUser = [UIAlertAction actionWithTitle:@"Existing Network" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //        [self performSegueWithIdentifier:@"addEventForExistingUser" sender:self];
            [self presentModalVC];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:defaultAction];
        [alert addAction:existingUser];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        NSLog(@"%ld",(long)indexPath.row);
        eventToPass = self.eventsByDate[indexPath.row -1];
        personToPass = eventToPass.person;
        [self performSegueWithIdentifier:@"viewEventFromCalendar" sender:self];
    }
}

#pragma mark - Modal
- (void)presentModalVC {
    self.modal = [[BBModalSearchViewController alloc] init];
    self.modal.view.frame = self.view.frame;
    self.modal.delegate = self;
    [self presentViewController:self.modal animated:YES completion:nil];
    
    UIImage* imageOfUnderlyingView = [self.view convertViewToImage];
    imageOfUnderlyingView = [imageOfUnderlyingView applyBlurWithRadius:20
                                                             tintColor:[UIColor colorWithWhite:0.5 alpha:0.1]
                                                 saturationDeltaFactor:1.3
                                                             maskImage:nil];
    
    self.modal.view.backgroundColor = [UIColor clearColor];
    
    UIImageView* backView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backView.image = imageOfUnderlyingView;
    backView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    [self.modal.view insertSubview:backView atIndex:0];
    
}

- (void)doneWithSearch:(Person *)person {
    personToPass = person;
    [self performSegueWithIdentifier:@"didSelectExistingUserFromCalendar" sender:self];
}



#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"viewEventFromCalendar"]) {
        //        UINavigationController *vc = segue.destinationViewController;
        //        NSArray *viewControllers = vc.viewControllers;
        UINavigationController *navController = segue.destinationViewController;
        BBEventInputViewController *eventInput = navController.viewControllers[0];
        //        BBEventInputViewController *eventInput = segue.destinationViewController;
        eventInput.person = personToPass;
        eventInput.event = eventToPass;
        eventInput.editingMode = YES;
        eventInput.sourceVC = @"Calendar";
    }
    else if ([segue.identifier isEqualToString:@"didSelectExistingUserFromCalendar"]) {
        UINavigationController *navController = segue.destinationViewController;
        BBEventInputViewController *eventInput = navController.viewControllers[0];
        //        BBEventInputViewController *eventInput = segue.destinationViewController;
        eventInput.person = personToPass;
        eventInput.event = nil;
        eventInput.editingMode = NO;
        eventInput.sourceVC = @"Calendar";
    }
    else if ([segue.identifier isEqualToString:@"addEventForNewUserFromCalendar"]) {
        UINavigationController *navController = segue.destinationViewController;
        NWAddPersonTableViewController *personInput = navController.viewControllers[0];
        //        BBEventInputViewController *eventInput = segue.destinationViewController;
        personInput.sourceVC = @"Calendar";
    }

    
}



#pragma mark - Predicate select current date

- (NSPredicate *) predicateToRetrieveEventsForDate:(NSDate *)aDate {
    
    // start by retrieving day, weekday, month and year components for the given day
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *todayComponents = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:aDate];
    NSInteger theDay = [todayComponents day];
    NSInteger theMonth = [todayComponents month];
    NSInteger theYear = [todayComponents year];
    
    // now build a NSDate object for the input date using these components
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:theDay];
    [components setMonth:theMonth];
    [components setYear:theYear];
    NSDate *thisDate = [gregorian dateFromComponents:components];
    
    // build a NSDate object for aDate next day
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:1];
    NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:thisDate options:0];
    
    // build the predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"time < %@ AND time > %@", nextDate, thisDate];
    
    return predicate;
    
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
