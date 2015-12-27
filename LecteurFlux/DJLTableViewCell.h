//
//  DJLTableViewCell.h
//  LecteurFlux
//
//  Created by djabir sadaoui on 08/12/2015.
//  Copyright © 2015 djabir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJLTableViewCell : UITableViewCell
// ajouter toujour @synthitize parce que il crée juste la méthode getter 
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *titleLabel;
@property (nonatomic)NSString *urlWeb;

@end
