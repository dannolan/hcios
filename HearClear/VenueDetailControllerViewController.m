//
//  VenueDetailControllerViewController.m
//  HearClear
//
//  Created by Dan Nolan on 3/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import "VenueDetailControllerViewController.h"

@interface VenueDetailControllerViewController ()

@property (weak,nonatomic) IBOutlet UILabel *venueName;
@property (weak, nonatomic) IBOutlet UILabel *venueDistance;

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
    
    NSString *name = [self.venueDictionary objectForKey:@"name"];
    self.venueName.text = name;
//    NSString *lon = [self.venueDictionary objectForKey:@"longitude"];
//    NSString *lat = [self.venueDictionary objectForKey:@"latitude"];
    NSString *dist = [NSString stringWithFormat:@"%@m", [self.venueDictionary objectForKey:@"distance"]];
    self.venueDistance.text = dist;
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


-(void)fsResult:(QueryResult)result forQueryType:(QueryType)type withObject:(id)object
{
    if(type == VenueInfo){
        if(result == QuerySuccess){
            //Dictionary object
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
    NSLog(@"ViewC is info: %@", [viewC description]);
    
    [viewC performSegueWithIdentifier:@"sampleViewSegue" sender:self.venueDictionary];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
