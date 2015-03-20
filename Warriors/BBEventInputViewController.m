//
//  BBEventInputViewController.m
//  NetworkingWarriors
//
//  Created by Duc Ho on 3/11/15.
//  Copyright (c) 2015 brianhollc. All rights reserved.
//

#import "BBEventInputViewController.h"
#import "Event.h"

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

@end

@implementation BBEventInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameTextField.text = [NSString stringWithFormat:@"%@ %@", self.person.firstName,self.person.lastName];
    self.titleTextField.text = self.person.title;
    self.companyTextField.text = self.person.company;
    self.eventTitleTextField.delegate = self;

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
            NSLog(@"%ld:%ld", (long)hourInt,(long)minInt);
            NSDate* result = [NSDate date];
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *comps = [gregorian components: NSUIntegerMax fromDate: result];
            [comps setMinute:minInt];
            [comps setHour:hourInt];
            result = [gregorian dateFromComponents:comps];
            NSString *dateString = [NSDateFormatter localizedStringFromDate:result
                                                                  dateStyle:NSDateFormatterMediumStyle
                                                                  timeStyle:NSDateFormatterShortStyle];
            [dict setObject:dateString forKey:@"time"];
        }
        else if ([arrayofString[i] rangeOfString:@"at"].location != NSNotFound) {
            NSArray * titleAndCompany = [arrayofString[i] componentsSeparatedByString:@"at"];
            [dict setObject:titleAndCompany[1] forKey:@"location"];
        }
        else {
            [dict setObject:arrayofString[i] forKey:@"note"];
        }
    }
    
    return dict;
    
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
    [self performSegueWithIdentifier:@"backToTimeline" sender:self];
   
}

#pragma mark - sync to core data
- (void)syncToCoreData:(NSArray *)data {
    
        Event *event = [Event createEntity];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end