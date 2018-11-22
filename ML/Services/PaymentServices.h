//
//  PaymentServices.h
//  ML
//
//  Created by kb on 11/21/18.
//  Copyright © 2018 kb. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PaymentServicesDelegate <NSObject>
@required
-(void)didFininshGetPaymentMethodsWithJson:(NSArray *)responseJson;
-(void)didFininshGetPaymentMethodsWithError:(NSError *)error;
-(void)didFininshGetPaymentMethodIssuersWithJson:(NSArray *)responseJson;
-(void)didFininshGetPaymentMethodIssuersWithError:(NSError *)error;
-(void)didFininshGetPaymentInstallmentsWithJson:(NSArray *)responseJson;
-(void)didFininshGetPaymentInstallmentsWithError:(NSError *)error;
@end

@interface PaymentServices : NSObject
@property (nonatomic,weak) NSObject <PaymentServicesDelegate> *delegate;

-(void)getPaymentMethods;
-(void)getPaymentIssuersWithMethod:(NSString *)method;
-(void)getPaymentInstallmentsWithAmount:(NSString *)amount method:(NSString *)method issuer:(NSString *)issuer;
@end
