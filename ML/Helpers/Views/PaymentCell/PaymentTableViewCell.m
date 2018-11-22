//
//  PaymentTableViewCell.m
//  ML
//
//  Created by kb on 11/21/18.
//  Copyright © 2018 kb. All rights reserved.
//

#import "PaymentTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface PaymentTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation PaymentTableViewCell

-(void)setName:(NSString *)name imageUrl:(NSString *)imageUrl{
    _nameLabel.text = name;
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                        placeholderImage:nil
                               completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL)
     {
         if (image == nil)
         {
             self.myImageView.image = [UIImage imageNamed:@"Noimage"];
         }
     }];
}

@end
