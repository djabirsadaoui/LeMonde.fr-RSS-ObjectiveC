//
//  DJLStartViewController.m
//  LecteurFlux
//
//  Created by djabir sadaoui on 09/12/2015.
//  Copyright © 2015 djabir. All rights reserved.
//

#import "DJLStartViewController.h"

@interface DJLStartViewController ()

@end

@implementation DJLStartViewController
@synthesize categoryNews,categoryData,indexcategory,managedModel,managedContext;
- (void)viewDidLoad {
    [super viewDidLoad];
    // extract managedObjectModel and managedObjectContext
    managedModel = [[[RKObjectManager sharedManager] managedObjectStore] managedObjectModel];
    managedContext = [[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext];
    [self createRequestModelForChannel];
    categoryNews = [NSArray arrayWithObjects:@"emploi",@"disparitions",@"ameriques", nil];
    categoryData = [NSMutableArray array];
    for (NSString *item in categoryNews) {
        [self getFlowForCategory:item];
       
    }
    
}

-(void)showTableView{
    if (self.storyboard) {
        self.pageViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"pageViewController"];
    }
    self.pageViewController.dataSource = self;
    float sizeNavigationBar = self.navigationController.navigationBar.frame.size.height+20;
    DJLMasterViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    // Change the size of page view controller
    self.pageViewController.view.frame =  CGRectMake(0,sizeNavigationBar, self.view.frame.size.width, self.view.frame.size.height- sizeNavigationBar);
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    self.navigationItem.title =categoryNews[0];
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
        [categoryData addObject:chanelFlow];
        if (indexcategory == categoryNews.count) {
            [self showTableView];
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
-(IBAction)refreshCategory:(id)sender {
    DJLMasterViewController *controller = self.pageViewController.viewControllers.lastObject;
    NSString * sufix = @"rss_full.xml";
  
    NSString * requesPath = [NSString stringWithFormat:@"/%@/%@",self.navigationItem.title,sufix];
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager getObjectsAtPath:requesPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSArray *array = [self searchChannelsWithPredicate:self.navigationItem.title];
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
            [controller setDataFlow:[chanelFlow.items allObjects]];
            [controller.tableView reloadData];
        }else{
            NSLog(@"empty data with this category : %@",self.navigationItem.title);
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"l'erreur se trouve : %@",error);
    }];
    
    
}



-(DJLMasterViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.categoryNews count] == 0) || (index >= [self.categoryNews count])) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    DJLMasterViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    DJLChanelFlux * chanel = self.categoryData[index];
    pageContentViewController.dataFlow = [[chanel items] allObjects];
    pageContentViewController.pageIndex = index;
    self.navigationItem.title =categoryNews[index];
    return pageContentViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((DJLMasterViewController*) viewController).pageIndex;
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
   
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((DJLMasterViewController*) viewController).pageIndex;
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.categoryNews count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.categoryData count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
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
