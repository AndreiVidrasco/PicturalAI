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

+ (Signal)sine {
    return ^float(float time) {
        return self.amplitude * sin(2.0 * M_PI * self.frequency * time);
    };
}

+ (Signal)triangle {
    return ^float(float time) {
        double period = 1.0 / self.frequency;
        double timeInDouble = time;
        float currentTime = fmod(timeInDouble, period);

        double value = currentTime / period;
        
        double result = 0.0;
        
        if (value < 0.25) {
            result = value * 4;
        } else if (value < 0.75) {
            result = 2.0 - (value * 4.0);
        } else {
            result = value * 4 - 4.0;
        }
        
        return self.amplitude * result;
    };
}

+ (Signal)sawtooth {
    return ^float(float time) {
        double period = 1.0 / self.frequency;
        double timeInDouble = time;
        float currentTime = fmod(timeInDouble, period);

        return self.amplitude * ((currentTime / period) * 2 - 1.0);
    };
}

+ (Signal)square {
    return ^float(float time) {
        double period = 1.0 / self.frequency;
        double timeInDouble = time;
        float currentTime = fmod(timeInDouble, period);

        return ((currentTime / period) < 0.5) ? self.amplitude : -1.0 * self.amplitude;
    };
}

+ (Signal)whiteNoise {
    return ^float(float time) {
        return self.amplitude * [self randomFloatBetween:-1 and:1];
    };
}

+ (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    //https://stackoverflow.com/a/4579457
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

@end
