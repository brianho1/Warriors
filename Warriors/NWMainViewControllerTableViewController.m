//
//  NWMainViewControllerTableViewController.m
//  Warriors
//
//  Created by Duc Ho on 3/18/15.
//  Copyright (c) 2015 brianhollc. All rights reserved.
//

#import "NWMainViewControllerTableViewController.h"
#import "NWTimelineTableViewController.h"
#import "UICountingLabel.h"

@interface NWMainViewControllerTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NWMainViewControllerTableViewController {
    NSArray *menuItems;
    UIView *headview;
    UIImageView *image;
    UILabel *quote;
    float quoteheight;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.view.backgroundColor = [UIColor grayColor];
//    self.view.backgroundColor = [UIColor whiteColor];
    headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2)];
    headview.backgroundColor = [UIColor grayColor];
    image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2)];
    image.image = [UIImage imageNamed:@"blurrybackground.jpg"];
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.clipsToBounds = YES;
    [headview addSubview:image];
    quote = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height/5 , self.view.frame.size.width - 20, 30)];

    quote.text = [self randomQuote];
    quote.font = [UIFont fontWithName:@"BodoniSvtyTwoITCTT-BookIta" size:25];
    quote.textColor = [UIColor whiteColor];
    quote.numberOfLines = 0;
    [quote sizeToFit];
    quote.textAlignment = NSTextAlignmentCenter;
    quote.center = image.center;
    [headview addSubview:quote];
    self.tableView.tableHeaderView = headview;
    
    //Headview Stats
    float width = self.view.frame.size.width;
    float boxwidth = (width - 40)/3;
    UICountingLabel * numberofPerson = [[UICountingLabel alloc] initWithFrame:CGRectMake(10, headview.layer.frame.size.height - 35, boxwidth, 20)];
    numberofPerson.method = UILabelCountingMethodEaseInOut;
    numberofPerson.format = @"%d";
    [numberofPerson countFrom:1 to:52 withDuration:2];
    
    UILabel * peopleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, headview.layer.frame.size.height - 20, boxwidth, 20)];
    peopleLabel.text = @"NETWORKS";
    
    UICountingLabel * goal = [[UICountingLabel alloc] initWithFrame:CGRectMake(20 + boxwidth, headview.layer.frame.size.height - 35, boxwidth, 20)];
    goal.method = UILabelCountingMethodLinear;
    goal.format = @"%d";
    [goal countFrom:1 to:10 withDuration:2];
    
    UILabel * goalLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + boxwidth, headview.layer.frame.size.height - 20, boxwidth, 20)];
    goalLabel.text = @"GOAL/WEEK";

    UILabel * today = [[UILabel alloc] initWithFrame:CGRectMake(30 + 2*boxwidth, headview.layer.frame.size.height - 35, boxwidth, 20)];
    today.text = @"1";
    UILabel * todayLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 + 2*boxwidth, headview.layer.frame.size.height - 20, boxwidth, 20)];
    todayLabel.text = @"TODAY";
    //white textcolor
    peopleLabel.textColor = [UIColor whiteColor];
    numberofPerson.textColor = [UIColor whiteColor];
    goal.textColor = [UIColor whiteColor];
    goalLabel.textColor = [UIColor whiteColor];
    today.textColor = [UIColor whiteColor];
    todayLabel.textColor = [UIColor whiteColor];
    //change font size
    numberofPerson.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:12];
    peopleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:12];
    goal.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:12];
    goalLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:12];
    today.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:12];
    todayLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:12];
    //align number centered
    numberofPerson.textAlignment = NSTextAlignmentCenter;
    goal.textAlignment = NSTextAlignmentCenter;
    today.textAlignment = NSTextAlignmentCenter;
    peopleLabel.textAlignment = NSTextAlignmentCenter;
    goalLabel.textAlignment = NSTextAlignmentCenter;
    todayLabel.textAlignment = NSTextAlignmentCenter;
    //add to subview
    [headview addSubview:numberofPerson];
    [headview addSubview:peopleLabel];
    [headview addSubview:goal];
    [headview addSubview:goalLabel];
    [headview addSubview:today];
    [headview addSubview:todayLabel];

    menuItems = @[@"Timeline", @"Photos",@"Calendar",@"Goals",@"Tags",@"Analytics",@"Favorites",@"Settings",@"Logout"];

    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 30, self.view.frame.size.width, 30)];
    footView.backgroundColor = [UIColor colorWithWhite:7.0 alpha:0.7];
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, footView.frame.size.height)];
    myLabel.text = @"Networking Warriors";
    myLabel.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:myLabel];
    self.tableView.tableFooterView = footView;
    quoteheight = quote.frame.size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)randomQuote {
    NSString * frontQuote = @"";
    NSArray * quoteArray = @[@"\"Start by doing what's necessary; then do what's possible; and suddenly you are doing the impossible.\"",@"\"The best and most beautiful things in the world cannot be seen or even touched - they must be felt with the heart.\"",@"\"I can't change the direction of the wind, but I can adjust my sails to always reach my destination.\"",@"\"It's not what you know, but who you know that makes the difference.\""];
    int i = arc4random() % quoteArray.count;
    frontQuote = quoteArray[i];
    return frontQuote;
}

#pragma mark - Table view data source

//- (void)registerTableView:(UITableView *)tableView {
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
//}

//This part makes HeadView of TableView has parallex effect. Simple than I thought
-(void)scrollViewDidScroll:(UIScrollView*)scrollView {

//    float y = quote.frame.size.height;
    float y = quoteheight;
    CGRect initialFrame = headview.frame;
    image.frame = headview.frame;
//    image.contentMode = UIViewContentModeScaleAspectFill;
//    image.clipsToBounds = YES;
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset < 0) {
        CGRect f = image.frame;
        f.origin.y = yOffset;
        f.size.height =  -yOffset + initialFrame.size.height;
        image.frame = f;
//        quote.font = [quote.font fontWithSize:25];
    }
    if (yOffset > 0) {
        CGRect f = image.frame;
        f.origin.y = yOffset;
        f.size.height =  -yOffset + initialFrame.size.height;
        if (f.size.height < y) {
            y = f.size.height;
            
//            quote.font = [quote.font fontWithSize:15];

        }
        else {
//            quote.font = [quote.font fontWithSize:25];
        }
        image.frame = f;
    }
    quote.transform = CGAffineTransformIdentity;
    quote.frame = CGRectMake(0, 0, self.view.frame.size.width - 20, y);
    quote.center = image.center;
    quote.transform = CGAffineTransformMakeScale(1-yOffset/300, 1-yOffset/300);

}


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
    else if ([cell.reuseIdentifier isEqualToString:@"Photos"]) {
        [self performSegueWithIdentifier:@"photos" sender:self];
    }
    else if ([cell.reuseIdentifier isEqualToString:@"Calendar"]) {
        [self performSegueWithIdentifier:@"calendar" sender:self];
    }
    else if ([cell.reuseIdentifier isEqualToString:@"Goals"]) {
        [self performSegueWithIdentifier:@"goals" sender:self];
    }
    else if ([cell.reuseIdentifier isEqualToString:@"Settings"]) {
        [self performSegueWithIdentifier:@"settings" sender:self];
    }
    else if ([cell.reuseIdentifier isEqualToString:@"Analytics"]) {
        [self performSegueWithIdentifier:@"analytics" sender:self];
    }


}

#pragma mark - prepared for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"timeline"]) {
    }
    else if ([segue.identifier isEqualToString:@"photos"]) {
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
