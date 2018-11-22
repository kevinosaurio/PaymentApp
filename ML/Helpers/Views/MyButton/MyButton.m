//
//  MyButton.m
//  ML
//
//  Created by kb on 11/21/18.
//  Copyright © 2018 kb. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

#pragma mark - Inits

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setEnabled:self.enabled];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setEnabled:self.enabled];
    }
    return self;
}

#pragma mark - Overrides

-(void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    self.backgroundColor = enabled ? [UIColor colorWithRed:54.0f/255.0f green:159.0f/255.0f blue:228.0f/255.0f alpha:1.0f]:[UIColor lightGrayColor];
}

@end
