//
//  AuthenticationViewController.h
//  HearClear
//
//  Created by Dan Nolan on 3/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSNetwork.h"
@interface AuthenticationViewController : UIViewController<UIWebViewDelegate>
{
   IBOutlet UIWebView *myWebView;
}


@end
