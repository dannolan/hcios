//
//  AuthenticationViewController.m
//  HearClear
//
//  Created by Dan Nolan on 3/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import "AuthenticationViewController.h"

@interface AuthenticationViewController ()

@end

@implementation AuthenticationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *authenticateURLString = [NSString stringWithFormat:@"https://foursquare.com/oauth2/authenticate?client_id=%@&response_type=token&redirect_uri=%@",@"VS1C3CG0UFVGIRQLDMN3C5W4Z31SDMEKJVLTUNVWLGJKSKJB", @"http://hearclear.synthetica.com"];
    NSURLRequest *fsqRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:authenticateURLString]];
    [myWebView loadRequest:fsqRequest];
    //[myWebView l]
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *URLString = [[myWebView.request URL] absoluteString];
    NSLog(@"--> %@", URLString);
    if ([URLString rangeOfString:@"access_token="].location != NSNotFound) {
        NSString *accessToken = [[URLString componentsSeparatedByString:@"="] lastObject];
        [FSNetwork storeFoursquareToken:accessToken];
        [FSNetwork requestUserID];
        NSLog(@"User ID requesting");
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
    }
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
        if ([request.URL.scheme isEqualToString:@"itms-apps"]) {
            [[UIApplication sharedApplication] openURL:request.URL];
            return NO;
        }
        return YES;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
