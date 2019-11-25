//
//  Oscillator.m
//  Swift Synth
//
//  Created by Andrei Vidrasco on 25.11.19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

#import "Oscillator.h"

@implementation Oscillator

static float _amplitude = 1;
static float _frequency = 440;

+ (float)amplitude {
    return _amplitude;
}

+ (void)setAmplitude:(float)amplitude {
    _amplitude = amplitude;
}

+ (float)frequency {
    return _frequency;
}

+ (void)setFrequency:(float)frequency {
    _frequency = frequency;
}

@end
