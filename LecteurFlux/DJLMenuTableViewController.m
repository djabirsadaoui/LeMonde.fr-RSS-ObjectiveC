//
//  DJLMenuTableViewController.m
//  LecteurFlux
//
//  Created by djabir sadaoui on 16/12/2015.
//  Copyright © 2015 djabir. All rights reserved.
//

#import "DJLMenuTableViewController.h"
#import "DJLStartViewController.h"
@interface DJLMenuTableViewController ()

@end

@implementation DJLMenuTableViewController
@synthesize categoriesData,startcontroller;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_s"]];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!categoriesData) {
        return 0;
    }
    return categoriesData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *idCellule = @"menuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idCellule forIndexPath:indexPath];
    
    cell.textLabel.text = [[categoriesData objectAtIndex:indexPath.row] capitalizedString];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [startcontroller showTableViewForcategory:[[tableView cellForRowAtIndexPath:indexPath] textLabel].text];
}


@end
