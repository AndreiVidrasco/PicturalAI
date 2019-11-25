//
//  Synth.m
//  Swift Synth
//
//  Created by Andrei Vidrasco on 25.11.19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

#import "Synth.h"
#import <AVFoundation/AVFoundation.h>

@interface Synth ()

@property (copy, nonatomic) Signal signal;
@property (strong, nonatomic) AVAudioEngine *audioEngine;
@property (nonatomic) double sampleRate;
@property (nonatomic) float deltaTime;
@property (nonatomic) float time;
@property (nonatomic) AVAudioSourceNode *sourceNode;

@end

@implementation Synth

+ (Synth *)shared {
    static dispatch_once_t pred = 0;
    static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _audioEngine = [[AVAudioEngine alloc] init];
        AVAudioMixerNode *mainMixer = _audioEngine.mainMixerNode;
        AVAudioOutputNode *outputNode = _audioEngine.outputNode;
        
        AVAudioFormat *format = [outputNode inputFormatForBus: 0];
        
        _sampleRate = format.sampleRate;
        _deltaTime = 1 / _sampleRate;
        
        _signal = [[Oscillator sine] copy];
        AVAudioFormat *inputFormat = [[AVAudioFormat alloc] initWithCommonFormat: format.commonFormat
                                                                      sampleRate: _sampleRate
                                                                        channels: 1
                                                                     interleaved: format.isInterleaved];
        [_audioEngine attachNode:self.sourceNode];
        [_audioEngine connect:self.sourceNode to:mainMixer format:inputFormat];
        [_audioEngine connect:mainMixer to:outputNode format: nil];
        mainMixer.outputVolume = 0;
        NSError *outputError = nil;
        
        [_audioEngine startAndReturnError: &outputError];
        if (outputError != nil) {
            NSLog(@"Could not start audioEngine: %@", outputError.localizedDescription);
        }
    }
    
    return self;
}

- (void)setVolume:(float)volume {
    self.audioEngine.mainMixerNode.outputVolume = volume;
}

- (float)volume {
    return self.audioEngine.mainMixerNode.outputVolume;
}

- (void)setWaveformTo:(Signal)signal {
    self.signal = [signal copy];
}

- (AVAudioSourceNode *)sourceNode {
    if (_sourceNode == nil) {
        _sourceNode = [[AVAudioSourceNode alloc] initWithRenderBlock:^OSStatus(BOOL * _Nonnull isSilence, const AudioTimeStamp * _Nonnull timestamp, AVAudioFrameCount frameCount, AudioBufferList * _Nonnull audioBufferList) {
            for (int frame = 0; frame < frameCount; frame++) {
                float sampleVal = self.signal(self.time);
                self.time += self.deltaTime;
                for (int buffer = 0; buffer < audioBufferList->mNumberBuffers; buffer++) {
                    float *buf = audioBufferList->mBuffers[buffer].mData;
                    buf[frame] = sampleVal;
                }
            }
            return noErr;
        }];
    }
    
    return _sourceNode;
}

@end
