//
//  AppDelegate.h
//  LecteurFlux
//
//  Created by djabir sadaoui on 07/12/2015.
//  Copyright © 2015 djabir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import <RKXMLReaderSerialization/RKXMLReaderSerialization.h>
#import "DJLImageFlux.h"
#import "DJLChanelFlux.h"
#import "DJLItemFlux.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow                          *window;
@property(strong, nonatomic) RKObjectManager                    *objectManager ;
@property(readonly,strong, nonatomic) NSManagedObjectContext    *context;

@end

