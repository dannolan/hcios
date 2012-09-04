//
//  VenuesViewController.m
//  HearClear
//
//  Created by Dan Nolan on 3/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import "VenuesViewController.h"

@interface VenuesViewController ()

@property (strong, nonatomic) NSArray *venueArray;
@end

@implementation VenuesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.venueArray = [[NSArray alloc] init];
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
    
    
    CLLocation *location = [locationManager location];
    
    NSLog(@"Current location is: %@", [location description]);

    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"Updated to location: %@", [newLocation description]);
    if([newLocation isKindOfClass:[NSNull class]]){
        
    }else{
        [locationManager stopUpdatingLocation];
        FSNetwork *fsq = [[FSNetwork alloc] init];
        fsq.delegate = self;
        [fsq venuesForLocation:newLocation];

    }
    
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"venueSelectSegue"]){
        VenueDetailControllerViewController *details = [segue destinationViewController];
        NSIndexPath * indexPath = (NSIndexPath*)sender;
        details.venueDictionary = [self.venueArray objectAtIndex:indexPath.row];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [locationManager stopUpdatingLocation];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //MAGIC NUMBER
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if([self.venueArray count] == 0)
        return 1;
    
    return [self.venueArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"VenueCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VenueCell"];
    
    // Configure the cell...
    if([self.venueArray count] == 0){
        cell.textLabel.text = @"Loading...";
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryNone;
        //cell.accessoryType = UITableView
    }else{
        NSDictionary *venueDict = [self.venueArray objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [venueDict objectForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m", [venueDict objectForKey:@"distance"]];
    }
    //cell.detailTextLabel.text = [[self.venueArray objectAtIndex:indexPath.row] objectForKey:@"distance"];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(void)fsResult:(QueryResult)result forQueryType:(QueryType)type withObject:(id)object
{
    if(type == VenueSearch){
        if(result == QuerySuccess){
            self.venueArray = object;
            [locationManager stopUpdatingLocation];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
            
        }else{
            
        }
    }
}



//-(void)FSQVenueReturnError:(int)errorType{
//    
//}
//-(void)FSQVenueReturnVenues:(NSArray *)venues{
//
//    self.venueArray = venues;
//    NSLog(@"Venue List: %@", [self.venueArray description]);
//    //Update table on main thread
//    [locationManager stopUpdatingLocation];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//
//    });
//}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"venueSelectSegue" sender:indexPath];
}

@end
