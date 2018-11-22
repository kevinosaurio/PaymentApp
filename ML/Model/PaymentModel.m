//
//  PaymentModel.m
//  ML
//
//  Created by kb on 11/21/18.
//  Copyright © 2018 kb. All rights reserved.
//

#import "PaymentModel.h"
#import "PaymentServices.h"

@interface PaymentModel () <PaymentServicesDelegate>
@property (strong, nonatomic, readwrite) NSString *amount;
@property (strong, nonatomic) PaymentServices * services;
@property (weak, nonatomic) id <PaymentViewModelProtocol> currentView;
@end

@implementation PaymentModel

- (PaymentServices *) services
{
    if(!_services) {
        _services = [[PaymentServices alloc] init];
        _services.delegate = self;
    }
    return _services;
}

-(void)clean{
    _amount = nil;
    _selectedMethod = nil;
    _selectedIssuer = nil;
    _selectedInstallment = nil;
}

#pragma mark - Validations

-(BOOL)checkAmount:(NSString *)amount {
    if([amount rangeOfString:PREFIX].location == NSNotFound || [amount isEqualToString:PREFIX] || [amount isEqualToString:[NSString stringWithFormat:@"%@0", PREFIX]] ){
        return false;
    }
    _amount = amount;
    return true;
}

#pragma mark - Call request

//PaymentMethods

-(void)getPaymentMethodsWithCurrentView:(id <PaymentViewModelProtocol>)currentView{
    self.currentView = currentView;
    [self.services getPaymentMethods];
}

- (void)didFininshGetPaymentMethodsWithJson:(NSArray *)responseJson {
    NSMutableArray * methods = [[NSMutableArray alloc] init];
    for (NSDictionary* methodDic in responseJson)
    {
        PaymentMethod * method = [[PaymentMethod alloc] initWithNSDictionary:methodDic];
        [methods addObject:method];
    }
    if ([self.currentView respondsToSelector:@selector(didFinishGetPaymentMethods:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.currentView didFinishGetPaymentMethods:methods];
        });
    }
}

- (void)didFininshGetPaymentMethodsWithError:(NSError *)error {
    if ([self.currentView respondsToSelector:@selector(didFinishGetPaymentMethodsWithError:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.currentView didFinishGetPaymentMethodsWithError:error.localizedDescription];
        });
    }
}

//PaymentMethodsIssuers

-(void)getPaymentMethodIssuersWithCurrentView:(id<PaymentViewModelProtocol>)currentView{
    self.currentView = currentView;
    [self.services getPaymentIssuersWithMethod:self.selectedMethod.iD ? self.selectedMethod.iD:@""];
}

- (void)didFininshGetPaymentMethodIssuersWithJson:(NSArray *)responseJson {
    NSMutableArray * issuers = [[NSMutableArray alloc] init];
    for (NSDictionary* issuerDic in responseJson)
    {
        PaymentMethodIssuers * issuer = [[PaymentMethodIssuers alloc] initWithNSDictionary:issuerDic];
        [issuers addObject:issuer];
    }
    if ([self.currentView respondsToSelector:@selector(didFinishGetPaymentMethodIssuers:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.currentView didFinishGetPaymentMethodIssuers:issuers];
        });
    }
}

- (void)didFininshGetPaymentMethodIssuersWithError:(NSError *)error {
    if ([self.currentView respondsToSelector:@selector(didFinishGetPaymentMethodIssuersWithError:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.currentView didFinishGetPaymentMethodIssuersWithError:error.localizedDescription];
        });
    }
}

//PaymentInstallments

-(void)getPaymentInstallmentsWithCurrentView:(id<PaymentViewModelProtocol>)currentView {
    self.currentView = currentView;
    [self.services getPaymentInstallmentsWithAmount:[self.amount stringByReplacingOccurrencesOfString:PREFIX withString:@""]
                                             method:self.selectedMethod.iD ? self.selectedMethod.iD:@""
                                             issuer:self.selectedIssuer.iD ? self.selectedIssuer.iD:@""];
}

- (void)didFininshGetPaymentInstallmentsWithJson:(NSArray *)responseJson {
    NSMutableArray * installments = [[NSMutableArray alloc] init];
    //Get first element
    if(responseJson.count > 0){
        NSDictionary * jsonDic = responseJson[0];
        NSArray * payerCosts = [jsonDic objectForKey:@"payer_costs"];
        for (NSDictionary* installmentsDic in payerCosts)
        {
            NSString * installment = [installmentsDic objectForKey:@"recommended_message"];
            [installments addObject:installment];
        }
    }
    if ([self.currentView respondsToSelector:@selector(didFinishGetPaymentInstallments:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.currentView didFinishGetPaymentInstallments:installments];
        });
    }
}

- (void)didFininshGetPaymentInstallmentsWithError:(NSError *)error {
    if ([self.currentView respondsToSelector:@selector(didFinishGetPaymentInstallmentsWithError:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.currentView didFinishGetPaymentInstallmentsWithError:error.localizedDescription];
        });
    }
}

@end
