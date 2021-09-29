//
//  AudioProcessor.h
//  BaseLine
//
//  Created by Naresh Babu Kommana on 2/24/19.
//  Copyright © 2019 OnMobile Global Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class AVAudioMix;
@class AVAssetTrack;
@class AVPlayerItem;

@protocol AudioProcessorDelegate;

@interface AudioProcessor : NSObject

// Designated initializer.
- (id)initWithAudioAssetTrack:(AVAssetTrack *)audioAssetTrack;
- (id) initWithAVPlayerItem: (AVPlayerItem *)playerItem;

// Properties
@property (readonly, nonatomic) AVAssetTrack *audioAssetTrack;
@property (readonly, nonatomic) AVAudioMix *audioMix;
@property (weak, nonatomic) id <AudioProcessorDelegate> delegate;

@property BOOL compressorEnabled;

@end

#pragma mark - Protocols

@protocol AudioProcessorDelegate <NSObject>

// Add comment…
- (void)audioTabProcessor:(AudioProcessor *)audioTabProcessor hasNewLeftChannelValue:(float)leftChannelValue rightChannelValue:(float)rightChannelValue;

@end
