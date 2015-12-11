//
//  DJLChanelFlux+CoreDataProperties.h
//  LecteurFlux
//
//  Created by djabir sadaoui on 08/12/2015.
//  Copyright © 2015 djabir. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DJLChanelFlux.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJLChanelFlux (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSString *pubDate;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSSet<DJLItemFlux *> *items;

@end

@interface DJLChanelFlux (CoreDataGeneratedAccessors)

- (void)addItemsObject:(DJLItemFlux *)value;
- (void)removeItemsObject:(DJLItemFlux *)value;
- (void)addItems:(NSSet<DJLItemFlux *> *)values;
- (void)removeItems:(NSSet<DJLItemFlux *> *)values;

@end

NS_ASSUME_NONNULL_END
