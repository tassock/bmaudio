# BMAudio

## Overview

BMAudio provides an Objective C wrapper for Core Audio. It allows you to easily set up and modify an entire audio graph without having to write a line of C. The API is designed to work identically on both iOS and OSX.

## Usage

BMAudioUnit is an abstract class that represents both the AudioUnit and AudioNode of a component in an AUGraph. BMAudioUnit subclasses BMSamplerUnit and BMReverbUnit are loaded into a BMTrack in the order you would like the signal to pass through:
	
	// chain is samplerUnit -> reverbUnit
	BMSamplerUnit *samplerUnit = [BMSamplerUnit unit];
    BMReverbUnit *reverbUnit = [BMReverbUnit unit];
    BMAudioTrack *tromboneTrack = [BMAudioTrack trackWithUnits:@[samplerUnit, reverbUnit]]; 

The BMAudio class controls the AUGraph of all your audio units. You can load a BMTrack into BMAudio, the last BMAudioUnit of the track is connected to an input in BMAudio's multi-channel mixer.
	
	// chain is samplerUnit -> reverbUnit -> mixerUnit -> output
	[[BMAudio sharedInstance] loadAudioTrack:tromboneTrack];
	
Once all tracks are loaded, you can initialize BMAudio's graph and loat a aupreset file into the sampler.

    [[BMAudio sharedInstance] setUpAudioGraph];
    [samplerUnit loadPreset:@"Trombone"];
    
To control the sampler, set up BMMidiManager intance and set its instrument delegate to the sampler unit.

    [[BMMidiManager sharedInstance] setUp];
    [BMMidiManager sharedInstance].instrumentDelegate = samplerUnit;

If you have a MIDI keyboard plugged into your mac, you can now Jam out to some rocking trombone riffs. 

## Status
Very much a work in progress. Very open to advice on how to make this awesome. I know I'm not the first one to attempt to wrap Core Audio in Objective C. Advice on any pitfalls is especially welcome. 

## License
Do whatever you want with this. 