//
//  BDAPAudioPlayerController.m
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

#import "BDAPAudioPlayerController.h"



NSString * const BDAPAudioPlayerCurrentTrackURLKey=@"BDAPAudioPlayerCurrentTrackURLKey";
NSString * const BDAPAudioPlayerCurrentTrackCurrentTimeKey=@"BDAPAudioPlayerCurrentTrackCurrentTimeKey";
NSString * const BDAPAudioPlayerCurrentTrackDeviceCurrentTimeKey=@"BDAPAudioPlayerCurrentTrackDeviceCurrentTimeKey";

@interface BDAPAudioPlayerController ()
@property (nonatomic,strong) NSMutableArray *musicItems;
@property (nonatomic,strong) NSArray *musicURLs;
@property (nonatomic) NSInteger currentTrackNumber;

@end

@implementation BDAPAudioPlayerController
@synthesize audioPlayer = _audioPlayer;
@synthesize musicItems = _musicItems;
@synthesize musicURLs = _musicURLs;
@synthesize currentTrackNumber =_currentTrackNumber;

-(id)initWithURL:(NSURL *)url{
    return [self initWithURLs:[NSArray arrayWithObject:url]];
}

-(id)initWithURLs:(NSArray *)urls{
    self=[super init];
    if (self) {
        _musicURLs=urls;
        _currentTrackNumber=0;
    }
    return self;
}

-(AVAudioPlayer *)audioPlayer{
    if (_audioPlayer) {
        return _audioPlayer;
    }
    NSLog(@"audioPlayer creating");
    NSError *error;
    _audioPlayer=[[BDAPAudioPlayer alloc] initWithContentsOfURL:[_musicURLs objectAtIndex:self.currentTrackNumber] error:&error] ;
    if (error) {
        NSLog(@"    error lazily creating audioPlayer,  error:  %@",error);
        return nil;
    }
    [_audioPlayer setDelegate:self];
    [_audioPlayer prepareToPlay];
    NSInteger numberOfLoops=0;
    if ([_musicURLs count]==1) {
        numberOfLoops=-1;
        
    }
    [_audioPlayer setNumberOfLoops:numberOfLoops];
    return _audioPlayer;
}

-(void)stop{
    [self.audioPlayer stop];
    self.audioPlayer=nil;
}

-(void)pause{
    [self.audioPlayer pause];
}

-(void)play{
    [self.audioPlayer play];
}

-(void)playNextTrack{
    self.currentTrackNumber=self.currentTrackNumber+1;
    
    if (self.currentTrackNumber==[self.musicURLs count]) {
        self.currentTrackNumber=0;
    }
    self.audioPlayer=nil;
    NSError *error;
    _audioPlayer=[[BDAPAudioPlayer alloc] initWithContentsOfURL:[self.musicURLs objectAtIndex:self.currentTrackNumber] error:&error ] ;
    [_audioPlayer setDelegate:self];
    [_audioPlayer setNumberOfLoops:0];
    
    if (error) {
        
    }
    [_audioPlayer play];
    
}

-(void)playPreviousTrack{
    // Get the current time
    NSTimeInterval currentTime=self.audioPlayer.currentTime;
    
    // is it less than two seconds?
    if (currentTime>2.0f) {
        self.audioPlayer.currentTime=0.0;
    }else{
        // stop the current player
        [self.audioPlayer stop];
        
        // nil it out
        self.audioPlayer=nil;
        
        // Get the previous track number
        self.currentTrackNumber=self.currentTrackNumber-1;
        if (self.currentTrackNumber<0) {
            self.currentTrackNumber=[self.musicURLs count]-1;
        }
        
        NSError *error;
        _audioPlayer=[[BDAPAudioPlayer alloc] initWithContentsOfURL:[self.musicURLs objectAtIndex:self.currentTrackNumber] error:&error ] ;
        [_audioPlayer setDelegate:self];
        [_audioPlayer setNumberOfLoops:0];
        
        if (error) {
            NSLog(@"Error in play previous track:  %@", error);
        }
        [_audioPlayer play];
    }
    
}


- (void) stopWithFadeDuration:(NSTimeInterval)duration{
    [self.audioPlayer stopWithFadeDuration:duration];
}
- (void) playWithFadeDuration:(NSTimeInterval)duration{
    [self.audioPlayer playWithFadeDuration:duration];
    
}

-(NSDictionary *)currentTrackDict{
    NSArray *currentTrackObjects=[NSArray arrayWithObjects:[(NSURL *)[self.musicURLs objectAtIndex:self.currentTrackNumber] path],[NSNumber numberWithDouble:self.audioPlayer.currentTime],nil];
    NSArray *currentTrackKeys=[NSArray arrayWithObjects:BDAPAudioPlayerCurrentTrackURLKey,BDAPAudioPlayerCurrentTrackCurrentTimeKey, nil];
    
    return [NSDictionary dictionaryWithObjects:currentTrackObjects forKeys:currentTrackKeys];
}

-(void)resumePlayWithTrackDict:(NSDictionary *)trackDict{
    
    if (_audioPlayer) {
        // Stop the player 
      
        [self.audioPlayer stop];
        // Nil it out.
        self.audioPlayer=nil;

    }
    
    [self setTrackDictInfo:trackDict];
    
    // And away we go.
    [self.audioPlayer play];
    
    
}



-(void)setTrackDictInfo:(NSDictionary *)dict{
    // Extract url of the track
    NSString *currentPath=[dict objectForKey:BDAPAudioPlayerCurrentTrackURLKey];
    
    
    // Find which index in the array of musicURLs is corresponds to.
    NSInteger currentTrackNumber=[self.musicURLs indexOfObjectPassingTest:^BOOL(NSURL *url, NSUInteger idx, BOOL *stop) {
        if ([[url path] isEqualToString:currentPath]) {
            *stop=YES;
            return YES;
        }
        return NO;
    }];
    
    // Make sure we don't have an issue.  If so, then we just default to the first track in the array.
    if (currentTrackNumber==NSNotFound) {
        currentTrackNumber=0;
    }
    
    // Set the currentTrackNumber
    self.currentTrackNumber=currentTrackNumber;
    
    
    // Get the time where we left off.
    
    NSTimeInterval currentTime=0.0;
    
    // Extract the time from the dict.
    NSNumber *currentTimeNumber=[dict objectForKey:BDAPAudioPlayerCurrentTrackCurrentTimeKey];
    if (!currentTimeNumber) {
        [dict objectForKey:BDAPAudioPlayerCurrentTrackDeviceCurrentTimeKey];
    }
    
    // Be definsive
    
    if (currentTimeNumber) {
        currentTime=[currentTimeNumber doubleValue];
    }
    // Lazily create a new one and set the currentTime.
    self.audioPlayer.currentTime=currentTime;
}

- (void) playWithFromTrackDict:(NSDictionary *)trackDict withFadeDuration:(NSTimeInterval)fadeDuration{
    if (trackDict) {
        [self setTrackDictInfo:trackDict];
    }
    
    [self playWithFadeDuration:fadeDuration];
}

#pragma mark -
#pragma mark AVAudioPlayer Delegate
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{

    if (flag && [self.musicURLs count]>1) {
        [self playNextTrack];
    }
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags{
    if (flags & AVAudioSessionInterruptionFlags_ShouldResume) {
        if (_audioPlayer) {
            [self.audioPlayer play];
        }
    }
    
}

@end