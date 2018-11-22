//
//  PaymentMethod.m
//  ML
//
//  Created by kb on 11/21/18.
//  Copyright © 2018 kb. All rights reserved.
//

#import "PaymentMethod.h"

@implementation PaymentMethod

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
