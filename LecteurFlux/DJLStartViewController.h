//
//  DJLStartViewController.h
//  LecteurFlux
//
//  Created by djabir sadaoui on 09/12/2015.
//  Copyright © 2015 djabir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJLChanelFlux.h"
#import "DJLImageFlux.h"
#import "DJLItemFlux.h"
#import "SWRevealViewController.h"
#import "DJLMenuTableViewController.h"
@class DJLMasterViewController;

@protocol DJLStartViewControllerDelegate;
@interface DJLStartViewController : SWRevealViewController


@property (strong, nonatomic) UIPageViewController              *pageViewController;
@property (strong, nonatomic) NSArray                           *categoryNews;
@property (strong, nonatomic) NSMutableArray                    *categoriesData;
@property int                                                   indexcategory;
@property (strong,nonatomic)NSManagedObjectModel                *managedModel;
@property (strong,nonatomic)NSManagedObjectContext              *managedContext;
@property (weak,nonatomic)id<DJLStartViewControllerDelegate> DJLdelegate;

-(void)refreshDataFromServerWithCategory:(NSString*)category;
-(void) getFlowForCategory:(NSString*)category;
-(void)showTableViewForcategory:(NSString*)category;
-(void) createRequestModelForChannel;
-(void) fetchFlowFromContext;
-(DJLChanelFlux*)getChannelForCategory:(NSString*)category;
-(NSArray*) searchChannelsWithPredicate:(NSString*)text;
@end
@protocol DJLStartViewControllerDelegate <NSObject,SWRevealViewControllerDelegate>
-(void)DJLStartViewController:(DJLStartViewController*)controller didFinishRefreshWithChannel:(DJLChanelFlux*)channel;
@end