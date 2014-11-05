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
@end

// Edit this url to point to your backend script
NSString* urlToSend = @"http://projects.waldir.org/ihistory/post.php";

// Other assets
iTunesApplication *iTunes;
NSTimer *timer;
NSDistributedNotificationCenter *dnc;
NSLocale* currentLocale;
NSDateFormatter *dateFormatter;
NSInteger currentProgress = 0;
NSInteger delayToSend = 15;

@implementation AppDelegate

@synthesize statusBar = _statusBar;

- (void) awakeFromNib {
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    self.statusBar.title = @"iH";
    
    // you can also set an image
    //self.statusBar.image =
    
    self.statusBar.menu = self.statusMenu;
    self.statusBar.highlightMode = YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    // Itunes and Notification center
    iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    dnc = [NSDistributedNotificationCenter defaultCenter];
    [dnc addObserver:self selector:@selector(iTunesUpdated) name:@"com.apple.iTunes.playerInfo" object:nil];
    
    // Other initializations
    currentLocale = [NSLocale currentLocale];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // Set initial values for menu items
    if ([iTunes isRunning] && [iTunes playerState] == iTunesEPlSPlaying) {
        [self iTunesUpdated];
    } else {
        [self.currentSongMenu setTitle:[NSString stringWithFormat:@"Now Playing: Nothing"]];
        [self.currentStatusMenu setTitle:[NSString stringWithFormat:@"Status: Ready"]];
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [dnc removeObserver:self];
}

- (void)iTunesUpdated {
    // update the music title
    [self updateMusic];
    [timer invalidate];
    
    // If its not running, terminate
    if(![iTunes isRunning]) return;
    
    if ([iTunes playerState] == iTunesEPlSPlaying) {
        
        // resets counter
        currentProgress = 0;
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        
    } else if ([iTunes playerState] == iTunesEPlSPaused) {
        
        // dont reset counter, because if user starts playing again i will resume the counter
        [self.currentStatusMenu setTitle:[NSString stringWithFormat:@"Status: Paused"]];
        
    } else if ([iTunes playerState] == iTunesEPlSStopped) {
        
        [self.currentStatusMenu setTitle:[NSString stringWithFormat:@"Status: Stopped"]];
        
    }
}

-(void)updateMusic {
    NSString *trackName;
    
    NSLog(@"Rodou update music");
    NSLog(@"%@", iTunes);
    
    // If itunes is not running, terminate
    if(![iTunes isRunning]) return;
    
    // Updates music title
    if ([iTunes playerState] !=  iTunesEPlSStopped) {
        trackName = [NSString stringWithFormat:@"Now Playing: %@ - %@ (%@) [%d]",
                           [[iTunes currentTrack] name],
                           [[iTunes currentTrack] artist],
                           [[iTunes currentTrack] album],
                           (int)[[iTunes currentTrack] year]];
    } else {
        trackName = @"Now Playing: Nothing";
    }
    
    [self.currentSongMenu setTitle:trackName];
}

-(void)updateTimer {
    self.statusBar.title = [NSString stringWithFormat:@"%ld", (delayToSend - currentProgress)];
    [self.currentStatusMenu setTitle:[NSString stringWithFormat:@"Status: Sending in %lds...",
                                      (delayToSend - currentProgress)]];
    
    if (currentProgress == delayToSend) {
        [self sendMusic];
        [timer invalidate];
        self.statusBar.title = @"iH";
    }
    
    currentProgress++;
}

-(void)sendMusic {
    NSString *post = [NSString stringWithFormat:@"tname=%@&tartist=%@&talbum=%@&tyear=%d&datetime=%@",
                      [[iTunes currentTrack] name],
                      [[iTunes currentTrack] artist],
                      [[iTunes currentTrack] album],
                      (int)[[iTunes currentTrack] year],
                      [dateFormatter stringFromDate:[NSDate date]]
                      ];
    // NSLog(post);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",(int)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlToSend]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(conn) {
        [self.currentStatusMenu setTitle:@"Status: Sent"];
    } else {
        [self.currentStatusMenu setTitle:@"Status: Couldn't Send"];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
    NSLog(@"Rodou");
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

@end
