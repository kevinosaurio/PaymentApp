//
//  PaymentInstallmentsViewController.m
//  ML
//
//  Created by kb on 11/21/18.
//  Copyright © 2018 kb. All rights reserved.
//

#import "PaymentInstallmentsViewController.h"

static NSString *CellIdentifier = @"Cell";
static CGFloat const CellHeight = 60.0;

#define UNWIND_TO_FINISH_PAYMENT @"unwindToFinishPayment"

@interface PaymentInstallmentsViewController () <UITableViewDataSource, UITableViewDelegate, PaymentViewModelProtocol>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIButton *tryAgainButton;

@property (strong,nonatomic) NSMutableArray *installments;
@end

@implementation PaymentInstallmentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //Get Installments
    [self getInstallments];
}

#pragma mark - Data Functions

- (NSArray *) installments
{
    if(!_installments) _installments = [[NSMutableArray alloc] init];
    return _installments;
}

- (void) getInstallments {
    [_activityIndicatorView startAnimating];
    [self.model getPaymentInstallmentsWithCurrentView:self];
}

#pragma mark - Actions

- (IBAction)tryAgain:(UIButton *)sender
{
    sender.hidden = YES;
    [self getInstallments];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _installments.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.installments objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.model.selectedInstallment = [self.installments objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:UNWIND_TO_FINISH_PAYMENT sender:self];
}

#pragma mark - PaymentViewModelProtocol

-(void)didFinishGetPaymentInstallments:(NSArray *)installments{
    [self.activityIndicatorView stopAnimating];
    [self.installments removeAllObjects];
    [self.installments addObjectsFromArray:installments];
    [self.tableView reloadData];
}

-(void)didFinishGetPaymentInstallmentsWithError:(NSString *)error{
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

@end
