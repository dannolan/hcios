//
//  VenueSampleViewController.h
//  HearClear
//
//  Created by Dan Nolan on 4/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "VenueCheckin.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface VenueSampleViewController : UIViewController<CLLocationManagerDelegate>
{
    NSTimer *sampleTimer;
    AVAudioRecorder *recorder;
    NSMutableArray *soundValues;
    
}

@property(nonatomic,strong) NSDictionary *venueDictionary;



-(void)stopMetering;
-(void)timerCallback:(NSTimer *)timer;
-(IBAction)forceStopMetering:(id)sender;
-(CLRegion*)regionForSample;
@end
