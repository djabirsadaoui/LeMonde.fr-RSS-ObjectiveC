//
//  DJLDetailViewController.h
//  LecteurFlux
//
//  Created by djabir sadaoui on 08/12/2015.
//  Copyright © 2015 djabir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJLItemFlux.h"
#import "DJLImageFlux.h"
@interface DJLDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView    *imageView;
@property (weak, nonatomic) IBOutlet UILabel        *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView     *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextView     *titleTextView;
@property(strong,nonatomic) DJLItemFlux             *item;
@end
