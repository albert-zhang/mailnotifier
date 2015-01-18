//
//  AppDelegate.h
//  MailNotifier
//
//  Created by Yang Zhang on 1/15/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MailCore.h"

#import "Account.h"

#define kIndexToInsertAccountMenuItem 4

#define kMaxMailsToFetch 1000

#define kWait4RetryDuration 10.0

#define kCheckingInterval 30.0

#define kFolderInbox	@"INBOX"

#define kMenuFontSize 14

#define kShortenMessageMenuWidth 300.0


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
	NSMutableDictionary *accountMenuItems; // account UID => the AccountMenuItem
	NSMutableDictionary *accountSubmenus; // account UID => Array of sub menus of this account

    int unreadCount;

    NSTimer *repeatCheckTimer;

    CheckingStatus checkingStatus;
    NSTimer *wait4retryTimer;
	
	int checkTotalCount;
	int checkCompletedCount;
	BOOL checkHasError;
}

@end


@interface AccountMenuItem : NSMenuItem
{
	NSString *myTitle;
	BOOL isWarning;
	int unreadCount;
	BOOL showUnreadCount;
}
- (void)setTitle:(NSString *)title withWarningStatus:(BOOL)warning;
- (void)setWarningStatus:(BOOL)warning;
- (void)setUnreadCount:(int)c;
- (void)setShowUnreadCount:(BOOL)b;
@end

@interface MessageMenuItem : NSMenuItem
@property (nonatomic, strong) MCOIMAPMessage *message;
- (void)setError:(NSString *)err;
- (void)setInfo:(NSString *)info;
@end
