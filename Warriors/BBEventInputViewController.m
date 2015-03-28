//
//  BBEventInputViewController.m
//  NetworkingWarriors
//
//  Created by Duc Ho on 3/11/15.
//  Copyright (c) 2015 brianhollc. All rights reserved.
//

#import "BBEventInputViewController.h"
#import "Event.h"
#import "Person.h"

@interface BBEventInputViewController () <UITextFieldDelegate,UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
//@property (weak, nonatomic) IBOutlet UITextField *quickAddTextField;
//@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
//@property (weak, nonatomic) IBOutlet UITextField *scoreTextField;
//@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eventImage;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *ratingScoreTextField;
@property (weak, nonatomic) IBOutlet UIImageView *faceImage;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (strong, nonatomic) UIView *containerView;

@end

@implementation BBEventInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.editingMode == NO) {
        self.title = @"Add an Event";
    }
    else {
        self.title = @"Edit an Event";
    }
    UIImageView *iv = [[UIImageView alloc] initWithFrame:self.view.bounds];
    iv.image = [UIImage imageNamed:@"blurrybackground.jpg"];
    iv.contentMode = UIViewContentModeCenter;
    iv.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:iv atIndex:0];
    
    self.nameTextField.text = [NSString stringWithFormat:@"%@ %@", self.person.firstName,self.person.lastName];
    self.titleTextField.text = self.person.title;
    self.companyTextField.text = self.person.company;
    if (self.person.profilePicture != nil) {
        NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Images"];
        NSError *error = nil;
        if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
            [[NSFileManager defaultManager] createDirectoryAtPath:stringPath withIntermediateDirectories:NO attributes:nil error:&error];
        NSString *fileName = [stringPath stringByAppendingFormat:@"%@.jpg",self.person.profilePicture];
        UIImage * image = [UIImage imageWithData:[[NSFileManager defaultManager] contentsAtPath:fileName]];

        self.faceImage.image = image;
    }
    if (self.event != nil) {
        self.eventTitleTextField.text = self.event.title;
        if (self.event.score != nil) {
        self.ratingScoreTextField.text = [NSString stringWithFormat:@"%@",self.event.score];
        }
        self.noteTextView.text = self.event.note;
        NSString *dateString = [NSDateFormatter localizedStringFromDate:self.event.time
                                                              dateStyle:NSDateFormatterMediumStyle
                                                              timeStyle:NSDateFormatterShortStyle];
        self.timeTextField.text = dateString;
        if (self.event.picture != nil) {
            NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Images"];
            NSError *error = nil;
            if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
                [[NSFileManager defaultManager] createDirectoryAtPath:stringPath withIntermediateDirectories:NO attributes:nil error:&error];
                NSString *fileName = [stringPath stringByAppendingFormat:@"%@.jpg",self.event.picture];
                UIImage * image = [UIImage imageWithData:[[NSFileManager defaultManager] contentsAtPath:fileName]];
                self.eventImage.image = image;
        }

    };
    self.eventTitleTextField.delegate = self;
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
    
    self.navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (IBAction)textDidChange:(id)sender {
//        //    self.trackingLocation = self.valueHolder.count - 1;
//        
//        NSDictionary * dict = [self textFieldDictionay:self.quickAddTextField.text];
//        
//        self.locationTextField.text = dict[@"location"];
//        self.timeTextField.text = dict[@"time"];
//        self.scoreTextField.text = dict[@"score"];
//        self.noteTextView.text = dict[@"note"];
//}



-(NSDictionary *)textFieldDictionay:(NSString *)stringToAnalyze{
    
    stringToAnalyze = [stringToAnalyze stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray * values = [stringToAnalyze componentsSeparatedByString:@","];
    NSMutableArray *arrayofString = values.mutableCopy;
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    for (int i = 0; i< arrayofString.count; i++) {
        //    NSLog(@"%@",self.valueHolder);
        arrayofString[i] = [arrayofString[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:arrayofString[i]];
        
        if (i == 0) {
            [dict setObject:arrayofString[i] forKey:@"title"];
        }
        else if ([_NumericOnly isSupersetOfSet: myStringSet]) {
            //            self.nameTextField.text = stringToAnalyze;
            [dict setObject:arrayofString[i] forKey:@"score"];
        }
        else if ([self isDate:arrayofString[i]]) {
            NSDate *eventDate = [self eventDate:arrayofString[i]];
            NSString *dateString = [NSDateFormatter localizedStringFromDate:eventDate
                                                                  dateStyle:NSDateFormatterMediumStyle
                                                                  timeStyle:NSDateFormatterShortStyle];
            [dict setObject:dateString forKey:@"time"];

        }
        // If it is date
//        else if (([arrayofString[i] rangeOfString:@"pm"].location != NSNotFound ) || ([arrayofString[i] rangeOfString:@"am"].location != NSNotFound)) {
//            NSRange tempLoc = NSMakeRange(0, 0);
//            BOOL isItAfternoon;
//            if ([arrayofString[i] rangeOfString:@"pm"].location != NSNotFound) {
//                tempLoc = [arrayofString[i] rangeOfString:@"pm"];
//                isItAfternoon = YES;
//            }
//            else {
//                tempLoc = [arrayofString[i] rangeOfString:@"am"];
//                isItAfternoon = NO;
//            }
//            NSString *hour = [arrayofString[i] substringToIndex:tempLoc.location];
//            hour = [hour stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//            NSString *hourString;
//            NSString *minuteString;
//            NSScanner *scanner = [NSScanner scannerWithString:hour];
//            NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
//            // Throw away characters before the first number.
//            [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
//            // Collect numbers.
//            [scanner scanCharactersFromSet:numbers intoString:&hourString];
//            [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
//            // Collect numbers.
//            [scanner scanCharactersFromSet:numbers intoString:&minuteString];
//            // Result.
//            NSInteger hourInt = [hourString integerValue];
//            if (isItAfternoon == YES) {
//                if (hourInt < 12) hourInt += 12;
//            }
//            else {
//                if (hourInt == 12) hourInt -= 12;
//            }
//            NSInteger minInt = [minuteString integerValue];
//            NSLog(@"%ld:%ld", (long)hourInt,(long)minInt);
//            NSDate* result = [NSDate date];
//            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//            NSDateComponents *comps = [gregorian components: NSUIntegerMax fromDate: result];
//            [comps setMinute:minInt];
//            [comps setHour:hourInt];
//            result = [gregorian dateFromComponents:comps];
//            NSString *dateString = [NSDateFormatter localizedStringFromDate:result
//                                                                  dateStyle:NSDateFormatterMediumStyle
//                                                                  timeStyle:NSDateFormatterShortStyle];
//            [dict setObject:dateString forKey:@"time"];
//        }
//        else if ([arrayofString[i] rangeOfString:@"at"].location != NSNotFound) {
//            NSArray * titleAndCompany = [arrayofString[i] componentsSeparatedByString:@"at"];
//            [dict setObject:titleAndCompany[1] forKey:@"location"];
//        }
        else {
            [dict setObject:arrayofString[i] forKey:@"note"];
        }
    }
    
    return dict;
    
}
-(BOOL)isDate:(NSString *)string {
    BOOL checking;
    NSArray *dateSignal = @[@"ago",@"yesterday", @"PM",@"AM",@"now",@"today",@"this morning",@"this afternoon",@"this evening"];
    checking = NO;
    for (NSString *components in dateSignal) {
    if ([string rangeOfString:components].location != NSNotFound) {
        checking = YES;
    }
    }
    return checking;
}

-(NSDate *)eventDate:(NSString *)fuzzyString {
    NSDate *eventDate;
    NSArray *separatedComps = [fuzzyString componentsSeparatedByString:@" "];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M, d, y 'at' hh:mm a"];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];

    if ([[fuzzyString lowercaseString] rangeOfString:@"now"].location != NSNotFound) {
        eventDate = [NSDate date];
        return eventDate;
    }
    else if ([[fuzzyString lowercaseString] rangeOfString:@"yesterday"].location != NSNotFound) {
        eventDate = [[NSDate date] dateByAddingTimeInterval:(-24*60*60)];
    }
    else if ([[fuzzyString lowercaseString] rangeOfString:@"today"].location != NSNotFound) {
        eventDate = [[NSDate date] dateByAddingTimeInterval:0];
    }
    else if ([[fuzzyString lowercaseString] rangeOfString:@"ago"].location != NSNotFound) {
        for (int i = 0; i<separatedComps.count; i++) {
            if ([[separatedComps[i] lowercaseString] isEqualToString:@"ago"]) {
                NSInteger daysago = 0;
                if ([[separatedComps[i-1] lowercaseString] isEqualToString:@"days"] || [[separatedComps[i-1] lowercaseString] isEqualToString:@"day"]) {
                        NSString *stringValue = separatedComps[i-2];
                        NSInteger howmanydays;
                        if ([self isInteger:stringValue]) {
                            howmanydays = [stringValue integerValue];
                        }
                        else {
                            if ([[stringValue lowercaseString] isEqualToString:@"a"] || [[stringValue lowercaseString] isEqualToString:@"one"]) {
                                howmanydays = 1;
                            }
                            else if ([[stringValue lowercaseString] isEqualToString:@"two"]) {
                                howmanydays = 2;
                            }
                            else if ([[stringValue lowercaseString] isEqualToString:@"three"]) {
                                howmanydays = 3;
                            }
                            else if ([[stringValue lowercaseString] isEqualToString:@"four"]) {
                                howmanydays = 4;
                            }
                            else if ([[stringValue lowercaseString] isEqualToString:@"five"]) {
                                howmanydays = 5;
                            }
                            else if ([[stringValue lowercaseString] isEqualToString:@"six"]) {
                                howmanydays = 6;
                            }
                            else if ([[stringValue lowercaseString] isEqualToString:@"seven"]) {
                                howmanydays = 7;
                            }
                            else if ([[stringValue lowercaseString] isEqualToString:@"eight"]) {
                                howmanydays = 8;
                            }
                            else if ([[stringValue lowercaseString] isEqualToString:@"nine"]) {
                                howmanydays = 9;
                            }
                            else if ([[stringValue lowercaseString] isEqualToString:@"ten"]) {
                                howmanydays = 10;
                            }

                        }
                        daysago = howmanydays*24*60*60;
                    }
            else if ([[separatedComps[i-1] lowercaseString] isEqualToString:@"weeks"] || [[separatedComps[i-1] lowercaseString] isEqualToString:@"week"]) {
                NSString *stringValue = separatedComps[i-2];
                NSInteger howmanydays;
                if ([self isInteger:stringValue]) {
                    howmanydays = [stringValue integerValue];
                }
                else {
                    if ([[stringValue lowercaseString] isEqualToString:@"a"] || [[stringValue lowercaseString] isEqualToString:@"one"]) {
                        howmanydays = 1;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"two"]) {
                        howmanydays = 2;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"three"]) {
                        howmanydays = 3;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"four"]) {
                        howmanydays = 4;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"five"]) {
                        howmanydays = 5;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"six"]) {
                        howmanydays = 6;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"seven"]) {
                        howmanydays = 7;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"eight"]) {
                        howmanydays = 8;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"nine"]) {
                        howmanydays = 9;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"ten"]) {
                        howmanydays = 10;
                    }
                    
                }
                daysago = 7*howmanydays*24*60*60;

                
            }
            else if ([[separatedComps[i-1] lowercaseString] isEqualToString:@"minutes"] || [[separatedComps[i-1] lowercaseString] isEqualToString:@"minute"]) {
            // minute ago
                NSString *stringValue = separatedComps[i-2];
                NSInteger howmanydays;
                if ([self isInteger:stringValue]) {
                    howmanydays = [stringValue integerValue];
                }
                else {
                    if ([[stringValue lowercaseString] isEqualToString:@"a"] || [[stringValue lowercaseString] isEqualToString:@"one"]) {
                        howmanydays = 1;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"two"]) {
                        howmanydays = 2;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"three"]) {
                        howmanydays = 3;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"four"]) {
                        howmanydays = 4;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"five"]) {
                        howmanydays = 5;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"six"]) {
                        howmanydays = 6;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"seven"]) {
                        howmanydays = 7;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"eight"]) {
                        howmanydays = 8;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"nine"]) {
                        howmanydays = 9;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"ten"]) {
                        howmanydays = 10;
                    }
                    
                }
                daysago = howmanydays*60;

            }
            else if ([[separatedComps[i-1] lowercaseString] isEqualToString:@"hours"] || [[separatedComps[i-1] lowercaseString] isEqualToString:@"hour"]) {
                // minute ago
                NSString *stringValue = separatedComps[i-2];
                NSInteger howmanydays;
                if ([self isInteger:stringValue]) {
                    howmanydays = [stringValue integerValue];
                }
                else {
                    if ([[stringValue lowercaseString] isEqualToString:@"an"] || [[stringValue lowercaseString] isEqualToString:@"one"]) {
                        howmanydays = 1;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"two"]) {
                        howmanydays = 2;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"three"]) {
                        howmanydays = 3;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"four"]) {
                        howmanydays = 4;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"five"]) {
                        howmanydays = 5;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"six"]) {
                        howmanydays = 6;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"seven"]) {
                        howmanydays = 7;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"eight"]) {
                        howmanydays = 8;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"nine"]) {
                        howmanydays = 9;
                    }
                    else if ([[stringValue lowercaseString] isEqualToString:@"ten"]) {
                        howmanydays = 10;
                    }
                    
                }
                daysago = howmanydays*60*60;

            }

                eventDate = [[NSDate date] dateByAddingTimeInterval:-daysago];
                break;
            }
        }
    }
    
    if ([fuzzyString rangeOfString:@"am"].location != NSNotFound || [fuzzyString rangeOfString:@"pm"].location != NSNotFound) {
        BOOL isItAfternoon = NO;
        NSInteger stringLoc;
        if ([fuzzyString rangeOfString:@"am"].location != NSNotFound ) {
            isItAfternoon = NO;
            stringLoc = [fuzzyString rangeOfString:@"am"].location;
        }
        else {
            isItAfternoon = YES;
            stringLoc = [fuzzyString rangeOfString:@"pm"].location;

        }
        NSString *hour = fuzzyString;
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
//        NSDate* result = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [gregorian components: NSUIntegerMax fromDate: eventDate];
        [comps setMinute:minInt];
        [comps setHour:hourInt];
        eventDate = [gregorian dateFromComponents:comps];
        
        //modified hour & minute here
    }

    return eventDate;
}


- (BOOL)isInteger:(NSString *)toCheck {
    NSScanner* scan = [NSScanner scannerWithString:toCheck];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];

}

- (IBAction)photoClick:(id)sender {
    
}

- (IBAction)addAPhoto:(id)sender {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Please select an option"
                                                                   message:@"Photo?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Taking a Photo" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                              UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                              picker.delegate = self;
                                                              picker.allowsEditing = YES;
                                                              picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                              
                                                              [self presentViewController:picker animated:YES completion:NULL];


                                                          }];
    UIAlertAction* existingUser = [UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:defaultAction];
    [alert addAction:existingUser];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.eventImage.image = chosenImage;

    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - textField Return


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)addNewEvent:(id)sender {
    if ([self.eventTitleTextField hasText]) {
        NSMutableArray *data = [NSMutableArray array];
        data[0] = ([self.eventTitleTextField hasText]) ? self.eventTitleTextField.text : @"" ;
        data[1] = ([self.ratingScoreTextField hasText]) ? self.ratingScoreTextField.text : @"" ;
        data[2] = ([self.timeTextField hasText]) ? self.timeTextField.text : @"" ;
        data[3] = ([self.noteTextView hasText]) ? self.noteTextView.text : @"";
        NSLog(@"%@",data);
        [self syncToCoreData:data];
    }
    else {
        NSLog(@"data has to have at least a name, did not save");
    }
    
    [self saveContext];
    
    if ([self.sourceVC isEqualToString:@"Calendar"]) {
        [self performSegueWithIdentifier:@"backToCalendar" sender:self];
    }
    else {
    [self performSegueWithIdentifier:@"backToTimeline" sender:self];
    }
}

#pragma mark - sync to core data
- (void)syncToCoreData:(NSArray *)data {
    Event *event;
    if (self.editingMode == NO) {
        event = [Event createEntity];
    }
    else {
        event = self.event;
    }
        event.person = self.person;
        event.title = data[0];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *myNumber = [f numberFromString:data[1]];
        event.score = myNumber;
        event.note = data[3];
        NSString *str =data[2];
        NSDateFormatter *sdateFormatter = [[NSDateFormatter alloc] init];
        [sdateFormatter setDateFormat:@"MMM d, yyyy, hh:mm a"];
        event.time = [sdateFormatter dateFromString:str];
        //save image string to coredata
    if (self.eventImage.image != nil) {

        NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Images"];
        // New Folder is your folder name
        NSError *error = nil;
        if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
            [[NSFileManager defaultManager] createDirectoryAtPath:stringPath withIntermediateDirectories:NO attributes:nil error:&error];
        NSNumber *randomfileName = [NSNumber numberWithInt:(arc4random() % 10000) + 99999];
        event.picture = [randomfileName stringValue];
        NSString *fileName = [stringPath stringByAppendingFormat:@"%@.jpg",event.picture];
        NSData *imageData = UIImageJPEGRepresentation(self.eventImage.image, 1.0);
        [imageData writeToFile:fileName atomically:YES];
    }

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
//    data[0] = ([self.eventTitleTextField hasText]) ? self.eventTitleTextField.text : @"" ;
//    data[1] = ([self.ratingScoreTextField hasText]) ? self.ratingScoreTextField.text : @"" ;
//    data[2] = ([self.timeTextField hasText]) ? self.timeTextField.text : @"" ;
//    data[3] = ([self.noteTextView hasText]) ? self.noteTextView.text : @"";
    self.eventTitleTextField.text = dict[@"title"];
    self.ratingScoreTextField.text = dict[@"score"];
    self.noteTextView.text = dict[@"note"];
    self.timeTextField.text = dict[@"time"];

    
//    eventTitleTextField;
//    ratingScoreTextField;
//    faceImage;
//    noteTextView;

}


- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = self.containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    self.containerView.frame = r;
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
