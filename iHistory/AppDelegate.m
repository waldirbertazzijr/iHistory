//
//  AppDelegate.m
//  iHistory
//
//  Created by Waldir Bertazzi Junior on 10/29/14.
//  Copyright (c) 2014 Waldir Bertazzi Junior. All rights reserved.
//

#import "AppDelegate.h"
#import "iTunes.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end


iTunesApplication *iTunes;
NSTimer *timer;
NSDistributedNotificationCenter *dnc;
NSInteger currentProgress = 0;
NSInteger delayToSend = 10;

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    dnc = [NSDistributedNotificationCenter defaultCenter];
    
    [dnc addObserver:self selector:@selector(updateTrackName) name:@"com.apple.iTunes.playerInfo" object:nil];
    [self updateTrackName];
    [self.sendTimeoutProgress setMaxValue:delayToSend];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)updateTrackName {
    // resets counter
    currentProgress = 0;
    
    // updates visually
    [self.currentSong setStringValue:[[iTunes currentTrack] name]];
    [self.currentArtist setStringValue:[[iTunes currentTrack] artist]];
    
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTimer) userInfo:nil repeats:YES];
}

-(void)countTimer {
    [self.statusText setStringValue:[NSString stringWithFormat:@"Validating listening in %ld seconds...",(delayToSend - currentProgress)]];
    [self.sendTimeoutProgress setDoubleValue:currentProgress];
    
    if (currentProgress == delayToSend) {
        [self.statusText setStringValue:@"Sent."];
        [timer invalidate];
    }
    
    currentProgress++;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    
    [_window makeKeyAndOrderFront:self];
    
    return YES;
}

@end
