//
//  PaymentMethodIssuers.m
//  ML
//
//  Created by kb on 11/21/18.
//  Copyright © 2018 kb. All rights reserved.
//

#import "PaymentMethodIssuers.h"

@implementation PaymentMethodIssuers

-(instancetype)initWithNSDictionary : (NSDictionary*)dictionary{
    
    self = [super init];
    
    if (self) {
        self.name = [dictionary objectForKey:@"name"];
        self.imageUrl = [dictionary objectForKey:@"secure_thumbnail"];
        self.iD = [dictionary objectForKey:@"id"];
    }
    
    return self;
}

@end
