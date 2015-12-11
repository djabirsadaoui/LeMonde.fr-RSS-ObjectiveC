//
//  MasterViewController.m
//  LecteurFlux
//
//  Created by djabir sadaoui on 07/12/2015.
//  Copyright © 2015 djabir. All rights reserved.
//

#import "DJLMasterViewController.h"
#import "DJLDetailViewController.h"


@interface DJLMasterViewController ()


@end

@implementation DJLMasterViewController
@synthesize dataFlow,chanelFlow;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailViewController = (DJLDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
}

- (IBAction)refreshData:(UIBarButtonItem *)sender {
    //[self getFlowForCategory:@"afrique"];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DJLItemFlux *object = self.dataFlow[indexPath.row];
        DJLDetailViewController *controller = (DJLDetailViewController *)[[segue destinationViewController] topViewController];
        [controller setItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!dataFlow) {
        return 0;
    }
    return self.dataFlow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *idCellule = @"Cell";
    DJLTableViewCell *cell = (DJLTableViewCell*)[tableView dequeueReusableCellWithIdentifier:idCellule forIndexPath:indexPath];
    DJLItemFlux *item = [dataFlow objectAtIndex:indexPath.row];
    DJLImageFlux *imageFlow = item.image;
    [cell.titleLabel setText:item.title];
   
    UIImage *img = [[UIImage alloc ]initWithData:imageFlow.imageData];
    [cell.imageView setImage:img];
    return cell;
}

@end
