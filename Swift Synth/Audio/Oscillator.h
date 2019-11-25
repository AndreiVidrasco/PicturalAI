//
//  Oscillator.h
//  Swift Synth
//
//  Created by Andrei Vidrasco on 25.11.19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef float (^Signal)(float);

typedef NS_ENUM(NSInteger, Waveform) {
    sine, triangle, sawtooth, square, whiteNoise,
};

NS_ASSUME_NONNULL_BEGIN

@interface Oscillator : NSObject

@property (class) float amplitude;
@property (class) float frequency;

@property (class, readonly) Signal sine;
@property (class, readonly) Signal triangle;
@property (class, readonly) Signal sawtooth;
@property (class, readonly) Signal square;
@property (class, readonly) Signal whiteNoise;


@end

NS_ASSUME_NONNULL_END
