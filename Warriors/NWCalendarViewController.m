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

@interface NWCalendarViewController () <CLWeeklyCalendarViewDelegate>
@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *eventsByDate;

@end

static CGFloat CALENDER_VIEW_HEIGHT = 150.f;

@implementation NWCalendarViewController

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
    cell.textLabel.text = event.title;
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
