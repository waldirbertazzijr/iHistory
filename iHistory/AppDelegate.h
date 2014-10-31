//
//  AppDelegate.h
//  iHistory
//
//  Created by Waldir Bertazzi Junior on 10/29/14.
//  Copyright (c) 2014 Waldir Bertazzi Junior. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic) IBOutlet NSMenu *statusMenu;
@property (weak) IBOutlet NSMenuItem *currentSongMenu;
@property (weak) IBOutlet NSMenuItem *currentStatusMenu;
@property (strong, nonatomic) NSStatusItem *statusBar;

@end

