//
//  AppDelegate.m
//  Warriors
//
//  Created by Duc Ho on 3/18/15.
//  Copyright (c) 2015 brianhollc. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "AppDelegate.h"
#import "Person.h"
#import "Event.h"
#import "MagicalRecord.h"
#import <DropboxSDK/DropboxSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xDDD3C8)];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    [self generateFakeData];
//    [MagicalRecord setupCoreDataStackWithStoreNamed:@"People"];
//    
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"MR_AvailablePeople"]) {
//        // Create Blond Ale
//        Person *johndoe = [Person createEntity];
//        johndoe.lastName  = @"Doe";
//        johndoe.firstName = @"John";
//        johndoe.notes = @"okay guy";
//        johndoe.userId = @10001;
//        Event * meetJohn = [Event createEntity];
//        meetJohn.person = johndoe;
//        meetJohn.score = @3;
//        meetJohn.note = @"first time met John Doe";
//        
//        NSString *str =@"3/15/2012 9:15 PM";
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        [formatter setDateFormat:@"MM/dd/yyyy HH:mm a"];
//        NSDate *date = [formatter dateFromString:str];
//        meetJohn.time = date;
//        
//        johndoe.overallSocre = @4;
//        
//        Event * meetJohnagain = [Event createEntity];
//        meetJohnagain.person = johndoe;
//        meetJohnagain.score = @3;
//        meetJohnagain.note = @"Second time met John Doe";
//        NSDate *now = [NSDate date];
//        int daysToAdd = -1;
//        meetJohnagain.time = [now dateByAddingTimeInterval:60*60*24*daysToAdd];;
//        
//        Event * meetJohnagain2 = [Event createEntity];
//        meetJohnagain2.person = johndoe;
//        meetJohnagain2.score = @3;
//        meetJohnagain2.note = @"Third time met John Doe";
//        meetJohnagain2.time = [now dateByAddingTimeInterval:60*60*24*(-2)];;
//        
//        Person *johndoe2 = [Person createEntity];
//        johndoe2.lastName  = @"Guy";
//        johndoe2.firstName = @"Random";
//        johndoe2.notes = @"bad guy";
//        johndoe2.userId = @10002;
//        Event * meetJohn2 = [Event createEntity];
//        meetJohn2.person = johndoe2;
//        meetJohn2.score = @1;
//        meetJohn2.note = @"nothing new";
//        johndoe2.overallSocre = @2;
//        meetJohn2.time = [now dateByAddingTimeInterval:60*60*24*(-2)];
//        
//        Person *johndoe3 = [Person createEntity];
//        johndoe3.lastName  = @"Ho";
//        johndoe3.firstName = @"Brian";
//        johndoe3.notes = @"nice guy this is a longer note about this guy named Brian Ho to see if the text is overflowed from the cell";
//        johndoe3.userId = @10003;
//        Event * meetJohn3 = [Event createEntity];
//        meetJohn3.person = johndoe3;
//        meetJohn3.score = @1;
//        meetJohn3.note = @"EVENTNOTE nice guy this is a longer note about this guy named Brian Ho to see if the text is overflowed from the cell";
//        johndoe3.overallSocre = @2;
//        meetJohn3.time = [now dateByAddingTimeInterval:60*60*24*(-3)];
//        
//        // Save Managed Object Context
//        [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:nil];
//        
//        // Set User Default to prevent another preload of data on startup.
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MR_AvailablePeople"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    return YES;
}

-(void)generateFakeData {
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"People"];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"MR_AvailablePeople"]) {
        NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Images"];
        // New Folder is your folder name
        NSError *error = nil;
        if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
            [[NSFileManager defaultManager] createDirectoryAtPath:stringPath withIntermediateDirectories:NO attributes:nil error:&error];

        for (int i=0; i<12; i++) {
            NSString *string = [NSString stringWithFormat:@"%d",i+1];
            NSString *randomfileName = [stringPath stringByAppendingFormat:@"%@.jpg",string];
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",string]];
            [UIImageJPEGRepresentation(image, 1.0) writeToFile:randomfileName atomically:YES];
            
            NSString *businessCard = [stringPath stringByAppendingFormat:@"cat%@.jpg",string];
            UIImage *imageBC = [UIImage imageNamed:[NSString stringWithFormat:@"cat%@.jpg",string]];
            [UIImageJPEGRepresentation(imageBC, 1.0) writeToFile:businessCard atomically:YES];

        }
        
        for (int i=0; i<20; i++) {
            Person *JohnDoe = [Person createEntity];
            NSString *randomName = [self randomeName];
            NSArray *name = [randomName componentsSeparatedByString:@" "];
            JohnDoe.lastName  = name[0];
            JohnDoe.firstName = name[1];
            JohnDoe.title = [self randomeJobTitle];
            JohnDoe.company = [self randomeCompanyName];
            JohnDoe.profilePicture = [self randomImage];
            Event * meetJohnDoe = [Event createEntity];
            meetJohnDoe.person = JohnDoe;
            meetJohnDoe.title = [NSString stringWithFormat:@"Meet %@",randomName];
            meetJohnDoe.score = [self randomScore];
            meetJohnDoe.note = [self randomNote];
            meetJohnDoe.time = [self randomDate];
            meetJohnDoe.picture = [NSString stringWithFormat:@"cat%@",[self randomImage]];

        }
        
        
        // Save Managed Object Context
        [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:nil];
        // Set User Default to prevent another preload of data on startup.
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MR_AvailablePeople"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

-(NSString *)randomeName {
    NSArray *arrayOfRandomName = @[@"Divina Rizzo",@"Dorathy Sponsler",@"Gaynell Turnipseed",@"Jovan Duppstadt",@"Milagro Wheatley",@"Armandina Mcgaugh",@"Trinity Kittrell",@"Sarina Melton",@"June Thrash",@"Aleen Dotson",@"Vincent Pavone",@"Janessa Liakos",@"Marlin Burdick",@"Fallon Bibbins",@"Britteny Woodley",@"Jeramy Masden",@"Gilberto Caple",@"Rachelle Wolery",@"Juanita Sharber",@"Tomoko Huntley",@"Arla Muszynski",@"Alica Winrow",@"Corina Burgett",@"Candis Clair",@"Jeri Nevers",@"Russel Gatto",@"Nicolasa Titsworth",@"Armanda Snelgrove",@"Jan Trieu",@"Iona Douglass",@"Ruby Ross",@"Todd Young",@"Jose Smith",@"Steven Moore",@"Ashley Hughes",@"Billy Gray",@"Samuel Mitchell",@"Arthur Miller",@"Richard Powell",@"George Bryant",@"Katherine Rivera",@"Marie Cook",@"Barbara Cox",@"Carl Long",@"Sandra Bennett",@"Diane Morgan",@"Jesse Richardson",@"Brian Peterson",@"Kelly Reed",@"Jonathan Hall",@"Janet Perez",@"Henry Howard",@"Harry King",@"Ryan Bailey",@"Janice Wilson",@"Cynthia Nelson",@"Justin Watson",@"Anthony Martin",@"Ruth Martinez",@"Albert Barnes",@"Fred Scott",@"Jerry Carter",@"Nicole Gonzales",@"Karen Phillips",@"Adam Griffin",@"Joe Davis",@"Debra Jenkins",@"Rose Russell",@"Matthew Taylor",@"Sharon Price",@"Phyllis Hill",@"Jason Parker",@"Patricia Hernandez",@"Gary Bell",@"Patrick Williams",@"Rachel Perry",@"Helen Adams",@"Louise Sanchez",@"Raymond James",@"Andrea Simmons",@"Sarah White",@"Beverly Lewis",@"Terry Patterson",@"Aaron Green",@"Michael Kelly",@"Catherine Jackson",@"Carlos Campbell",@"Christina Allen",@"Martha Alexander",@"Thomas Wood",@"Kathy Foster",@"Wayne Robinson",@"Roger Washington",@"Lois Jones",@"Christopher Lopez",@"Dorothy Rogers",@"Alan Morris",@"Paul Rodriguez",@"Irene Torres",@"Craig Brown",@"Mary Butler",@"Denise Evans",@"Betty Ward",@"Earl Lee",@"Judy Thomas",@"Randy Garcia",@"Ralph Diaz",@"Lillian Murphy",@"Kathryn Ramirez",@"Charles Thompson",@"Jessica Flores",@"Michelle Collins",@"Pamela Turner",@"Brenda Walker",@"Steve Brooks",@"Martin Coleman",@"Tina Wright",@"Chris Clark",@"Robert Baker",@"Annie Roberts",@"Nancy Johnson",@"James Cooper",@"Peter Edwards",@"Philip Stewart",@"Kenneth Harris",@"Joan Henderson",@"Melissa Gonzalez",@"Jimmy Anderson",@"Carol Sanders",@"Benjamin Harris"];
    NSUInteger randomIndex = arc4random() % [arrayOfRandomName count];
    return arrayOfRandomName[randomIndex];
}

-(NSString *)randomeJobTitle {
    NSArray *arrayOfRandomName = @[@"Developer",@"Analyst",@"Vice President",@"Associate",@"Consultant",@"Senior Programmer",@"Software Engineer",@"Staff",@"Business Strategy Analyst"];
    NSUInteger randomIndex = arc4random() % [arrayOfRandomName count];
    return arrayOfRandomName[randomIndex];
}

-(NSString *)randomeCompanyName {
    NSArray *arrayOfRandomName = @[@"Qtrax",@"Thunderclap",@"Moz",@"Fancy",@"Upworthy",@"Glide",@"OPPRTUNITY",@"Lyft",@"CoinDesk",@"Ad Magnet",@"AgentsBids",@"Nifti",@"Heml.is",@"Floobits",@"Blue Apron",@"Searchmetrics",@"DuckDuckGo",@"Divshot",@"VAVEL",@"XingCloud",@"The Oatmeal",@"Total Sports Madness",@"Sverve",@"Silp",@"FanBoom.net",@"Spinnakr",@"Flyvpn",@"BlogHer",@"Zapacos",@"Udemy",@"ContaAzul",@"Askmefast",@"Sensor Tower",@"Coub",@"Impact Radius",@"Lockitron",@"Nitrous.IO",@"Stitch Fix",@"B5M",@"Vox Media",@"Circa",@"Runrun.it",@"Mattermark",@"Soldsie",@"MetricsCat",@"pricegenie.in",@"Path.To",@"Travel Videos",@"Widbook",@"Noble Samurai",@"boo-box",@"iZettle",@"Fotolia",@"Postable",@"CareerDean",@"Peek",@"Collage.com",@"Narrato",@"Ink",@"Omaze",@"WP Engine",@"Urban Daddy",@"Fieldoo",@"Kapost",@"Empire Avenue",@"Shopgate",@"BuzzFeed",@"Check",@"Puppet Labs",@"Recon Instruments",@"Teespring",@"Kisskissbankbank",@"Archive.is",@"Tile",@"Konga Online",@"Grovo",@"Smiirl",@"Oppa",@"Fetise.com",@"99dealr.com",@"RelateIQ",@"Routehappy",@"3scale",@"grenadine",@"CARD",@"Help Scout",@"Sched.org",@"Triberr",@"United Sound Army",@"AgoraPulse",@"ShopClues.com",@"FindSimilarSites",@"Famecrowd",@"Venddo",@"LendUp",@"Dealflicks",@"Awe.sm",@"Snaglur",@"Sharecare",@"ITmozg"];
    NSUInteger randomIndex = arc4random() % [arrayOfRandomName count];
    return arrayOfRandomName[randomIndex];
}

-(NSString *)randomEventTitle {
    return @"Meet ";
}

-(NSNumber *)randomScore {
    NSUInteger randomIndex = 1+ arc4random() % 5;
    NSNumber *randomNumber = [NSNumber numberWithLong:randomIndex];
    return randomNumber;
}

-(NSDate *)randomDate {
    NSDate *randomDate = [NSDate date];
    NSInteger randomIndex = arc4random() % 300;
    NSInteger daysToAdd = -randomIndex;
    return [randomDate dateByAddingTimeInterval:60*60*24*daysToAdd];
}
-(NSString *)randomNote {
    NSArray *arrayOfRandomNote = @[@"sneaky",@"dry",@"many",@"tedious",@"accidental",@"delicious",@"plastic",@"reflective",@"flimsy",@"eatable",@"colossal",@"obese",@"lewd",@"flowery",@"romantic",@"third",@"wise",@"thick",@"understood",@"nifty",@"screeching",@"flaky",@"immense",@"murky",@"squeamish",@"exclusive",@"decorous",@"verdant",@"cold",@"combative",@"tasteless",@"concerned",@"extra-large",@"skillful",@"ubiquitous",@"icy",@"legal",@"faithful",@"overwrought",@"determined"];
    NSUInteger randomIndex = arc4random() % [arrayOfRandomNote count];
    return [NSString stringWithFormat:@"He/She is %@. Note was generated randomly",arrayOfRandomNote[randomIndex]];
}

-(NSString *)randomImage {
    NSUInteger randomIndex = 1 + arc4random() % 12;
    return [NSString stringWithFormat:@"%lu",(unsigned long)randomIndex];
}


#pragma mark - link with Dropbox
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
