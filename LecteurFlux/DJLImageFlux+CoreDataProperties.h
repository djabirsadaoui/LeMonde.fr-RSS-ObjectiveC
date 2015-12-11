//
//  DJLImageFlux+CoreDataProperties.h
//  LecteurFlux
//
//  Created by djabir sadaoui on 09/12/2015.
//  Copyright © 2015 djabir. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DJLImageFlux.h"
#import  "DJLChanelFlux+CoreDataProperties.h"
NS_ASSUME_NONNULL_BEGIN

@interface DJLImageFlux (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSData *imageData;

@end

NS_ASSUME_NONNULL_END
