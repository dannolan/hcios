//
//  MainViewController.h
//  HearClear
//
//  Created by Dan Nolan on 3/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
{
    //IBOutlet UIButton *infoButton;
    IBOutlet UIButton *checkinButton;
    IBOutlet UIButton *authButton;
}



-(IBAction)displayAuthenticateScreen:(id)sender;
-(IBAction)displayCheckinScreen:(id)sender;

@end
