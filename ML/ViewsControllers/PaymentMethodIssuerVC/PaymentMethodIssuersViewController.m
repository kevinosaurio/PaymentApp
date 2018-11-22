//
//  PaymentMethodIssuersViewController.m
//  ML
//
//  Created by kb on 11/21/18.
//  Copyright © 2018 kb. All rights reserved.
//

#import "PaymentMethodIssuersViewController.h"
#import "PaymentTableViewCell.h"
#import "PaymentInstallmentsViewController.h"

#define SEGUE_TO_INSTALLMENTS @"segueToPaymentInstallments"

@interface PaymentMethodIssuersViewController() <UITableViewDataSource, UITableViewDelegate, PaymentViewModelProtocol>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIButton *tryAgainButton;

@property (strong,nonatomic) NSMutableArray *issuers;
@end

@implementation PaymentMethodIssuersViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //Register Cell
    UINib *nib = [UINib nibWithNibName:@"PaymentTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:PAYMENT_REUSE_IDENTIFIER];
    //Get Issuers
    [self getIssuers];
}

#pragma mark - Data Functions

- (NSArray *) issuers
{
    if(!_issuers) _issuers = [[NSMutableArray alloc] init];
    return _issuers;
}

- (void) getIssuers {
    [_activityIndicatorView startAnimating];
    [self.model getPaymentMethodIssuersWithCurrentView:self];
}

#pragma mark - Actions

- (IBAction)tryAgain:(UIButton *)sender
{
    sender.hidden = YES;
    [self getIssuers];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _issuers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PAYMENT_REUSE_IDENTIFIER];
    PaymentMethod * item = [self.issuers objectAtIndex:indexPath.row];
    [cell setName:item.name imageUrl:item.imageUrl];
    return cell;
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PAYMENT_CELL_DEFAULT_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PaymentMethodIssuers * item = [self.issuers objectAtIndex:indexPath.row];
    self.model.selectedIssuer = item;
    [self performSegueWithIdentifier:SEGUE_TO_INSTALLMENTS sender:nil];
}

#pragma mark - PaymentViewModelProtocol

-(void)didFinishGetPaymentMethodIssuers:(NSArray *)paymentMethodIssuers{
    [self.activityIndicatorView stopAnimating];
    [self.issuers removeAllObjects];
    [self.issuers addObjectsFromArray:paymentMethodIssuers];
    [self.tableView reloadData];
}

-(void)didFinishGetPaymentMethodIssuersWithError:(NSString *)error{
    //Show error:
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Error"
                                 message:error
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Button
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [self.activityIndicatorView stopAnimating];
                                   self.tryAgainButton.hidden = NO;
                               }];
    
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PaymentInstallmentsViewController *vc = [segue destinationViewController];
    vc.model = self.model;
}

@end
