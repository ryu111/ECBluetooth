//
//  ViewController.h
//  ECBluetoothDemo
//
//  Created by SU BO-YU on 2013/10/29.
//  Copyright (c) 2013年 SU BO-YU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECBlueToothManager.h"

@interface ViewController : UIViewController <ECBlueToothManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
