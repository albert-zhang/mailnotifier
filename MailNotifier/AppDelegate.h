//
//  AppDelegate.h
//  MailNotifier
//
//  Created by Yang Zhang on 1/15/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Account.h"

#define kIndexToInsertAccountMenuItem 4

#define kMaxMailsToFetch 1000

#define kWait4RetryDuration 5.0

#define kCheckingInterval 7.0

#define kFolderInbox	@"INBOX"


typedef enum {
    CheckingStatusChecking,
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
	
	/**
	 All the 3 array below are indexed by Account
	 */
	NSMutableDictionary *accounts; // account UID => Account
    NSMutableDictionary *messages; // account UID => Array of messages (MCOIMAPMessage)
	NSMutableDictionary *accountSubmenus; // account UID => Array of sub menus of this account

    int unreadCount;

    NSTimer *repeatCheckTimer;

    CheckingStatus checkingStatus;
    NSTimer *wait4retryTimer;
	
	int checkTotalCount;
	int checkCompletedCount;
}

@end

