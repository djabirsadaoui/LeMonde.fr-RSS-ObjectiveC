//
//  MasterViewController.m
//  LecteurFlux
//
//  Created by djabir sadaoui on 07/12/2015.
//  Copyright © 2015 djabir. All rights reserved.
//

#import "DJLMasterViewController.h"
#import "DJLDetailViewController.h"
#import "DJLStartViewController.h"
#import "DJLWebViewController.h"
#import "SWRevealViewController.h"
@interface DJLMasterViewController ()


@end

@implementation DJLMasterViewController
@synthesize dataFlow,chanelFlow,refreshControl,startController;

- (void)viewDidLoad {
    [super viewDidLoad];
    refreshControl = [[UIRefreshControl alloc] init];
    [[self view] addSubview:refreshControl];
   
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

}



- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [refreshControl beginRefreshing];
    [startController refreshDataFromServerWithCategory:[[self title] lowercaseString]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)DJLStartViewController:(DJLStartViewController *)controller didFinishRefreshWithChannel:(DJLChanelFlux *)channel{
    [refreshControl endRefreshing];
    [self setChanelFlow:channel];
    [self setDataFlow:channel.items.allObjects];
    [[self tableView] reloadData];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DJLItemFlux *object = self.dataFlow[indexPath.row];
        DJLDetailViewController *controller = (DJLDetailViewController *)[segue destinationViewController] ;
        [controller setItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }else if ([[segue identifier] isEqualToString:@"showViewWeb"]){
        DJLWebViewController *controller = [segue destinationViewController];
        NSIndexPath *index =[self.tableView indexPathForSelectedRow];
        DJLTableViewCell *cell = (DJLTableViewCell*)[self.tableView cellForRowAtIndexPath:index];
        NSString *link = cell.urlWeb;
        [controller setLink:link];
        
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
    UIImage *img =  [UIImage imageWithData:imageFlow.imageData scale:0.5];
    [cell.imageView setImage:img];
    [cell setUrlWeb:item.link];
    return cell;
}


@end
