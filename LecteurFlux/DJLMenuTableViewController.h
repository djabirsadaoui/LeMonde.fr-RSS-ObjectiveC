//
//  DJLMenuTableViewController.h
//  LecteurFlux
//
//  Created by djabir sadaoui on 16/12/2015.
//  Copyright © 2015 djabir. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DJLStartViewController;
@interface DJLMenuTableViewController : UITableViewController
@property(nonatomic)NSArray *categoriesData;
@property(weak,nonatomic)DJLStartViewController *startcontroller;
@end
