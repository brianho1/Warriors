//
//  UIView+UIViewExtension.m
//  NetworkingWarriors
//
//  Created by Duc Ho on 3/10/15.
//  Copyright (c) 2015 brianhollc. All rights reserved.
//

#import "UIView+UIViewExtension.h"

@implementation UIView (UIViewExtension)

-(UIImage *)convertViewToImage
{
    UIGraphicsBeginImageContext(self.frame.size);
    [self drawViewHierarchyInRect:self.frame afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
