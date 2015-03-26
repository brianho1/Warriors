//
//  NWPhotosViewController.h
//  Warriors
//
//  Created by Duc Ho on 3/20/15.
//  Copyright (c) 2015 brianhollc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"
#import "Event.h"

@interface NWPhotosViewController : UIViewController <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *eventsWithPics;
@property (strong, nonatomic) Person *personToPass;
@property (strong, nonatomic) Event *eventToPass;


@end

