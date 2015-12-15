//
//  AppDelegate.m
//  LecteurFlux
//
//  Created by djabir sadaoui on 07/12/2015.
//  Copyright © 2015 djabir. All rights reserved.
//

#import "AppDelegate.h"
//#import "DJLDetailViewController.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate

@synthesize objectManager,context;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
//    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    
//    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
//    splitViewController.delegate = self;
    
    /******* show navigation bar and attributes ******************/
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
     [UIColor redColor],UITextAttributeTextColor,[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, -1)],UITextAttributeTextShadowOffset,[UIFont fontWithName:@"Arial-Bold" size:0.0],UITextAttributeFont,nil];
    [[UINavigationBar appearance] setTitleTextAttributes:dic];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.backgroundColor = [UIColor colorWithRed:1 green:0.82 blue:0.2 alpha:1];
   /***********************************************************************/
    
    /****** configurate coreData ***********************************/
    NSError *error;
    NSString *storeBath;
    NSURL *baseURL = [NSURL URLWithString:@"http://www.lemonde.fr"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // specifie the type to parss
    [RKMIMETypeSerialization registerClass:[RKXMLReaderSerialization class] forMIMEType:@"application/rss+xml"];
    [objectManager setAcceptHeaderWithMIMEType:RKMIMETypeTextXML];
    [objectManager setRequestSerializationMIMEType:RKMIMETypeTextXML];
    /************************************************************/
      // retrieve main object model from main bundel
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
   
        BOOL success = RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error);
        if (! success) {
            RKLogError(@"Failed to create Application Data Directory at path '%@': %@", RKApplicationDataDirectory(), error);
        }
     // create and set conection between objectStore and coordinator
    [managedObjectStore createPersistentStoreCoordinator];
    [objectManager setManagedObjectStore:managedObjectStore];

    storeBath = [ RKApplicationDataDirectory() stringByAppendingPathComponent:@"LecteurFlux.sqlite"];
 
    // set conection between objectStore and file in data base
    [managedObjectStore addSQLitePersistentStoreAtPath:storeBath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    if (error) {
        RKLogError(@"Failed adding persistent store at path '%@': %@", storeBath, error);
    }
    
    // set connection between objectStore and context
    [managedObjectStore createManagedObjectContexts];
    context = [managedObjectStore mainQueueManagedObjectContext];
    
  // Configure a managed object cache to ensure we do not create duplicate objects
    [managedObjectStore setManagedObjectCache:[[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:context] ];
    /*****************************************************************************/
    
    /*************************** imageMapping  ***************************/
    RKEntityMapping *imageMapping = [RKEntityMapping mappingForEntityForName:@"DJLImageFlux" inManagedObjectStore:managedObjectStore];
    [imageMapping addAttributeMappingsFromArray:[NSArray arrayWithObjects:@"type",@"url", nil]];
    [imageMapping setIdentificationAttributes:@[@"url"]];
  
    /*************************** itemMapping  ***************************/
    RKEntityMapping *itemMapping = [RKEntityMapping mappingForEntityForName:@"DJLItemFlux" inManagedObjectStore:managedObjectStore];
    [itemMapping addAttributeMappingsFromDictionary:@{@"link.text":@"link",@"title.text":@"title",@"pubDate.text":@"publicationDate",@"description.text":@"descriptionFlux"}];
    [itemMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"enclosure" toKeyPath:@"image" withMapping:imageMapping]];
    [itemMapping setIdentificationAttributes:@[@"link"]];
    
    /*************************** chanelMapping  ***************************/
    RKEntityMapping *chanelMapping = [RKEntityMapping mappingForEntityForName:@"DJLChanelFlux" inManagedObjectStore:managedObjectStore];
    [chanelMapping addAttributeMappingsFromDictionary:@{@"title.text":@"title",@"link.text":@"link",@"pubDate.text":@"pubDate"}];
    [chanelMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"item" toKeyPath:@"items" withMapping:itemMapping]];
    [chanelMapping setIdentificationAttributes:@[@"pubDate"]];
    

    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:chanelMapping method:RKRequestMethodGET pathPattern:nil keyPath:@"rss.channel" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) ];
     // add url sifux to base url of object manager
    [objectManager addResponseDescriptor:responseDescriptor];
   [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Split view

//- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
//    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DJLDetailViewController class]] && ([(DJLDetailViewController *)[(UINavigationController *)secondaryViewController topViewController] item] == nil)) {
//        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
//        return YES;
//    } else {
//        return NO;
//    }
//}

@end
