//
//  BBModalSearchViewController.m
//  NetworkingWarriors
//
//  Created by Duc Ho on 3/10/15.
//  Copyright (c) 2015 brianhollc. All rights reserved.
//

#import "BBModalSearchViewController.h"
#import "UIView+UIViewExtension.h"
#import "UIImage+ImageEffects.h"
#import "NWTimelineTableViewController.h"

@interface BBModalSearchViewController () <UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, retain) NSMutableArray * people;
@property (strong, nonatomic) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *sqView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation BBModalSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self fetchAllPeople];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.sqView.frame.size.width, self.sqView.frame.size.height - 44)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self registerTableView:self.tableView];
    [self.sqView addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView reloadData];
    
}
-(void)viewWillAppear:(BOOL)animated {
//    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width - 5, self.view.frame.size.width - 5);
    self.sqView.layer.cornerRadius = 10;
    self.sqView.layer.masksToBounds = YES;
    
}

- (void)fetchAllPeople {
    // Determine if sort key is
    NSString *sortKey = @"lastName";
    BOOL ascending = [sortKey isEqualToString:@"lastName"] ? NO : YES;
    // Fetch entities with MagicalRecord
    self.people = [[Person findAllSortedBy:sortKey ascending:ascending] mutableCopy];
    
}

- (void)saveContext {
    // Save ManagedObjectContext using MagicalRecord
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)registerTableView:(UITableView *)tableView {
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.people.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];
    [self configureCell:cell atIndex:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath*)indexPath {
    
    Person *person = [self.people objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",person.firstName,person.lastName];
    cell.detailTextLabel.text = person.notes;
    // Setup AMRatingControl
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Person *person = [self.people objectAtIndex:indexPath.row];
    [self doneSelecting:person];
}




- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneSelecting:(Person *)person {
    //    NSLog(@"%@",self.parentViewController);
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate doneWithSearch:person];
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"doneSelecting" object:nil];
    }];
}

#pragma mark - Search Bar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([self.searchBar.text length] > 0) {
        [self doSearch];
    } else {
        [self fetchAllPeople];
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
    [self fetchAllPeople];
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
    self.people = [[Person findAllSortedBy:@"lastName"
                                 ascending:YES
                             withPredicate:[NSPredicate predicateWithFormat:@"(lastName contains[c] %@) OR (firstName contains[c] %@)", searchText, searchText]
                                 inContext:[NSManagedObjectContext defaultContext]] mutableCopy];
    // 3. Reload the table to show the query results.
    [self.tableView reloadData];
}






@end
