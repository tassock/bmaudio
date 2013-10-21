//
//  BMViewController.m
//  BMAudioIOS
//
//  Created by Peter Marks on 10/19/13.
//  Copyright (c) 2013 BeatMatch LLC. All rights reserved.
//

#import "BMViewController.h"
#import "BMAudio.h"
#import "BMAudioTrack.h"
#import "BMSamplerUnit.h"

@interface BMViewController ()
{
    BMSamplerUnit *tromboneSampler;
}
@end

@implementation BMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    tromboneSampler = [BMSamplerUnit unit];
    BMAudioTrack *tromboneTrack = [BMAudioTrack trackWithUnits:@[tromboneSampler]];
    [[BMAudio sharedInstance] loadAudioTrack:tromboneTrack];
    
    [[BMAudio sharedInstance] setUpIOSAudioSession];
    [[BMAudio sharedInstance] setUpAudioGraph];
    
    [tromboneSampler loadPreset:@"Trombone"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)noteOnAction:(id)sender
{
    [tromboneSampler noteOnWithNote:49 velocity:83];
}

- (IBAction)noteOffAction:(id)sender
{
    [tromboneSampler noteOffWithNote:49];
}

@end
