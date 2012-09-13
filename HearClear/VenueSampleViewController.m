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
    
    NSLog(@"Dictionary provided: %@", [self.venueDictionary description]);
    self.sampleLocationManager = [[CLLocationManager alloc]init];
    self.sampleLocationManager.delegate = self;
    self.sampleLocationManager.distanceFilter = kCLDistanceFilterNone;
    self.sampleLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    [self.sampleLocationManager startUpdatingLocation];
    //TODO: Monitoring for region
    
    NSString *dist = [NSString stringWithFormat:@"%@m", [self.venueDictionary objectForKey:@"distance"]];
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
    
    //[self regionForSample];
    //Settings to make sure AVAudiorecorder sampling is working correctly
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:kAudioFormatAppleIMA4],AVFormatIDKey,
                              [NSNumber numberWithInt:44100],AVSampleRateKey,
                              [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                              [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                              [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                              [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                              nil];
    NSError *error;
    
    NSLog(@"Venue Info:%@", [self.venueDictionary description]);
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
    
    sampleTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCallback:) userInfo:nil repeats:YES];
	// Do any additional setup after loading the view.
}

-(IBAction)forceStopMetering:(id)sender{

    //TODO: Location updating etc
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
    //TODO: Managing the current sample element
    
    
    [HCNetwork postCheckinInformation:self.checkin withDetails:nil];
    NSString *fileLocation = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.caf"];
    //NSURL *url = [NSString fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.caf"]];
    
    if([[NSFileManager defaultManager]fileExistsAtPath:fileLocation]){
        //NSLog(@"Nuking audio");
        NSError *error = nil;
        [[NSFileManager defaultManager]removeItemAtPath:fileLocation error:&error];
    }
    //NSError *erro
    
    //[NSFileManager r]
    //NSData *data = [self.checkin JSONRepresentation];
    //NSLog(@"Checkin info is: %@", [[self.checkin asDictionary]description]);
    //TODO: Submission of data using backgrounding APIs
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}
-(void)timerCallback:(NSTimer *)timer
{
    [recorder updateMeters];
    double averagePower = [recorder averagePowerForChannel:0];
    double peakPower = [recorder peakPowerForChannel:0];
    
    
    
    double peakPercentage = pow (10, (0.05 * peakPower));
    double percentage = pow (10, (0.05 * averagePower));
    
    
    
    [self.checkin addSampleWithAvg:percentage andMax:peakPercentage];
    //TODO: Figure out how to use the peak value to validate the current power level
    //TODO: Mock up FourSquare integration
    //TODO: Mock up how to store the values in memory
    NSLog(@"Added sample");
    //NSLog(@"Percentage linear output: %f peak power output: %f", percentage, peakPercentage);
    //VolumeSample *vs = [[VolumeSample alloc] initWithMaxValue:peakPercentage andAverageReading:percentage];
    //[soundValues addObject:vs];
    //double currentValue = percentage * 80;
    //currentValue += 40;
    //NSLog(@"current value is: %f.5", currentValue);
    //NSString *dbString = [NSString stringWithFormat:@"%.2f dB", currentValue];
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
    
    NSLog(@"With current information using doubles: %f, %f", latD, lonD);
    //NSNumber *latitute = [NSNumber numberWithDouble:[self.venueDictionary objectForKey:@"latitude"]]
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(latD, lonD);
    
    CLRegion *region = [[CLRegion alloc]initCircularRegionWithCenter:coords radius:100 identifier:@"CheckinLocation"];
    
    return region;
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if([[region identifier] isEqualToString:@"CheckinLocation"])
    {
        [manager stopMonitoringForRegion:region];
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

@end
