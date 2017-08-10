//
//  UTCMenuClockAppDelegate.h
//  UTCMenuClock
//
//  Created by John Adams on 11/14/11.
//
// Copyright 2011 John Adams
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <Cocoa/Cocoa.h>

@interface UTCMenuClockAppDelegate : NSObject <NSApplicationDelegate> {
    __unsafe_unretained NSWindow *window;
    NSMenu *mainMenu;
    __strong NSStatusItem *statusItem;
}

@property (assign) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSMenu *mainMenu;

@end
