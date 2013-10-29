//
//  ViewController.m
//  ECBluetoothDemo
//
//  Created by SU BO-YU on 2013/10/29.
//  Copyright (c) 2013年 SU BO-YU. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.activity.hidden = YES;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [ECBlueToothManager shared].delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressScan:(id)sender
{
    [[ECBlueToothManager shared] scanBluetooth];
}

#pragma mark - ECBlueToothManagerDelegate
- (void)blueToothManager:(ECBlueToothManager *)manager didDisconverIBluetooth:(id<IECBluetooth>)bluetooth
{
    [self.tableView reloadData];
}

- (void)blueToothManager:(ECBlueToothManager *)manager didConnectIBluetooth:(id<IECBluetooth>)bluetooth
{
    [self.tableView reloadData];
}

- (void)blueToothManager:(ECBlueToothManager *)central didDisconnectIBluetooth:(id<IECBluetooth>)bluetooth
{
    [self.tableView reloadData];
}

- (void)startSconWithBlueToothManager:(ECBlueToothManager *)manager
{
    self.activity.hidden = NO;
    [self.activity startAnimating];
}

- (void)stopSconWithBlueToothManager:(ECBlueToothManager *)manager
{
    self.activity.hidden = YES;
    [self.activity stopAnimating];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [ECBlueToothManager shared].bluetooths.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *identifier = @"BluetoothCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    id<IECBluetooth> bluetooth = [[ECBlueToothManager shared].bluetooths objectAtIndex:indexPath.row];
    cell.textLabel.text = [bluetooth Name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"BLE:%@", ([bluetooth isBLE]?@"YES":@"NO")];
    if([bluetooth isConnect])
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<IECBluetooth> bluetooth = [[ECBlueToothManager shared].bluetooths objectAtIndex:indexPath.row];
    if ([bluetooth isConnect])
    {
        [[ECBlueToothManager shared] disConnectWithIBluetooth:bluetooth];
    }
    else
    {
        [[ECBlueToothManager shared] connectWithIBluetooth:bluetooth];
    }
}
@end
