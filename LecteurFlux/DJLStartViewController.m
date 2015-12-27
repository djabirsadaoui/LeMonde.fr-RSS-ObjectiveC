//
//  DJLStartViewController.m
//  LecteurFlux
//
//  Created by djabir sadaoui on 09/12/2015.
//  Copyright © 2015 djabir. All rights reserved.
//

#import "DJLStartViewController.h"
#import "DJLMasterViewController.h"
@interface DJLStartViewController ()

@end

@implementation DJLStartViewController

@synthesize categoryNews,categoriesData,indexcategory,managedModel,managedContext,DJLdelegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // extract managedObjectModel and managedObjectContext
    managedModel = [[[RKObjectManager sharedManager] managedObjectStore] managedObjectModel];
    managedContext = [[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext];
    [self createRequestModelForChannel];
    categoryNews = [NSArray arrayWithObjects:@"emploi",@"disparitions",@"libye",@"concours",@"bachelor",@"afrique",@"football",@"immobilier",@"japon",@"paris", nil];
    categoriesData = [NSMutableArray array];
    for (NSString *item in categoryNews) {
        [self getFlowForCategory:item];
       
    }
     UINavigationController *navigator = (UINavigationController*)[self rearViewController];
    DJLMenuTableViewController *controller = (DJLMenuTableViewController*) [navigator topViewController];
    [controller setStartcontroller:self];
    [controller setCategoriesData:categoryNews];
    [[controller tableView] reloadData];
    
}

-(void)showTableViewForcategory:(NSString*)category{
    UINavigationController *navigator = (UINavigationController*)[self frontViewController];
    DJLMasterViewController *controller = (DJLMasterViewController*)[navigator topViewController];
    [controller setStartController:self];
    [self setDJLdelegate:controller];
    [controller setTitle:category];
    DJLChanelFlux *channel = [self getChannelForCategory:category];
    NSLog(@"title : %@",channel.items.anyObject.title);
    [controller setChanelFlow:channel];
    [controller setDataFlow:channel.items.allObjects];
    [self setFrontViewPosition:FrontViewPositionLeft];
    [[controller tableView] reloadData];
    
    
}

-(DJLChanelFlux*)getChannelForCategory:(NSString*)category{
     NSArray *array = [self searchChannelsWithPredicate:category];
     DJLChanelFlux * obj = [array firstObject];
        return obj;
}
/******************  create template request for Channel**********************************/
-(void) createRequestModelForChannel{
    NSEntityDescription *entityDesc = [[managedModel entitiesByName] objectForKey:@"DJLChanelFlux"];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"(title contains [cd] $TITLE)"];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    [request setPredicate:predicate];
    [managedModel setFetchRequestTemplate:request forName:@"myRequest"];
    
}



/******************  extract template requet from model and excute it **********************************/
-(NSArray*) searchChannelsWithPredicate:(NSString*)text{
    NSError *error;
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:text,@"TITLE", nil];
    NSFetchRequest *extractionRequest = [managedModel fetchRequestFromTemplateWithName:@"myRequest" substitutionVariables:dic];
   
    NSArray *array = [managedContext executeFetchRequest:extractionRequest error:&error];
    
    if ([array count] == 0) {
              return nil;
    } else {
        return array;
    }
    
}
/******************  send request to server for category **********************************/
-(void)getFlowForCategory:(NSString *)category{
    NSString * sufix = @"rss_full.xml";
    NSString * requesPath = [NSString stringWithFormat:@"/%@/%@",category,sufix];
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager getObjectsAtPath:requesPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self fetchFlowFromContext];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"l'erreur se trouve : %@",error);
        [self fetchFlowFromContext];
    }];
}


/******************  after response of server , extract data from data base **********************************/
-(void)fetchFlowFromContext{
    NSError *error;
    NSArray *array = [self searchChannelsWithPredicate:categoryNews[indexcategory]];
    indexcategory++;
    if (array) {
       DJLChanelFlux *chanelFlow =(DJLChanelFlux*)[array objectAtIndex:0];
        // extract the items from channel
        NSArray *dataFlow = [[chanelFlow items] allObjects];
        // set image in data base for each item
        for (DJLItemFlux *item in dataFlow) {
            if (item.image.url) {
                if (!(item.image.imageData)) {
                    NSURL *urlImage = [[NSURL alloc] initWithString:item.image.url];
                    NSData *data = [[NSData alloc ]initWithContentsOfURL:urlImage];
                    [[item image] setImageData:data];
                }
            }
        }
        [managedContext saveToPersistentStore:&error];
        [categoriesData addObject:chanelFlow];
        if (indexcategory == categoryNews.count) {
            [self showTableViewForcategory:@"Emploi"];
        }
        if (error) {
            NSLog(@"failed save data");
        }
        // reload table view
       
    }else{
        NSLog(@"have not data local");
    }
}

/******************* refresh data for this category ****************************/
-(void)refreshDataFromServerWithCategory:(NSString*)category {
   
    NSString * sufix = @"rss_full.xml";
  
    NSString * requesPath = [NSString stringWithFormat:@"/%@/%@",category,sufix];
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [manager getObjectsAtPath:requesPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSArray *array = [self searchChannelsWithPredicate:category];
        if (array) {
            DJLChanelFlux *chanelFlow =(DJLChanelFlux*)[array objectAtIndex:0];
            // extract the items from channel
            NSArray *dataFlow = [[chanelFlow items] allObjects];
            // set image in data base for each item
            for (DJLItemFlux *item in dataFlow) {
                if (item.image.url) {
                    if (!(item.image.imageData)) {
                        NSURL *urlImage = [[NSURL alloc] initWithString:item.image.url];
                        NSData *data = [[NSData alloc ]initWithContentsOfURL:urlImage];
                        [[item image] setImageData:data];
                    }
                }
            }
            [managedContext saveToPersistentStore:nil];
            [[self DJLdelegate]DJLStartViewController:self didFinishRefreshWithChannel:chanelFlow ];
        }else{
            NSLog(@"empty data with this category : %@",self.navigationItem.title);
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"l'erreur se trouve : %@",error);
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
