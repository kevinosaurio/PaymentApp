//
//  PaymentServices.m
//  ML
//
//  Created by kb on 11/21/18.
//  Copyright © 2018 kb. All rights reserved.
//

#import "PaymentServices.h"
static NSString *const PUBLIC_KEY = @"444a9ef5-8a6b-429f-abdf-587639155d88";

@implementation PaymentServices

-(void)getPaymentMethods{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString * urlString = [NSString stringWithFormat:@"https://api.mercadopago.com/v1/payment_methods?public_key=%@",PUBLIC_KEY];
    [request setURL:[NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (error != nil){
                                          NSLog(@"Error %@",error.localizedDescription);
                                          [self.delegate didFininshGetPaymentMethodsWithError:error];
                                      }
                                      else {
                                          NSError* error;
                                          NSArray* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:kNilOptions
                                                                                                 error:&error];
                                          if(error != nil){
                                             [self.delegate didFininshGetPaymentMethodsWithError:error];
                                          }
                                          else{
                                              [self.delegate didFininshGetPaymentMethodsWithJson:json];
                                          }
                                      }
                                  }];
    [task resume];
}

-(void)getPaymentIssuersWithMethod:(NSString *)method{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString * urlString = [NSString stringWithFormat:@"https://api.mercadopago.com/v1/payment_methods/card_issuers?public_key=%@&payment_method_id=%@",PUBLIC_KEY,method];
    
    [request setURL:[NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (error != nil){
                                          NSLog(@"Error %@",error.localizedDescription);
                                          [self.delegate didFininshGetPaymentMethodIssuersWithError:error];
                                      }
                                      else {
                                          NSError* error;
                                          NSArray* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                          options:kNilOptions
                                                                                            error:&error];
                                          if(error != nil){
                                              [self.delegate didFininshGetPaymentMethodIssuersWithError:error];
                                          }
                                          else{
                                              [self.delegate didFininshGetPaymentMethodIssuersWithJson:json];
                                          }
                                      }
                                  }];
    [task resume];
}

-(void)getPaymentInstallmentsWithAmount:(NSString *)amount method:(NSString *)method issuer:(NSString *)issuer{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString * urlString = [NSString stringWithFormat:@"https://api.mercadopago.com/v1/payment_methods/installments?public_key=%@&amount=%@&payment_method_id=%@&issuer.id=%@",PUBLIC_KEY,amount,method,issuer];
    
    [request setURL:[NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (error != nil){
                                          NSLog(@"Error %@",error.localizedDescription);
                                          [self.delegate didFininshGetPaymentInstallmentsWithError:error];
                                      }
                                      else {
                                          NSError* error;
                                          NSArray* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                          options:kNilOptions
                                                                                            error:&error];
                                          if(error != nil){
                                              [self.delegate didFininshGetPaymentInstallmentsWithError:error];
                                          }
                                          else{
                                              [self.delegate didFininshGetPaymentInstallmentsWithJson:json];
                                          }
                                      }
                                  }];
    [task resume];
}

@end
