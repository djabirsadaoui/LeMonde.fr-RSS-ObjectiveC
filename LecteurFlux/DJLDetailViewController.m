//
//  DJLDetailViewController.m
//  LecteurFlux
//
//  Created by djabir sadaoui on 08/12/2015.
//  Copyright © 2015 djabir. All rights reserved.
//

#import "DJLDetailViewController.h"

@interface DJLDetailViewController ()

@end

@implementation DJLDetailViewController
@synthesize item,titleTextView,descriptionTextView,dateLabel,imageView;
- (void)viewDidLoad {
    [super viewDidLoad];
    if (item) {
        DJLImageFlux *imageFlow = item.image;
        UIImage *img = [[UIImage alloc ]initWithData:item.image.imageData];
        [imageView setImage:img];
        [dateLabel setText:item.publicationDate];
        [descriptionTextView setText:item.descriptionFlux];
        [titleTextView setText:item.title];
    }
   

    
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
