//
//  VenueSampleViewController.m
//  HearClear
//
//  Created by Dan Nolan on 4/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import "VenueSampleViewController.h"
#import "HCNetwork.h"
#import "VenueAnnotation.h"

@interface VenueSampleViewController ()

    @property(nonatomic,strong) IBOutlet UILabel *venueLabel;
    //@property(nonatomic,strong) IBOutlet UILabel *currentRating;
    @property(nonatomic, strong) IBOutlet UIButton *stopSampling;
    @property(nonatomic, strong) IBOutlet UIImageView *sampleView;
    @property(nonatomic,strong) IBOutlet UILabel *venueDistanceLabel;
    @property(nonatomic, strong) VenueCheckin *checkin;
    @property(nonatomic, strong) IBOutlet MKMapView *sampleMapView;
    @property(nonatomic, strong) CLLocationManager *sampleLocationManager;
    @property(nonatomic,strong) IBOutlet UIButton *silentButton;
    @property(nonatomic,strong) IBOutlet UIButton *softButton;
    @property(nonatomic,strong) IBOutlet UIButton *averageButton;
    @property(nonatomic,strong) IBOutlet UIButton *loudButton;
    @property(nonatomic,strong) NSNumber *userEstimate;
@end

@implementation VenueSampleViewController

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
    NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.caf"]];
    soundValues = [[NSMutableArray alloc] init];
    
    
    UIImage *backgroundNormal = [[UIImage imageNamed:@"sound_type_button.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    UIImage *backgroundHighlighted = [[UIImage imageNamed:@"sound_type_button_highlighted.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    
    [self.softButton setBackgroundImage:backgroundNormal forState:UIControlStateNormal];
    [self.softButton setBackgroundImage:backgroundHighlighted forState:UIControlStateHighlighted];
    
    [self.silentButton setBackgroundImage:backgroundNormal forState:UIControlStateNormal];
    [self.silentButton setBackgroundImage:backgroundHighlighted forState:UIControlStateHighlighted];
    
    [self.averageButton setBackgroundImage:backgroundNormal forState:UIControlStateNormal];
    [self.averageButton setBackgroundImage:backgroundHighlighted forState:UIControlStateHighlighted];
    
    [self.loudButton setBackgroundImage:backgroundNormal forState:UIControlStateNormal];
    [self.loudButton setBackgroundImage:backgroundHighlighted forState:UIControlStateHighlighted];
    
    NSLog(@"Dictionary provided: %@", [self.venueDictionary description]);
    self.sampleLocationManager = [[CLLocationManager alloc]init];
    self.sampleLocationManager.delegate = self;
    self.sampleLocationManager.distanceFilter = kCLDistanceFilterNone;
    self.sampleLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    [self.sampleLocationManager startUpdatingLocation];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [[self.venueDictionary objectForKey:@"latitude"] floatValue];
    zoomLocation.longitude= [[self.venueDictionary objectForKey:@"longitude"]floatValue];
    NSString *distanceString = @"";
    VenueAnnotation *va = [[VenueAnnotation alloc] initWithCoordinate:zoomLocation andTitle:[self.venueDictionary objectForKey:@"name"] andSubtitle:distanceString];
    
    [self.sampleMapView addAnnotation:va];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 200, 200);
    // 3
    MKCoordinateRegion adjustedRegion = [self.sampleMapView regionThatFits:viewRegion];
    
    [self.sampleMapView setRegion:adjustedRegion animated:YES];
    
    //Settings to make sure AVAudiorecorder sampling is working correctly
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:kAudioFormatAppleIMA4],AVFormatIDKey,
                              [NSNumber numberWithInt:44100],AVSampleRateKey,
                              [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                              [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                              [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                              [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                              nil];
    NSError *error = nil;
    
    self.venueLabel.text = [self.venueDictionary objectForKey:@"name"];
    self.checkin = [[VenueCheckin alloc] initWithName:[self.venueDictionary objectForKey:@"name"] andVenueID:[self.venueDictionary objectForKey:@"id"] andLatitude:[self.venueDictionary objectForKey:@"latitude"] andLongitude:[self.venueDictionary objectForKey:@"longitude"]];
    
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if(!recorder){
        NSLog(@"Error from AV recorder: %@",[error localizedDescription]);
    }
    [recorder prepareToRecord];
    recorder.meteringEnabled = YES;
    [recorder record];
    
    [self.sampleView setAnimationDuration:1.5];
    [self.sampleView setAnimationImages:@[ [UIImage imageNamed:@"Sound-0.png"], [UIImage imageNamed:@"Sound-1.png"], [UIImage imageNamed:@"Sound-2.png"], [UIImage imageNamed:@"Sound-3.png"] ]];
    [self.sampleView startAnimating];
    
    
    //Sample every 10 seconds for more accurate data
    sampleTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timerCallback:) userInfo:nil repeats:YES];
}

-(IBAction)forceStopMetering:(id)sender{

    [self stopMetering];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]
                                initWithAnnotation:annotation
                                reuseIdentifier:nil];
    
    pin.canShowCallout = YES;
    pin.animatesDrop = YES;
    
    return pin;
}


-(void)stopMetering{
    [self.sampleLocationManager stopUpdatingLocation];
    [sampleTimer invalidate];
    [recorder stop];
    [self.sampleView stopAnimating];
    
    
    [HCNetwork postCheckinInformation:self.checkin withDetails:nil];
    NSString *fileLocation = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.caf"];
    
    if([[NSFileManager defaultManager]fileExistsAtPath:fileLocation]){
        NSError *error = nil;
        [[NSFileManager defaultManager]removeItemAtPath:fileLocation error:&error];
    }
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}
-(void)timerCallback:(NSTimer *)timer
{
    //Have it update to the latest voltage level
    [recorder updateMeters];
    
    //Pull out the log for the average power of the channel
    double averagePower = [recorder averagePowerForChannel:0];
    double peakPower = [recorder peakPowerForChannel:0];
    
    
    double peakPercentage = pow (10, (0.05 * peakPower));
    double percentage = pow (10, (0.05 * averagePower));
    
    
    
    [self.checkin addSampleWithAvg:percentage andMax:peakPercentage];
    //NSLog(@"Added sample");
    
    
    //After 5 minutes stop sampling
    if([self.checkin.venueSamples count] >= 30){
        [self stopMetering];
    }
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark CLLocationManager methods


-(CLRegion *)regionForSample
{
    NSString *lat = [self.venueDictionary objectForKey:@"latitude"];
    NSString *lon = [self.venueDictionary objectForKey:@"longitude"];
    float latD = [lat floatValue];
    float lonD = [lon floatValue];
    
    //NSLog(@"With current information using doubles: %f, %f", latD, lonD);
    //NSNumber *latitute = [NSNumber numberWithDouble:[self.venueDictionary objectForKey:@"latitude"]]
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(latD, lonD);
    int curDistance = [[self.venueDictionary objectForKey:@"distance"] intValue];
    int radius = 100 + curDistance;
    CLRegion *region = [[CLRegion alloc]initCircularRegionWithCenter:coords radius:radius identifier:@"CheckinLocation"];
    
    return region;
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if([[region identifier] isEqualToString:@"CheckinLocation"])
    {
        [manager stopMonitoringForRegion:region];
        //Removes the region monitoring
        [self stopMetering];
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSString *lat = [self.venueDictionary objectForKey:@"latitude"];
    NSString *lon = [self.venueDictionary objectForKey:@"longitude"];
    float latD = [lat floatValue];
    float lonD = [lon floatValue];
    
    CLLocation *location = [[CLLocation alloc]initWithLatitude:latD longitude:lonD];
    //CLLocationCoordinate2D vCoords = CLLocationCoordinate2DMake(latD, lonD);
    
    
    CLLocationDistance meters = [newLocation distanceFromLocation:location]; 
    
    NSString *distanceString = [NSString stringWithFormat:@"%0.f metres away",meters];
    
    self.venueDistanceLabel.text = distanceString;
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    
}


-(void)highlightButton:(UIButton *)b
{
    [b setHighlighted:YES];
}

-(void)disableHighlight:(UIButton *)b
{
    [b setHighlighted:NO];
}

#pragma mark user button handling issues

-(IBAction)silentButtonPressed:(id)sender{

    
    self.userEstimate = [NSNumber numberWithDouble:0.1];
    [self performSelector:@selector(disableHighlight:) withObject:self.softButton afterDelay:0.0];
    [self performSelector:@selector(disableHighlight:) withObject:self.averageButton afterDelay:0.0];
    [self performSelector:@selector(disableHighlight:) withObject:self.loudButton afterDelay:0.0];
    [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];


}

-(IBAction)softButtonPressed:(id)sender{

    
    
    self.userEstimate = [NSNumber numberWithDouble:0.4];
    [self performSelector:@selector(disableHighlight:) withObject:self.silentButton afterDelay:0.0];
    [self performSelector:@selector(disableHighlight:) withObject:self.averageButton afterDelay:0.0];
    [self performSelector:@selector(disableHighlight:) withObject:self.loudButton afterDelay:0.0];
    [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];

}

-(IBAction)averageButtonPressed:(id)sender{

    
    self.userEstimate = [NSNumber numberWithDouble:0.6];
    [self performSelector:@selector(disableHighlight:) withObject:self.softButton afterDelay:0.0];
    [self performSelector:@selector(disableHighlight:) withObject:self.silentButton afterDelay:0.0];
    [self performSelector:@selector(disableHighlight:) withObject:self.loudButton afterDelay:0.0];
    [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];


}

-(IBAction)loudButtonPressed:(id)sender{

    
    self.userEstimate = [NSNumber numberWithDouble:0.8];
    [self performSelector:@selector(disableHighlight:) withObject:self.softButton afterDelay:0.0];
    [self performSelector:@selector(disableHighlight:) withObject:self.averageButton afterDelay:0.0];
    [self performSelector:@selector(disableHighlight:) withObject:self.silentButton afterDelay:0.0];
    [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];


}




@end
