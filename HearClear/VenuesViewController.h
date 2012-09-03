//
//  VenuesViewController.h
//  HearClear
//
//  Created by Dan Nolan on 3/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FoursquareNetworkController.h"

@interface VenuesViewController : UITableViewController<CLLocationManagerDelegate, FSQVenueDelegate>
{
    CLLocationManager *locationManager;
    NSArray *myVenues;
}

@end
