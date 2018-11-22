//
//  PaymentMethodViewController.m
//  ML
//
//  Created by kb on 11/21/18.
//  Copyright © 2018 kb. All rights reserved.
//

#import "PaymentMethodViewController.h"
#import "PaymentTableViewCell.h"
#import "PaymentMethodIssuersViewController.h"

#define SEGUE_TO_ISSUERS @"segueToPaymentIssuers"

@interface PaymentMethodViewController () <UITableViewDataSource, UITableViewDelegate, PaymentViewModelProtocol>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIButton *tryAgainButton;

@property (strong,nonatomic) NSMutableArray *methods;

@end

@implementation PaymentMethodViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //Clean TableView rows
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //Register Cell
    UINib *nib = [UINib nibWithNibName:@"PaymentTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:PAYMENT_REUSE_IDENTIFIER];
    //Get Methods
    [self getMethods];
}

#pragma mark - Data Functions

- (NSArray *) methods
{
    if(!_methods) _methods = [[NSMutableArray alloc] init];
    return _methods;
}

- (void) getMethods {
    [_activityIndicatorView startAnimating];
    [self.model getPaymentMethodsWithCurrentView:self];
}

#pragma mark - Actions

- (IBAction)tryAgain:(UIButton *)sender
{
    sender.hidden = YES;
    [self getMethods];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _methods.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PAYMENT_REUSE_IDENTIFIER];
    PaymentMethod * item = [self.methods objectAtIndex:indexPath.row];
    [cell setName:item.name imageUrl:item.imageUrl];
    return cell;
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PAYMENT_CELL_DEFAULT_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PaymentMethod * item = [self.methods objectAtIndex:indexPath.row];
    self.model.selectedMethod = item;
    [self performSegueWithIdentifier:SEGUE_TO_ISSUERS sender:nil];
}

#pragma mark - PaymentViewModelProtocol

-(void)didFinishGetPaymentMethods:(NSArray *)paymentMethods{
    [self.activityIndicatorView stopAnimating];
    [self.methods removeAllObjects];
    [self.methods addObjectsFromArray:paymentMethods];
    [self.tableView reloadData];
}

-(void)didFinishGetPaymentMethodsWithError:(NSString *)error{
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
    PaymentMethodIssuersViewController *vc = [segue destinationViewController];
    vc.model = self.model;
}

@end
