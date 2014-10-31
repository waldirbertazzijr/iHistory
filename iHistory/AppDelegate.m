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

@synthesize statusBar = _statusBar;

- (void) awakeFromNib {
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    self.statusBar.title = @"H";
    
    // you can also set an image
    //self.statusBar.image =
    
    self.statusBar.menu = self.statusMenu;
    self.statusBar.highlightMode = YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    // Itunes and Notification center
    iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    dnc = [NSDistributedNotificationCenter defaultCenter];
    [dnc addObserver:self selector:@selector(updateTrackName) name:@"com.apple.iTunes.playerInfo" object:nil];
    
    // Update current track name
    [self updateTrackName];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)updateTrackName {
    // resets counter
    currentProgress = 0;
    
    // updates visually
    NSString *trackName = [NSString stringWithFormat:@"%@ - %@ (%@) [%d]",
                           [[iTunes currentTrack] name],
                           [[iTunes currentTrack] artist],
                           [[iTunes currentTrack] album],
                           (int)[[iTunes currentTrack] year]];
    
    [self.currentSongMenu setTitle:trackName];
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTimer) userInfo:nil repeats:YES];
}

-(void)countTimer {
    [self.currentStatusMenu setTitle:[NSString stringWithFormat:@"Validating listening in %ld seconds...",
                                      (delayToSend - currentProgress)]];
    
    if (currentProgress == delayToSend) {
        [self.currentStatusMenu setTitle:@"Music sent"];
        [timer invalidate];
    }
    
    currentProgress++;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    
    [_window makeKeyAndOrderFront:self];
    
    return YES;
}

@end
