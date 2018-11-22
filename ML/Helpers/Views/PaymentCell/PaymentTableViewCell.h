//
//  PaymentTableViewCell.h
//  ML
//
//  Created by kb on 11/21/18.
//  Copyright © 2018 kb. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const PAYMENT_REUSE_IDENTIFIER = @"PaymentCell";
static CGFloat const PAYMENT_CELL_DEFAULT_HEIGHT = 80.0;

@interface PaymentTableViewCell : UITableViewCell
-(void)setName:(NSString *)name imageUrl:(NSString *)imageUrl;
@end
