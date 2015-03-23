//
//  UICollectionViewWaterfallCell.m
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import "CHTCollectionViewWaterfallCell.h"

@interface CHTCollectionViewWaterfallCell ()

@property (strong, nonatomic, readwrite) UIImageView *imageView;

@end


@implementation CHTCollectionViewWaterfallCell

#pragma mark - Accessors
- (UILabel *)displayLabel {
  if (!_displayLabel) {
    CGRect f = self.contentView.bounds;
      f.origin.y = f.size.height/2;
      f.size.height = f.size.height/2;
    _displayLabel = [[UILabel alloc] initWithFrame:f];
    _displayLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _displayLabel.backgroundColor = [UIColor clearColor];
    _displayLabel.textColor = [UIColor whiteColor];
    _displayLabel.textAlignment = NSTextAlignmentCenter;
  }
  return _displayLabel;
}

- (void)setDisplayString:(NSString *)displayString {
  if (![_displayString isEqualToString:displayString]) {
    _displayString = [displayString copy];
    self.displayLabel.text = _displayString;
  }
}

-(void)setItem:(NSInteger)item {
    if (!(_item == item)) {
        _item = item;
    }

}


#pragma mark - Life Cycle
- (void)dealloc {
  [_displayLabel removeFromSuperview];
  _displayLabel = nil;
}

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.imageView = [[UIImageView alloc] init];
    // Scale with fill for contents when we resize.
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;

    // Scale the imageview to fit inside the contentView with the image centered:
    CGRect imageViewFrame = CGRectMake(0.f, 0.f, CGRectGetMaxX(self.contentView.bounds), CGRectGetMaxY(self.contentView.bounds));
    self.imageView.frame = imageViewFrame;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.imageView.clipsToBounds = YES;
      self.imageView.layer.borderWidth = 4;
      self.imageView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.displayLabel];
  }
  return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.imageView = nil;
}



@end
