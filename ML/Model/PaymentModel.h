//
//  PaymentModel.h
//  ML
//
//  Created by kb on 11/21/18.
//  Copyright © 2018 kb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentMethod.h"
#import "PaymentMethodIssuers.h"
#define PREFIX @"$"

@protocol PaymentViewModelProtocol <NSObject>
@optional
-(void)didFinishGetPaymentMethods:(NSArray *)paymentMethods;
-(void)didFinishGetPaymentMethodsWithError:(NSString *)error;
-(void)didFinishGetPaymentMethodIssuers:(NSArray *)paymentMethodIssuers;
-(void)didFinishGetPaymentMethodIssuersWithError:(NSString *)error;
-(void)didFinishGetPaymentInstallments:(NSArray *)installments;
-(void)didFinishGetPaymentInstallmentsWithError:(NSString *)error;
@end


@interface PaymentModel : NSObject
@property (strong, nonatomic, readonly) NSString *amount;
@property (strong, nonatomic) PaymentMethod * selectedMethod;
@property (strong, nonatomic) PaymentMethodIssuers * selectedIssuer;
@property (strong, nonatomic) NSString * selectedInstallment;
-(void)clean;
-(BOOL)checkAmount:(NSString *)amount;
//Calls
-(void)getPaymentMethodsWithCurrentView:(id <PaymentViewModelProtocol>)currentView;
-(void)getPaymentMethodIssuersWithCurrentView:(id <PaymentViewModelProtocol>)currentView;
-(void)getPaymentInstallmentsWithCurrentView:(id <PaymentViewModelProtocol>)currentView;
@end
