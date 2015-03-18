//
//  NWMainViewControllerTableViewController.m
//  Warriors
//
//  Created by Duc Ho on 3/18/15.
//  Copyright (c) 2015 brianhollc. All rights reserved.
//

#import "NWMainViewControllerTableViewController.h"
#import "NWTimelineTableViewController.h"

@interface NWMainViewControllerTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NWMainViewControllerTableViewController {
    NSArray *menuItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.view.backgroundColor = [UIColor grayColor];
//    self.view.backgroundColor = [UIColor whiteColor];
    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2)];
    headview.backgroundColor = [UIColor grayColor];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2)];
    image.image = [UIImage imageNamed:@"blurrybackground.jpg"];
    [headview addSubview:image];
    UILabel *quote = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height/5 , self.view.frame.size.width - 20, 30)];
    quote.text = @"\"It's not what you know, but who you know that makes the difference.\"";
    quote.font = [UIFont fontWithName:@"BodoniSvtyTwoITCTT-BookIta" size:25];
    quote.textColor = [UIColor whiteColor];
    quote.numberOfLines = 0;
    [quote sizeToFit];
    quote.textAlignment = NSTextAlignmentCenter;
    [headview addSubview:quote];
    self.tableView.tableHeaderView = headview;
    UILabel * numberofPerson = [[UILabel alloc] initWithFrame:CGRectMake(20, headview.layer.frame.size.height - 50, 20, 20)];
    numberofPerson.text = @"52";
    UILabel * peopleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, headview.layer.frame.size.height - 30, 90, 20)];
    peopleLabel.text = @"Networks";
    peopleLabel.textColor = [UIColor whiteColor];
    numberofPerson.textColor = [UIColor whiteColor];
    [headview addSubview:numberofPerson];
    [headview addSubview:peopleLabel];
    menuItems = @[@"Timeline", @"Photos",@"Goals",@"Tags",@"Analytics",@"Favorites",@"Settings",@"Logout"];

    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 30, self.view.frame.size.width, 30)];
    footView.backgroundColor = [UIColor colorWithWhite:7.0 alpha:0.7];
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, footView.frame.size.height)];
    myLabel.text = @"Networking Warriors";
    myLabel.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:myLabel];
    self.tableView.tableFooterView = footView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (void)registerTableView:(UITableView *)tableView {
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"Timeline"]) {
        [self performSegueWithIdentifier:@"timeline" sender:self];
    }
}

#pragma mark - prepared for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"timeline"]) {
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
