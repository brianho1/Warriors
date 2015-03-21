//
//  NWTimeineTableViewController.m
//  Warriors
//
//  Created by Duc Ho on 3/18/15.
//  Copyright (c) 2015 brianhollc. All rights reserved.
//

#import "NWTimelineTableViewController.h"
#import "Event.h"
#import "BBTimelineTableViewCell.h"
//#import "BBPersonViewController.h"
#import "BBModalSearchViewController.h"
#import "UIImage+ImageEffects.h"
#import "UIView+UIViewExtension.h"
#import "BBEventInputViewController.h"


@interface NWTimelineTableViewController () <BBModalSearchViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *events;
@property (nonatomic) NSMutableArray *people;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) BBModalSearchViewController *modal;

@end

@implementation NWTimelineTableViewController

-(void)viewWillAppear:(BOOL)animated {
    
    [self fetchAllEvent];
    [self.tableView reloadData];
    //    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    self.tableView.frame = self.view.bounds;
    UIImage *background = [UIImage imageNamed:@"13.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.image = background;
    [self.tableView setBackgroundView:imageView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    SWRevealViewController *revealViewController = self.revealViewController;
//    if ( revealViewController )
//    {
//        [self.sidebarButton setTarget: self.revealViewController];
//        [self.sidebarButton setAction: @selector( revealToggle: )];
//        //        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//    }
    self.title = @"Timeline";
}

- (void)fetchAllEvent {
    // Determine if sort key is
    NSString *sortKey = @"time";
    BOOL ascending = [sortKey isEqualToString:@"time"] ? NO : YES;
    // Fetch entities with MagicalRecord
    self.events = [[Event findAllSortedBy:sortKey ascending:ascending] mutableCopy];
    
    for (Event *event in self.events) {
        [self.people addObject:event.person];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveContext {
    // Save ManagedObjectContext using MagicalRecord
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBTimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                                    forIndexPath:indexPath];
    cell.dayLabel.layer.frame = CGRectMake(cell.frame.size.width - 40 , 70, 30, 30);
    cell.timeLabel.layer.frame = CGRectMake(cell.frame.size.width - 90 , 50, 80, 30);
    cell.weekdayLabel.layer.frame = CGRectMake(cell.frame.size.width - 40 , 90, 30, 30);
    cell.nameLabel.layer.frame = CGRectMake(0, 10, cell.frame.size.width - 10, 30);
    cell.nameLabel.layer.cornerRadius = 5;
    cell.nameLabel.layer.masksToBounds = YES;
    cell.noteLabel.layer.frame = CGRectMake(100, 40, cell.frame.size.width - 130 - 40, 60);
    cell.noteLabel.numberOfLines = 2;
    cell.backgroundColor = [UIColor clearColor];
    //    [cell.noteLabel sizeToFit];
    
    
    [self configureCell:cell atIndex:indexPath];
    return cell;
}

////custom animation
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    // setup initial state (e.g. before animation)
//    cell.layer.shadowColor = [[UIColor blackColor] CGColor];
//    cell.layer.shadowOffset = CGSizeMake(10, 10);
//    cell.alpha = 0;
//    cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5);
//    cell.layer.anchorPoint = CGPointMake(0, 0.5);
//    
//    // define final state (e.g. after animation) & commit animation
//    [UIView beginAnimations:@"scaleTableViewCellAnimationID" context:NULL];
//    [UIView setAnimationDuration:0.7];
//    cell.layer.shadowOffset = CGSizeMake(0, 0);
//    cell.alpha = 1;
//    cell.layer.transform = CATransform3DIdentity;
//    [UIView commitAnimations];
//}

- (void)configureCell:(BBTimelineTableViewCell *)cell atIndex:(NSIndexPath*)indexPath {
    
    Event *event = [self.events objectAtIndex:indexPath.row];
    Person *person = event.person;
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",person.firstName,person.lastName];
    cell.noteLabel.text = event.note;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *formattedDateString = [dateFormatter stringFromDate:event.time];
    cell.timeLabel.text = formattedDateString;
    [dateFormatter setDateFormat:@"EEE"];
    cell.weekdayLabel.text = [dateFormatter stringFromDate:event.time];
    [dateFormatter setDateFormat:@"dd"];
    cell.dayLabel.text = [dateFormatter stringFromDate:event.time];
    NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Images"];
    // New Folder is your folder name
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:stringPath withIntermediateDirectories:NO attributes:nil error:&error];
    UIImage *image = [UIImage imageNamed:@"card.jpg"];
    cell.eventPicture.image = image;
    if (event.picture != nil)
    {
        NSString *fileName = [stringPath stringByAppendingFormat:@"%@.jpg",event.picture];
        image = [UIImage imageWithData:[[NSFileManager defaultManager] contentsAtPath:fileName]];
        cell.eventPicture.image = image;
    }
    cell.eventPicture.layer.cornerRadius = cell.eventPicture.frame.size.width/2;
    cell.eventPicture.layer.masksToBounds = YES;
    //    CGRect frame = cell.bannerImage.frame;
    //    frame.size.height = cell.contentView.frame.size.height/2;
    //    cell.bannerImage.frame = frame;
    cell.eventPicture.layer.borderWidth = 2;
    cell.eventPicture.layer.borderColor = [[UIColor whiteColor] CGColor];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Event *eventToRemove = self.events[indexPath.row];
        // Remove Image from local documents
        // Deleting an Entity with MagicalRecord
        [eventToRemove deleteEntity];
        [self saveContext];
        [self.events removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Search Bar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([self.searchBar.text length] > 0) {
        [self doSearch];
    } else {
        [self fetchAllEvent];
        [self.tableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    // Clear search bar text
    self.searchBar.text = @"";
    // Hide the cancel button
    self.searchBar.showsCancelButton = NO;
    // Do a default fetch of the beers
    [self fetchAllEvent];
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self doSearch];
}

- (void)doSearch {
    // 1. Get the text from the search bar.
    NSString *searchText = self.searchBar.text;
    // 2. Do a fetch on the beers that match Predicate criteria.
    // In this case, if the name contains the string
    self.events = [[Event findAllSortedBy:@"person.lastName"
                                ascending:YES
                            withPredicate:[NSPredicate predicateWithFormat:@"(person.lastName contains[c] %@) OR (person.firstName contains[c] %@)", searchText, searchText]
                                inContext:[NSManagedObjectContext defaultContext]] mutableCopy];
    // 3. Reload the table to show the query results.
    [self.tableView reloadData];
}

#pragma mark - back
- (IBAction)backButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - add
- (IBAction)buttonClick:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Please select an option"
                                                                   message:@"Adding a new event for new user or for existing user?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Add New" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self performSegueWithIdentifier:@"addEventForNewUser" sender:self];
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
    self.personToPass = person;
    [self performSegueWithIdentifier:@"didSelectExistingUser" sender:self];
}


- (void)showMainMenu:(NSNotification *)note {
    [self performSegueWithIdentifier:@"addEventForExistingUser" sender:self];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    BBPersonViewController *upcoming = segue.destinationViewController;
//    if ([[segue identifier] isEqualToString:@"editPerson"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        Event *event			   = self.events[indexPath.row];
//        upcoming.event		   = event;
//    } else if ([segue.identifier isEqualToString:@"addPerson"]) {
//        //        upcoming.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemCancel target:upcoming action:@selector(cancelAdd)];
//        //        upcoming.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonSystemItemAdd target:upcoming action:@selector(addNewPerson)];
//    }
    if ([segue.identifier isEqualToString:@"didSelectExistingUser"]) {
        //        UINavigationController *vc = segue.destinationViewController;
        //        NSArray *viewControllers = vc.viewControllers;
        UINavigationController *navController = segue.destinationViewController;
        BBEventInputViewController *eventInput = navController.viewControllers[0];
//        BBEventInputViewController *eventInput = segue.destinationViewController;
        eventInput.person = self.personToPass;
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
