//
//  VenueSampleViewController.m
//  HearClear
//
//  Created by Dan Nolan on 4/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import "VenueSampleViewController.h"

@interface VenueSampleViewController ()

    @property(nonatomic,weak) IBOutlet UILabel *venueLabel;
    @property(nonatomic,weak) IBOutlet UILabel *currentRating;
    @property(nonatomic,weak) IBOutlet UIProgressView *currentLoudness;
    @property(nonatomic, weak) IBOutlet UIButton *stopSampling;


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
    
    self.venueLabel.text = [self.venueDictionary objectForKey:@"name"];
    
    
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if(!recorder){
        NSLog(@"Error from AV recorder: %@",[error localizedDescription]);
    }
    [recorder prepareToRecord];
    recorder.meteringEnabled = YES;
    [recorder record];
    sampleTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCallback:) userInfo:nil repeats:YES];
	// Do any additional setup after loading the view.
}

-(IBAction)forceStopMetering:(id)sender{
    [sampleTimer invalidate];
    [recorder stop];
    
    //TODO: Submission of data using backgrounding APIs
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
    //TODO: Location updating etc
    
    
    
    
}


-(void)stopMetering{
    
}
-(void)timerCallback:(NSTimer *)timer
{
    [recorder updateMeters];
    double averagePower = [recorder averagePowerForChannel:0];
    double peakPower = [recorder peakPowerForChannel:0];
    double peakPercentage = pow (10, (0.05 * peakPower));
    double percentage = pow (10, (0.05 * averagePower));
    
    //TODO: Figure out how to use the peak value to validate the current power level
    //TODO: Mock up FourSquare integration
    //TODO: Mock up how to store the values in memory
    NSLog(@"Percentage linear output: %f peak power output: %f", percentage, peakPercentage);
    //VolumeSample *vs = [[VolumeSample alloc] initWithMaxValue:peakPercentage andAverageReading:percentage];
    //[soundValues addObject:vs];
    double currentValue = percentage * 80;
    self.currentLoudness.progress = percentage;
    currentValue += 40;
    NSLog(@"current value is: %f.5", currentValue);
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

@end
