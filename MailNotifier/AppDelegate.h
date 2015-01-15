//
//  AppDelegate.h
//  MailNotifier
//
//  Created by Yang Zhang on 1/15/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kMailIndexToInsertInMenu 4

#define kMaxMailsToFetch 1000

typedef enum {
    CheckingStatusLookingUp,
    CheckingStatusError,
    CheckingStatusWait4Retry,
    CheckingStatusIdle
}CheckingStatus;

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    NSMenu *statusBarMenu;
    NSStatusItem *statusBarItem;
    NSMenuItem *appStatusMenuItem; // all mails are read, or unread count
    NSMenuItem *checkNowMenuItem;
    NSMenuItem *preferencesMenuItem;
    NSMenuItem *aboutMenuItem;
    NSMenuItem *exitMenuItem;

    NSMutableArray *mailMenuItems;

    BOOL unreadCount;
}

@end

