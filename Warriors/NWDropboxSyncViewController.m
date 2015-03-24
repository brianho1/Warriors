//
//  NWDropboxSyncViewController.m
//  Warriors
//
//  Created by Duc Ho on 3/20/15.
//  Copyright (c) 2015 brianhollc. All rights reserved.
//

#import "NWDropboxSyncViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "Event.h"
#import "Person.h"

@interface NWDropboxSyncViewController () <DBRestClientDelegate>
@property (nonatomic, strong) DBRestClient *restClient;
@property (nonatomic, strong) NSMutableArray *events;
@property (nonatomic, strong) NSString *fileContent;

@end

@implementation NWDropboxSyncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DBSession *dbSession = [[DBSession alloc]
                            initWithAppKey:@"cuiu39svaraqyc4"
                            appSecret:@"v0ate5scmnb0h5o"
                            root:kDBRootAppFolder]; // either kDBRootAppFolder or kDBRootDropbox
    [DBSession setSharedSession:dbSession];
    
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)syncWithDropbx:(id)sender {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    self.fileContent = @"";
    NSString *sortKey = @"time";
    BOOL ascending = [sortKey isEqualToString:@"time"] ? NO : YES;
    // Fetch entities with MagicalRecord
    self.events = [[Event findAllSortedBy:sortKey ascending:ascending] mutableCopy];
    for (int i = 0; i<self.events.count; i++) {
        Event *event = self.events[i];
        NSDate *date = event.time;
        NSString *title = event.title;
        NSNumber *score = event.score;
        NSString *note = event.note;
        NSString *name = [NSString stringWithFormat:@"%@ %@",event.person.firstName, event.person.lastName];
        NSString *jobTitle = event.person.title;
        NSString *company = event.person.company;
        self.fileContent = [self.fileContent stringByAppendingString:[NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@, %@, \n",date, name, jobTitle, company, title, score, note]];
    }

//    NSString *text = @"0306703,0035866,NO_ACTION,06/19/2006\n0086003,\"0005866\",UPDATED,06/19/2007";
    NSString *filename = @"NWData.csv";
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    [self.fileContent writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    // Upload file to Dropbox
    NSString *destDir = @"/";
    NSString *parentRev= [[NSUserDefaults standardUserDefaults] objectForKey:@"DBParentRev"];
    if (!parentRev) {
        [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:localPath];
    }
    else
    {
        [self.restClient uploadFile:filename toPath:destDir withParentRev:parentRev fromPath:localPath];
    }


    
}

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
    NSLog(@"%@",metadata.rev);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:metadata.rev forKey:@"DBParentRev"];
    [defaults synchronize];

    
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    NSLog(@"File upload failed with error: %@", error);
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
