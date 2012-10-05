//
//  VenueDetailControllerViewController.h
//  HearClear
//
//  Created by Dan Nolan on 3/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSNetwork.h"
#import "MainViewController.h"
#import <MapKit/MapKit.h>
#import "HCNetwork.h"

@interface VenueDetailControllerViewController : UIViewController<FSNetworkDelegate, MKMapViewDelegate, HCNetworkDelegate>

@property(strong,nonatomic)NSDictionary *venueDictionary;

-(IBAction)performCheckin:(id)sender;

@end
