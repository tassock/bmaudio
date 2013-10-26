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
#import "BMMusicPlayer.h"

@interface BMViewController ()
{
    BMSamplerUnit *tromboneSampler;
    BMMusicPlayer *musicPlayer;
    NSTimer *updateTimer;
}
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *beatLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempoLabel;
@end

@implementation BMViewController

#pragma mark - view lifecycle

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
    
    musicPlayer = [[BMMusicPlayer alloc] initWithGraph:[BMAudio sharedInstance]->graph];
    musicPlayer.midiFileName = @"presto";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(updateUI:) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [updateTimer invalidate];
    updateTimer = nil;
}

#pragma mark - utility

- (void)updateUI:(NSTimer *)argTimer
{
    MusicTimeStamp timeStamp = [musicPlayer timeStamp];
    self.timeLabel.text = [NSString stringWithFormat:@"%f", timeStamp];
    self.beatLabel.text = [NSString stringWithFormat:@"%u.%u.%u", (int)[musicPlayer beatPosition].bar, [musicPlayer beatPosition].beat, [musicPlayer beatPosition].subbeat];
}

#pragma mark - actions

- (IBAction)noteOnAction:(id)sender
{
    [tromboneSampler noteOnWithNote:49 velocity:83];
}

- (IBAction)noteOffAction:(id)sender
{
    [tromboneSampler noteOffWithNote:49];
}

- (IBAction)playAction:(id)sender
{
    [musicPlayer play];
}

- (IBAction)pauseAction:(id)sender
{
    [musicPlayer pause];
}

- (IBAction)resetAction:(id)sender
{
    [musicPlayer reset];
}

@end
