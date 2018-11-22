//
//  MainViewController.m
//  ML
//
//  Created by kb on 11/21/18.
//  Copyright © 2018 kb. All rights reserved.
//

#import "MainViewController.h"
#import "PaymentMethodViewController.h"

#define SEGUE_TO_METHOD @"segueToPaymentMethod"

@interface MainViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (nonatomic) BOOL isFromInstallments;
@end

@implementation MainViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //Init Model
    self.model = [[PaymentModel alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    if(_isFromInstallments){
        [self showSuccessAlert];
        [self.model clean];
        _isFromInstallments = false;
    }
}

#pragma mark - Alert

- (void)showSuccessAlert{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Pago exitoso."
                                 message:[NSString stringWithFormat:@"Ha pagado satisfactoriamente %@ con %@ de %@ en %@",
                                          self.model.amount,
                                          self.model.selectedMethod.name,
                                          self.model.selectedIssuer.name,
                                          self.model.selectedInstallment]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Button
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {}];
    
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Actions

- (IBAction)dismissKeyboard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:true];
}

- (IBAction)pay:(UIButton *)sender {
    NSLog(@"%@", self.model.amount);
    [self.view endEditing:true];
    [self performSegueWithIdentifier:SEGUE_TO_METHOD sender:nil];
}

#pragma mark - UITextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if([textField.text isEqualToString:@""])
        textField.text = PREFIX;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * newString = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    BOOL isValidAmount = [self.model checkAmount:newString];
    if (!isValidAmount) {
        if ([newString isEqualToString:PREFIX]) {
            return YES;
        }
        else {
            //check oldVaue
            [self.payButton setEnabled:[self.model checkAmount:textField.text]];
            return NO;
        }
    }
    [self.payButton setEnabled:YES];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if([textField.text isEqualToString:PREFIX])
        textField.text = @"";
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     PaymentMethodViewController *vc = [segue destinationViewController];
     vc.model = self.model;
 }

-(IBAction)unwindToFinishPayment:(UIStoryboardSegue *)segue {
    _amountTextField.text = @"";
    _isFromInstallments = true;
}

@end
