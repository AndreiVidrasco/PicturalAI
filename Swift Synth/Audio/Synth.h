//
//  Synth.h
//  Swift Synth
//
//  Created by Andrei Vidrasco on 25.11.19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Oscillator.h"

NS_ASSUME_NONNULL_BEGIN

@interface Synth : NSObject

@property (class, readonly) Synth *shared;

- (void)setWaveformTo:(Signal)signal;
@property (nonatomic) float volume;

@end

NS_ASSUME_NONNULL_END
