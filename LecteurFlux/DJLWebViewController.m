//
//  DJLWebViewController.m
//  LecteurFlux
//
//  Created by djabir sadaoui on 17/12/2015.
//  Copyright © 2015 djabir. All rights reserved.
//

#import "DJLWebViewController.h"

@interface DJLWebViewController ()

@end

@implementation DJLWebViewController
@synthesize link,myWebView,toolBar,backButton,nexButton,offSet,activityIndicator;
- (void)viewDidLoad {
    [super viewDidLoad];
    [myWebView setDelegate:self];
    [[myWebView scrollView ]setDelegate:self];
    
    
    // Do any additional setup after loading the view.
    
   
   // NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    NSURL *url = [NSURL URLWithString:link];
     NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    //[webView loadHTMLString:html baseURL:urlRequest];
    [myWebView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)webViewDidStartLoad:(UIWebView *)webView{
    [activityIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [activityIndicator stopAnimating];
    if (webView.canGoBack) {
        [backButton setEnabled:YES];
    }else{
         [backButton setEnabled:NO];
    }
    if (webView.canGoForward) {
        [nexButton setEnabled:YES];
    }else{
        [nexButton setEnabled:NO];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > offSet){
        [toolBar setHidden:YES];
    }else{
        [toolBar setHidden:NO];
    }
    offSet = scrollView.contentOffset.y;
}

- (IBAction)goToBack:(UIBarButtonItem *)sender {
    [myWebView goBack];
}

- (IBAction)goToHome:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil ];
}

- (IBAction)goToNext:(UIBarButtonItem *)sender {
    [myWebView goForward];
    
}
@end
