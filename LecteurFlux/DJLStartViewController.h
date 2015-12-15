//
//  DJLStartViewController.h
//  LecteurFlux
//
//  Created by djabir sadaoui on 09/12/2015.
//  Copyright © 2015 djabir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJLMasterViewController.h"
#import "DJLChanelFlux.h
#import "DJLImageFlux.h"
#import "DJLItemFlux.h"

@interface DJLStartViewController : SWRevealViewController


@property (strong, nonatomic) UIPageViewController              *pageViewController;
@property (strong, nonatomic) NSArray                           *categoryNews;
@property (strong, nonatomic) NSMutableArray                    *categoryData;
@property int                                                   indexcategory;
@property (strong,nonatomic)NSManagedObjectModel                *managedModel;
@property (strong,nonatomic)NSManagedObjectContext              *managedContext;


- (IBAction)refreshCategory:(id)sender;
- (DJLMasterViewController *)viewControllerAtIndex:(NSUInteger) index;
-(void) getFlowForCategory:(NSString*)category;
-(void) createRequestModelForChannel;
-(void) fetchFlowFromContext;
-(NSArray*) searchChannelsWithPredicate:(NSString*)text;
@end
