//
//  PaymentMethod.h
//  ML
//
//  Created by kb on 11/21/18.
//  Copyright © 2018 kb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentMethod : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *iD;

-(instancetype)initWithNSDictionary : (NSDictionary*)dictionary;

@end
