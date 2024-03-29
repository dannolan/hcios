//
//  VenueDetailControllerViewController.m
//  HearClear
//
//  Created by Dan Nolan on 3/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import "VenueDetailControllerViewController.h"
#import "VenueAnnotation.h"
#import "HCNetwork.h"
#import "VenueLoudnessViewController.h"

@interface VenueDetailControllerViewController ()

@property (strong,nonatomic) IBOutlet UILabel *venueName;
@property (strong, nonatomic) IBOutlet UILabel *venueDistance;
@property(strong, nonatomic) IBOutlet MKMapView *venueMap;
@property(strong, nonatomic) IBOutlet UIButton *infoButton;
@property(strong,nonatomic) NSDictionary *venueLoudness;

@end

@implementation VenueDetailControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"Logging the dict yo: %@", [self.venueDictionary description]);
    
    //self.navigationController.navigationBar.
    
    [self.infoButton setHidden:YES];
    [HCNetwork venueExists:self.venueDictionary];
    HCNetwork *network = [[HCNetwork alloc] init];
    network.delegate = self;
    [network venueVolumeInfoForVenue:self.venueDictionary];
    
    NSString *name = [self.venueDictionary objectForKey:@"name"];
    self.venueName.text = name;
//    NSString *lon = [self.venueDictionary objectForKey:@"longitude"];
//    NSString *lat = [self.venueDictionary objectForKey:@"latitude"];
    NSString *dist = [NSString stringWithFormat:@"%@m", [self.venueDictionary objectForKey:@"distance"]];
    self.venueDistance.text = dist;
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [[self.venueDictionary objectForKey:@"latitude"] floatValue];
    zoomLocation.longitude= [[self.venueDictionary objectForKey:@"longitude"]floatValue];
    
    
    NSString *distanceString = [NSString stringWithFormat:@"%@ metres away", [self.venueDictionary objectForKey:@"distance"]];
    VenueAnnotation *va = [[VenueAnnotation alloc] initWithCoordinate:zoomLocation andTitle:[self.venueDictionary objectForKey:@"name"] andSubtitle:distanceString];
    
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 200, 200);
    // 3
    MKCoordinateRegion adjustedRegion = [self.venueMap regionThatFits:viewRegion];
    
    [self.venueMap setRegion:adjustedRegion animated:YES];
    
    [self.venueMap addAnnotation:va];
    
    
    //load loudness information into a dict
    
    //NSLog(@"Annotation info: %@", [va description]);
    //[self.venueMap a]
    //[self.venueMap di]
    //[self.venueMap ]
//    self.venueName.text = name;
//    self.venueLat.text = lat;
//    self.venueLon.text = lon;
    //self.venueDistance.text = dist;
//    self.venueName.text = [self.venueDictionary objectForKey:@"name"];
//    self.venueLat.text = [self.venueDictionary objectForKey:@"latitude"];
//    self.venueLon.text = [self.venueDictionary objectForKey:@"longitude"];
//    self.venueDistance.text = [NSString stringWithFormat:@"%d",[self.venueDictionary objectForKey:@"distance"]];
    
    FSNetwork *fsq = [[FSNetwork alloc] init];
    fsq.delegate = self;
    [fsq informationForVenue:[self.venueDictionary objectForKey:@"id"]];
//    
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

-(void)fsResult:(QueryResult)result forQueryType:(QueryType)type withObject:(id)object
{
   
    if(type == VenueInfo){
        if(result == QuerySuccess){
            //Dictionary object
            //TODO: Venue more information
            NSLog(@"Returned: %@", [object description]);
        }
    }
}

-(IBAction)performCheckin:(id)sender{
    
    //TODO: Get the root controller, nav to it and then perform segue with the dictionary
    NSArray *vcs = self.navigationController.viewControllers;
    
    //NSLog(@"Parent controller: %@",[self.navigationController.parentViewController description]);
    [self.navigationController popToRootViewControllerAnimated:YES];
    MainViewController *viewC = [vcs objectAtIndex:0];
    //NSLog(@"ViewC is info: %@", [viewC description]);
    //TODO: Put up a 'LOADING' section
    //[viewC per]
    [viewC performSegueWithIdentifier:@"sampleViewSegue" sender:self.venueDictionary];
    
}


-(void)hcResult:(PostResult)result forPostType:(PostType)type withObject:(id)object
{
     NSLog(@"Reult is back");
    if(result == PostFailure)
    {
        NSLog(@"Result no info");
        //handle failure here
    }else{
        if(type == VenueLoudness)
        {
            NSLog(@"Result is %@", [object description]);
            //this is what I want I have a dict here
            self.venueLoudness = [object objectForKey:@"volinfo"];
            [self.infoButton setHidden:NO];
            
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"VenueLoudnessViewSegue"]) {
        VenueLoudnessViewController *loudView = [segue destinationViewController];
        loudView.venueLoudnessDictionary = self.venueLoudness;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *backgroundNormal = [[UIImage imageNamed:@"sound_type_button.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    UIImage *backgroundHighlighted = [[UIImage imageNamed:@"sound_type_button_highlighted.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    
    [self.infoButton setBackgroundImage:backgroundNormal forState:UIControlStateNormal];
    [self.infoButton setBackgroundImage:backgroundHighlighted forState:UIControlStateHighlighted];
    
	// Do any additional setup after loading the view.
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

@end
