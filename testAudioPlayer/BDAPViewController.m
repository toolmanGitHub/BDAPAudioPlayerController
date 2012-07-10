//
//  BDAPViewController.m
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

#import "BDAPViewController.h"

@interface BDAPViewController ()
@property (nonatomic,strong) NSDictionary *trackDict;

@end

@implementation BDAPViewController
@synthesize audioPlayerController = audioPlayerController_;
@synthesize trackDict = trackDict_;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (IBAction)play:(id)sender {
    [self.audioPlayerController play];
}
-(BDAPAudioPlayerController *)audioPlayerController{
    if (audioPlayerController_) {
        return audioPlayerController_;
    }
#warning Replace the tracks below with your own.
    NSArray *musicURLs=[NSArray arrayWithObjects:[[NSBundle mainBundle] URLForResource:@"02 BU2B" withExtension:@"m4a"],[[NSBundle mainBundle] URLForResource:@"01 Paper Airplane" withExtension:@"m4a"],nil];
    audioPlayerController_=[[BDAPAudioPlayerController alloc] initWithURLs:musicURLs];
    return audioPlayerController_;
}

- (IBAction)resumePlay:(id)sender {
    NSLog(@"resumePlay");
    NSLog(@"    audioPlayerController:  %@",audioPlayerController_);
    if (audioPlayerController_) {
        NSLog(@"        audioPlayerController.audioPlayer:  %@",self.audioPlayerController.audioPlayer);
        [self.audioPlayerController.audioPlayer pause];
    }
    
}

- (IBAction)stop:(id)sender {
    
    [self.audioPlayerController stop];
}
- (IBAction)retrieveTractDict:(id)sender {
    NSLog(@"retrieveTractDict");
    self.trackDict=[self.audioPlayerController currentTrackDict];
    NSLog(@"    trackDict:  %@",self.trackDict);
    [[NSUserDefaults standardUserDefaults] setObject:self.trackDict forKey:@"trackDict"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (IBAction)resumeAtDict:(id)sender {
    NSLog(@"resumeAtDict");
    NSDictionary *trackDict=[[NSUserDefaults standardUserDefaults] objectForKey:@"trackDict"];
    if (trackDict) {
        [self.audioPlayerController resumePlayWithTrackDict:trackDict];
    }else{
        NSLog(@"    trackDict is nil");
    }
}
- (IBAction)playWithFadeButtonAction:(id)sender {
    [self.audioPlayerController playWithFadeDuration:3.0f];
}
- (IBAction)stopWithFadeButtonAction:(id)sender {
    [self.audioPlayerController stopWithFadeDuration:3.0f];
}
- (IBAction)previousTrack:(id)sender {
    [self.audioPlayerController playPreviousTrack];
}
- (IBAction)nextTrack:(id)sender {
    [self.audioPlayerController playNextTrack];
}
@end
