//
//  BDAPAudioPlayer.m
//  testAudioPlayer
//
//  Created by Tim Taylor on 07/2012.
//  Copyright 2012 Big Diggy SW. All rights reserved.//

/*
 
 The below license is the new BSD license with the OSI recommended personalizations.
 <http://www.opensource.org/licenses/bsd-license.php>
 
 Copyright (C) 2011 Big Diggy SW. All Rights Reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are
 met:
 
 * Redistributions of source code must retain the above copyright notice,
 this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of Tim Taylor nor Big Diggy SW 
 may be used to endorse or promote products derived from this software
 without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY Big Diggy SW "AS IS" AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */ 

/* AVAudioPlayer fading code based on Peter Goodliffe's example located
 here:  http://goodliffe.blogspot.com/2011/04/ios-fading-avaudioplayer.html
 */

#import "BDAPAudioPlayer.h"

static const NSTimeInterval fadeInterval    = 0.05;
static const float          floatNearEnough = 0.1;

@interface BDAPAudioPlayer ()

@property (nonatomic) float fadeVolumeDelta;
@property (nonatomic,copy) AVAudioPlayerFadeCompleteBlock fadeCompletion;
@property (nonatomic) float playStopOriginalVolume;
@property (nonatomic) dispatch_queue_t defaultConcurrentQueue;

@end

@implementation BDAPAudioPlayer
@synthesize fading = fading_;
@synthesize fadeTargetVolume = fadeTargetVolume_;

// private
@synthesize fadeVolumeDelta;
@synthesize playStopOriginalVolume;
@synthesize fadeCompletion = _fadeCompletion;
@synthesize defaultConcurrentQueue = defaultConcurrentQueue_;


// Public methods
- (void) fadeToVolume:(float)targetVolume duration:(NSTimeInterval)duration{
    
    [self fadeToVolume:targetVolume duration:duration completion:nil];
    
}
- (void) fadeToVolume:(float)targetVolume duration:(NSTimeInterval)duration completion:(AVAudioPlayerFadeCompleteBlock)completion{
    
    if (duration <= 0 || fabs(targetVolume-self.volume) < floatNearEnough)
    {
        // Volume change is close enough, just go there immediately
        self.volume = targetVolume;
        return;
    }
    fading_            = YES;
    fadeTargetVolume_   = targetVolume;
    self.fadeVolumeDelta    = (targetVolume-self.volume)/(duration/fadeInterval);
    self.fadeCompletion     = completion;
    [self play];
    [self fadeFunction];
    
}

- (void) stopWithFadeDuration:(NSTimeInterval)duration{
    if (self.playing)
    {
        if (!self.fading)
            self.playStopOriginalVolume = self.volume;
        __block const float currentVolume = self.playStopOriginalVolume;
        [self fadeToVolume:0 duration:duration completion:^{
            [self stop];
            self.volume = currentVolume;
        }];
    }
    
}
- (void) playWithFadeDuration:(NSTimeInterval)duration{
    
    if (!self.fading)
        self.playStopOriginalVolume = self.volume;
    if (!self.playing)
        self.volume = 0;
   
    [self fadeToVolume:self.playStopOriginalVolume duration:duration];
    
}

// Private Methods

- (void) fadeFunction{
    if (!self.fading) return;
    
    const float target        = self.fadeTargetVolume;
    const float current       = self.volume;
    const float delta         = target-current;
    const float changePerStep = self.fadeVolumeDelta;
    
    if (fabs(delta) > fabs(changePerStep))
    {
        self.volume = current+changePerStep;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, fadeInterval * NSEC_PER_SEC);
       
        __weak __block BDAPAudioPlayer *weakSelf=self;
        dispatch_after(popTime, self.defaultConcurrentQueue, ^(void){
            [weakSelf fadeFunction];
        });
    }
    else
    {
        self.volume = target;
        fading_ = NO;
        AVAudioPlayerFadeCompleteBlock completion = self.fadeCompletion;
        if (completion){
            completion();
        }
        self.fadeCompletion = nil;
    }
}

-(dispatch_queue_t)defaultConcurrentQueue{
    if (defaultConcurrentQueue_) {
        return defaultConcurrentQueue_;
    }
    defaultConcurrentQueue_=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    
    return defaultConcurrentQueue_;
}

@end
