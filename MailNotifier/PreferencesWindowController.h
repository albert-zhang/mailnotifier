//
//  PreferencesWindowController.h
//  MailNotifier
//
//  Created by Albert Zhang on 1/17/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "types.h"

#define kPreferencesWindowClosedNotification    @"kPreferencesWindowClosedNotification"

@interface PreferencesWindowController : NSWindowController <NSComboBoxDataSource, NSComboBoxDelegate>

@end
