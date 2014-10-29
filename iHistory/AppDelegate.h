//
//  AppDelegate.h
//  iHistory
//
//  Created by Waldir Bertazzi Junior on 10/29/14.
//  Copyright (c) 2014 Waldir Bertazzi Junior. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSTextField *currentSong;
@property (weak) IBOutlet NSTextField *currentArtist;
@property (weak) IBOutlet NSProgressIndicator *sendTimeoutProgress;
@property (weak) IBOutlet NSTextField *statusText;

@end

