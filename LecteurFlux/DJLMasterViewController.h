//
//  MasterViewController.h
//  LecteurFlux
//
//  Created by djabir sadaoui on 07/12/2015.
//  Copyright © 2015 djabir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJLChanelFlux.h"
#import "DJLImageFlux.h"
#import "DJLItemFlux.h"
#import <RestKit/RestKit.h>
#import "DJLTableViewCell.h"
#import "AppDelegate.h"
@class DJLDetailViewController;

@interface DJLMasterViewController : UITableViewController

@property (strong, nonatomic) DJLDetailViewController *detailViewController;
@property(strong,nonatomic)NSArray *dataFlow;
@property(strong,nonatomic)DJLChanelFlux *chanelFlow;

@property NSUInteger pageIndex;
//-(void)getFlowForCategory:(NSString*)category;
//-(void)fetchFlowFromContext;
- (IBAction)refreshData:(UIBarButtonItem *)sender;

@end

