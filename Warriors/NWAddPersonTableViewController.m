//
//  NWAddPersonTableViewController.m
//  Warriors
//
//  Created by Duc Ho on 3/18/15.
//  Copyright (c) 2015 brianhollc. All rights reserved.
//

#import "NWAddPersonTableViewController.h"
#import "BBEventInputViewController.h"


@interface NWAddPersonTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (strong, nonatomic) UIView *containerView;
@end

@implementation NWAddPersonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:self.view.bounds];
    iv.image = [UIImage imageNamed:@"blurrybackground.jpg"];
    iv.contentMode = UIViewContentModeCenter;
    iv.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:iv atIndex:0];

    [self.cameraButton setImage:[UIImage imageNamed:@"camera_filled-50.png"] forState:UIControlStateHighlighted];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    //set notification for when a key is pressed.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector: @selector(keyPressed:)
                                                 name: UITextViewTextDidChangeNotification
                                               object: nil];

    self.containerView = [[UIView alloc] init];
    self.containerView.frame = CGRectMake(0, self.view.frame.size.width - 40, self.view.frame.size.width, 40);
    [self.view addSubview:self.containerView];
    CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.x = 0;
    containerFrame.origin.y = self.view.frame.size.height - 40;
    containerFrame.size.width = self.view.frame.size.width;
    containerFrame.size.height = 40;
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, self.view.frame.size.width - 70, 40)];
    
    textView.frame = CGRectMake(6, 3, self.view.frame.size.width - 70, 40);
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
    textView.returnKeyType = UIReturnKeyGo; //just as an example
    textView.font = [UIFont systemFontOfSize:15.0f];
    textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholder = @"Quick add your information!";
    
    // textView.text = @"test\n\ntest";
    // textView.animateHeightChange = NO; //turns off animation
    
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(5, 0, self.view.frame.size.width - 72, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [self.containerView addSubview:imageView];
    [self.containerView addSubview:textView];
    [self.containerView addSubview:entryImageView];
    
    UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(self.containerView.frame.size.width - 69, 8, 63, 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
    [self.containerView addSubview:doneBtn];
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    //    self.containerView.autoresizingMask = UIViewAutoresizingNone;
    self.containerView.frame = containerFrame;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - growing TextView

-(void)resignTextView
{
    [textView resignFirstResponder];
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    // get a rect for the textView frame
    CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    // set views with new info
    self.containerView.frame = containerFrame;
    //    self.containerView.frame = CGRectMake(0, 400, 375, 39);
    // commit animations
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // get a rect for the textView frame
    CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    // set views with new info
    self.containerView.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
}

-(void)keyPressed: (NSNotification*) notification{
    // get the size of the text block so we can work our magic
    //    self.label.text = textView.text;
    NSDictionary * dict = [self textFieldDictionay:textView.text];
    
    self.addressTextField.text = @""; // dirty trick to work around addresstexrfield didn't clear when delete text
    self.nameTextField.text = dict[@"name"];
    self.companyTextFiled.text = dict[@"company"];
    self.titleTextField.text = dict[@"title"];
    self.phoneNumber.text = dict[@"phonenumber"];
    self.emailTextField.text = dict[@"email"];
    self.noteTextView.text = dict[@"note"];
    NSDictionary *addressDict = dict[@"address"];
    if (addressDict) {
        NSString *street = addressDict[NSTextCheckingStreetKey];
        NSString *city = addressDict[NSTextCheckingCityKey];
        NSString *state = addressDict[NSTextCheckingStateKey];
        if (street == NULL) street = @"_";
        if (city == NULL) city = @"_";
        if (state == NULL) state = @"_";
        self.addressTextField.text = [NSString stringWithFormat:@"%@, %@, %@",[street capitalizedString], [city capitalizedString], [state uppercaseString]];
    };
}


- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = self.containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    self.containerView.frame = r;
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
- (IBAction)cameraButtonPressed:(id)sender {
    NSLog(@"Camera Pressed");
}

#pragma mark - analyzing string

-(NSDictionary *)textFieldDictionay:(NSString *)stringToAnalyze{
    
    stringToAnalyze = [stringToAnalyze stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray * values = [stringToAnalyze componentsSeparatedByString:@","];
    NSMutableArray *arrayofString = values.mutableCopy;
    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSError *error = nil;
    NSDataDetector * detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingAllSystemTypes
                                                                error:&error];
    
    int countAt = 0; // dirty way to get around with the problem of multiple words AT appearing in the text
    for (int i = 0; i< arrayofString.count; i++) {
        //    NSLog(@"%@",self.valueHolder);
        __block NSString *phoneString = @"";
        __block NSDictionary *addressDict = nil;
        NSString *analyzingString = arrayofString[i];
        [detector enumerateMatchesInString:analyzingString
                                   options:kNilOptions
                                     range:NSMakeRange(0, [analyzingString length])
                                usingBlock:
         ^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
             if (result.resultType == NSTextCheckingTypePhoneNumber) {
                 phoneString = result.phoneNumber;
             }
             else if (result.resultType == NSTextCheckingTypeAddress) {
                 addressDict = result.addressComponents;
             }
         }];

        arrayofString[i] = [arrayofString[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
             if (i==0) {
                 //            self.nameTextField.text = stringToAnalyze;
                 [dict setObject:[arrayofString[i] capitalizedString] forKey:@"name"];
                 
             }
        // If it is date
        else if (([arrayofString[i] rangeOfString:@"pm"].location != NSNotFound ) || ([arrayofString[i] rangeOfString:@"am"].location != NSNotFound)) {
            NSRange tempLoc = NSMakeRange(0, 0);
            BOOL isItAfternoon;
            if ([arrayofString[i] rangeOfString:@"pm"].location != NSNotFound) {
                tempLoc = [arrayofString[i] rangeOfString:@"pm"];
                isItAfternoon = YES;
            }
            else {
                tempLoc = [arrayofString[i] rangeOfString:@"am"];
                isItAfternoon = NO;
            }
            
            NSString *hour = [arrayofString[i] substringToIndex:tempLoc.location];
            hour = [hour stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *hourString;
            NSString *minuteString;
            NSScanner *scanner = [NSScanner scannerWithString:hour];
            NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
            // Throw away characters before the first number.
            [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
            // Collect numbers.
            [scanner scanCharactersFromSet:numbers intoString:&hourString];
            
            [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
            // Collect numbers.
            [scanner scanCharactersFromSet:numbers intoString:&minuteString];
            // Result.
            NSInteger hourInt = [hourString integerValue];
            if (isItAfternoon == YES) {
                if (hourInt < 12) hourInt += 12;
            }
            else {
                if (hourInt == 12) hourInt -= 12;
            }
            NSInteger minInt = [minuteString integerValue];
            //            NSLog(@"%ld:%ld", (long)hourInt,(long)minInt);
            NSDate* result = [NSDate date];
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *comps = [gregorian components: NSUIntegerMax fromDate: result];
            [comps setMinute:minInt];
            [comps setHour:hourInt];
            
            result = [gregorian dateFromComponents:comps];
            
            NSString *dateString = [NSDateFormatter localizedStringFromDate:result
                                                                  dateStyle:NSDateFormatterMediumStyle
                                                                  timeStyle:NSDateFormatterShortStyle];
            
            //            self.timeTextField.text = dateString;
            [dict setObject:dateString forKey:@"time"];
        }
        // if it is title and company
        else if (([arrayofString[i] rangeOfString:@" at "].location != NSNotFound) && (countAt ==0)) {
            countAt = 1;
            NSArray * titleAndCompany = [arrayofString[i] componentsSeparatedByString:@" at "];
            //            self.titleTextField.text = titleAndCompany[0];
            //            self.companyTextFiled.text = titleAndCompany[1];
            [dict setObject:[titleAndCompany[0] capitalizedString] forKey:@"title"];
            [dict setObject:[titleAndCompany[1] capitalizedString] forKey:@"company"];
        }
        else if ([arrayofString[i] rangeOfString:@".com"].location != NSNotFound) {
         if ([arrayofString[i] rangeOfString:@"@"].location != NSNotFound) {
            //            self.emailTextField.text = stringToAnalyze;
            [dict setObject:arrayofString[i] forKey:@"email"];
        }
        else
            [dict setObject:arrayofString[i] forKey:@"website"];
        }
        else if (![phoneString isEqualToString:@""]) {
            [dict setObject:phoneString forKey:@"phonenumber"];
        }
        else if (addressDict != nil) {
            [dict setObject:addressDict forKey:@"address"];
        }
        else {

            //            self.noteTextView.text = stringToAnalyze;
            [dict setObject:arrayofString[i] forKey:@"note"];
        }
    }
    return dict;
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 2) {
        //trim spaces at both end
        
    }
    
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - doneAdding

-(IBAction)doneAdding:(id)sender {
    if ([self.nameTextField hasText]) {
        //adding to core data here
        // data {name, company, title, time, email, note}
        NSMutableArray *data = [NSMutableArray array];
        data[0] = self.nameTextField.text;
        data[1] = ([self.companyTextFiled hasText]) ? self.companyTextFiled.text : @"" ;
        data[2] = ([self.titleTextField hasText]) ? self.titleTextField.text : @"" ;
        data[3] = ([self.phoneNumber hasText]) ? self.phoneNumber.text : @"" ;
        data[4] = ([self.emailTextField hasText]) ? self.emailTextField.text : @"" ;
        data[5] =([self.addressTextField hasText]) ? self.addressTextField.text : @"" ;
        data[6] = ([self.noteTextView hasText]) ? self.noteTextView.text : @"" ;
        //            NSLog(@"%@",data);
        [self syncToCoreData:data];
        [self saveContext];
        BBEventInputViewController *eventInputVC = [BBEventInputViewController new];
        eventInputVC.person = self.person;
        [self performSegueWithIdentifier:@"addEventForExistingUser" sender:self];
    }
    else {
        
        NSLog(@"data has to have at least a name, did not save");
    }
    

}

#pragma mark - sync to core data
- (void)syncToCoreData:(NSArray *)data {
        Person *person = [Person createEntity];
        NSArray *name = [data[0] componentsSeparatedByString:@" "];
        person.firstName = name[0];
        person.lastName = name[1];
        person.notes = data[6];
        person.company = data[1];
        person.title = data[2];
        person.address = data[5];
        person.email = data[4];
        person.userId = [NSNumber numberWithInt:(arc4random() % 10000) + 99999];
        self.person = person;
        //convert time string to nsdate
//        NSString *str =data[3];
//        NSDateFormatter *sdateFormatter = [[NSDateFormatter alloc] init];
//        //        sdateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//        [sdateFormatter setDateFormat:@"MMM d, yyyy, hh:mm a"];
//        event.time = [sdateFormatter dateFromString:str];
//        event.person.userId = [NSNumber numberWithInt:(arc4random() % 10000) + 99999];
    
}

- (void)saveContext {
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"You successfully saved your context.");
        } else if (error) {
            NSLog(@"Error saving context: %@", error.description);
        }
    }];
}

#pragma mark - prepare for segue 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addEventForExistingUser"]) {
        UINavigationController *navController = segue.destinationViewController;
        BBEventInputViewController *eventInputVC = navController.viewControllers[0];
        eventInputVC.person = self.person;
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
