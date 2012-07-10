//
//  BDAPAudioPlayerController.h
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

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "BDAPAudioPlayer.h"
/** A class that provides queue capabilities for AVAudioPlayer.
 
 This class provides queue like functionality to BDAPAVAudioPlayer.  In addition to the queue functionality, the BDAPAudioPlayerController implements the AVAudioPlayerDelegate protocol.
 */
@interface BDAPAudioPlayerController : NSObject <AVAudioPlayerDelegate>

/** An instance of BDAPAudioPlayer.  BDAPAudioPlayer provides fading functionality to AVAudioPlayer.
 
 */
@property (nonatomic,strong) BDAPAudioPlayer *audioPlayer;

/** Initializes a BDAPAudioPlayerController with a music URL.  Will return nil if unsuccessful.
 
 The method takes a single NSURL as a parameter. It will put the NSURL into an instance of an NSArray and calls initWithURLs:.
 
 @param url A url to an audio file.
 @return An initialized BDAPAudioPlayerController or nil if unsuccessful.
 
 */
-(id)initWithURL:(NSURL *)url;

/** Initializes a BDAPAudioPlayerController with a music URL.  Will return nil if unsuccessful.
 
 The method takes initializes the BDAPAudioPlayerController with an array of music URLs.
 
 @param urls An array of urls pointing to music files.
 @return An initialized BDAPAudioPlayerController or nil if unsuccessful.
 
 */
-(id)initWithURLs:(NSArray *)urls;

/** Pauses the audio currently playing on the instance of BDAPAudioPlayer.
 
 */
-(void)pause;

/** Stops the audio currently playing on the instance of BDAPAudioPlayer.
 
 */
-(void)stop;

/** Begins playing the audio on the instance of BDAPAudioPlayer.
 
 */
-(void)play;

/** Plays the next track.
 
 Plays the next track in the queue.  If the current track is the last one, play the first one in the list.
 
 */
-(void)playNextTrack;

/** Plays the previous track
 
 If within 2 seconds of the beginning of the track, goes to the previous track. Otherwise it will go to the beginning of the track.  
 
 */
-(void)playPreviousTrack;

/** Pass through method for the instance of BDAPAudioPlayer that will stop the audio after the volume has been faded to zero.
 
 This pass through method for the instance of BDAPAudioPlayer will stop playing audio after the volume level fades to zero.
 
 @param duration The fade duration.
 
 */



- (void) stopWithFadeDuration:(NSTimeInterval)duration;

/** Pass through method for the instance of BDAPAudioPlayer that will begin playing audio and fade the music in up to the target volume.
 
 This pass through method for the instance of BDAPAudioPlayer will start playing music then fade the music in over the specified duration.
 
 @param duration The fade duration.
 
 */
- (void) playWithFadeDuration:(NSTimeInterval)duration;

/** Returns an NSDictionary with the URL of the currently playing track and the current time.
 
 This method returns an NSDictionary with the URL of the currently playing track and the current time.  The key of the URL is BDAPAudioPlayerCurrentTrackURLKey.  The current time is accessed by the key BDAPAudioPlayerCurrentTrackCurrentTimeKey
 
 @return An NSDictionary containing the currently playing track and the current time.
 
 */
-(NSDictionary *)currentTrackDict;

/** Starts playing the audio track with specified fade-in duration. .
 
 This method takes two arguments.  The first argument is an NSDictionary that contains the track to play and the time to start playing.  The second argument is the fade-in duration.
 
 @param trackDict An NSDictionary containing the track to play and the time in the track to start playing.  @see currentTrackDict
 @param fadeDuration The time to fade-in from zero to full volume.
 
 */
- (void) playWithFromTrackDict:(NSDictionary *)trackDict withFadeDuration:(NSTimeInterval)fadeDuration;


/** Starts playing the BPAPAudioPlayer at the track and time contained in the NSDictionary the method takes as its argument.
 
 Starts playing the BPAPAudioPlayer at the track and time contained in the NSDictionary the method takes as its argument.

 
 @param trackDict An NSDictionary containing the track to play and the time in the track to start playing.  @see currentTrackDict
 @see currentTrackDict
 @see playWithFromTrackDict:withFadeDuration:
 
 */
-(void)resumePlayWithTrackDict:(NSDictionary *)trackDict;

@end

NSString * const BDAPAudioPlayerCurrentTrackURLKey;
NSString * const BDAPAudioPlayerCurrentTrackCurrentTimeKey;
NSString * const BDAPAudioPlayerCurrentTrackDeviceCurrentTimeKey; // Deprecated
