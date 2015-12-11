//
//  DJLItemFlux+CoreDataProperties.h
//  LecteurFlux
//
//  Created by djabir sadaoui on 07/12/2015.
//  Copyright © 2015 djabir. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DJLItemFlux.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJLItemFlux (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *descriptionFlux;
@property (nullable, nonatomic, retain) NSString *publicationDate;
@property (nullable, nonatomic, retain) DJLImageFlux *image;

@end

NS_ASSUME_NONNULL_END
