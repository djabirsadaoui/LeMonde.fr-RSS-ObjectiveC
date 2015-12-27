//
//  DJLWebViewController.h
//  LecteurFlux
//
//  Created by djabir sadaoui on 17/12/2015.
//  Copyright © 2015 djabir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJLWebViewController : UIViewController<UIWebViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property(nonatomic)float offSet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nexButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property(nonatomic,strong)NSString *link;

- (IBAction)goToBack:(UIBarButtonItem *)sender;
- (IBAction)goToHome:(UIBarButtonItem *)sender;
- (IBAction)goToNext:(UIBarButtonItem *)sender;

@end
