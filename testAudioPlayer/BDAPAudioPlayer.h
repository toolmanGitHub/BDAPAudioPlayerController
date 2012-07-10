//
//  BDAPAudioPlayer.h
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


#import <AVFoundation/AVFoundation.h>

typedef void (^AVAudioPlayerFadeCompleteBlock)();

/** A subclass of AVAudioPlayer that provides volume fade in and fade out.
 
 This subclass of AVAudioPlayer provides volume fade-in and fade-out capability.  The four additional methods are added.  These methods allow fading either a specific volume over a defined volume or to play/stop over a specified duration.
 */

@interface BDAPAudioPlayer : AVAudioPlayer
/** A read only boolean which denotes whether or not the volume is currently being faded.
 
 */
@property (nonatomic,readonly) BOOL  fading;

/** The target fading volume.
 
 */
@property (nonatomic,readonly) float fadeTargetVolume;

/** Fade the audio to a specific volume over a specified duration.
 
 The volume is faded, either in or out, to a specific volume over a specified duration.
 
 @param targetVolume The target volume.
 @param duration The duration of the fade in volume.
 @see fadeToVolume:duration:completion:
 
 */
- (void) fadeToVolume:(float)targetVolume duration:(NSTimeInterval)duration;

/** Fade the audio to a specific volume over a specified duration.
 
 The volume is faded, either in or out, to a specific volume over a specified duration.
 
 @param targetVolume The target volume.
 @param duration The duration of the fade in volume.
 @param completion The block to be executed after the fade is complete.
 @see fadeToVolume:duration:
 
 */
- (void) fadeToVolume:(float)targetVolume duration:(NSTimeInterval)duration completion:(AVAudioPlayerFadeCompleteBlock)completion;

/** Fade the volume to zero over a specified duration and stop the audio player.
 
 This method will fade the volume to zero over the specified to duration.  When the fade is complete, the audio player will be stopped.

 @param duration The duration of the fade in volume.
 @see playWithFadeDuration:
 
 */
- (void) stopWithFadeDuration:(NSTimeInterval)duration;

/** Start the player and fade the music from zero volume to full volume over the specified duration.
 
 This method will start the player and fade-in the music from zero volume to full volume over the specified duration.
 
 @param duration The duration of the fade in volume.
 @see stopWithFadeDuration:
 
 */
- (void) playWithFadeDuration:(NSTimeInterval)duration;


@end
