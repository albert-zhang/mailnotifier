//
//  AppDelegate.m
//  MailNotifier
//
//  Created by Yang Zhang on 1/15/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "MailCore.h"
#import "SettingsManager.h"

@implementation AppDelegate


- (void)test{
	MCOIMAPSession *session = [[MCOIMAPSession alloc] init];

//	[session setHostname:@"imap.qiye.163.com"];
//	[session setPort:993];
//	[session setUsername:@"yang.zhang@ck-telecom.com"];
//	[session setPassword:@"Ck654321"];
//	[session setConnectionType:MCOConnectionTypeTLS];

//	[session setHostname:@"imap.gmail.com"];
//	[session setPort:993];
//	[session setUsername:@"edistein.zhang@gmail.com"];
//	[session setPassword:@"asdf"];
//	[session setConnectionType:MCOConnectionTypeTLS];

	[session setHostname:@"imap.126.com"];
	[session setPort:993];
	[session setUsername:@"daodaner@126.com"];
	[session setPassword:@"123654987"];
	[session setConnectionType:MCOConnectionTypeTLS];

	NSLog(@"started");
	MCOIMAPFetchFoldersOperation *fetchOperation = [session fetchAllFoldersOperation];
	[fetchOperation start:^(NSError *error, NSArray *folders) {
		if(error){
			NSLog(@"%@", error);
		}else{
			NSLog(@"folders: ");
		}
		for(MCOIMAPFolder *f in folders){
			NSLog(@"folder: [%@], %ld", f.path, (f.flags & MCOIMAPFolderFlagInbox));
		}
	}];


//	MCOIMAPMessagesRequestKind requestKind = MCOIMAPMessagesRequestKindHeaders | MCOIMAPMessagesRequestKindFlags;
//	MCOIndexSet *uids = [MCOIndexSet indexSetWithRange:MCORangeMake(0, kMaxMailsToFetch)];
//
//	MCOIMAPFetchMessagesOperation *fetchOperation = [session fetchMessagesOperationWithFolder:@"abcd" requestKind:requestKind uids:uids];
//	[fetchOperation start:^(NSError *error, NSArray *fetchedMessages, MCOIndexSet *vanishedMessages){
//		if(error){
//			NSLog(@"%@", error);
//		}else{
//			NSLog(@"%lu", fetchedMessages.count);
//		}
//	}];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
	
//	[self test];
//	return;
	
	[self fetchAccounts];
	[self createMessageContainer];

    [self createMenu];
}


- (void)fetchAccounts{
	accounts = [NSMutableDictionary dictionary];
	
	NSArray *accs = [SettingsManager sharedManager].accounts;
	for(Account *acc in accs){
		[accounts setObject:acc forKey:acc.UID];
	}
}


- (void)createMessageContainer{
	messages = [NSMutableDictionary dictionaryWithCapacity:accounts.count];
	for(NSString *UID in accounts){
		Account *acc = accounts[UID];
		[messages setObject:[NSMutableArray array] forKey:acc.UID];
	}
}

- (NSMutableArray *)messagesContainerForAccount:(Account *)acc{
	return [messages objectForKey:acc.UID];
}


- (void)createMenu{
    statusBarMenu = [[NSMenu alloc] init];

    statusBarItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    statusBarItem.menu = statusBarMenu;
    statusBarItem.title = @"Mail";
    //    [statusItem setImage:[NSImage imageNamed:@"StatusBarIcon"]];
    statusBarItem.highlightMode = YES;

    appStatusMenuItem = [[NSMenuItem alloc] init];
    appStatusMenuItem.title = @"";
    appStatusMenuItem.enabled = NO;
    [statusBarMenu addItem:appStatusMenuItem];

    [statusBarMenu addItem:[NSMenuItem separatorItem]];

    checkNowMenuItem = [[NSMenuItem alloc] init];
    checkNowMenuItem.title = @"Check Now";
    checkNowMenuItem.action = @selector(onCheckNow:);
    checkNowMenuItem.keyEquivalent = @"C";
    checkNowMenuItem.keyEquivalentModifierMask = 0;
    [statusBarMenu addItem:checkNowMenuItem];

    [statusBarMenu addItem:[NSMenuItem separatorItem]];
    // place holder for the account menu items
    [statusBarMenu addItem:[NSMenuItem separatorItem]];

    preferencesMenuItem = [[NSMenuItem alloc] init];
    preferencesMenuItem.title = @"Perferences...";
    preferencesMenuItem.action = @selector(onPerferences:);
    preferencesMenuItem.keyEquivalent = @"P";
    preferencesMenuItem.keyEquivalentModifierMask = 0;
    [statusBarMenu addItem:preferencesMenuItem];

    aboutMenuItem = [[NSMenuItem alloc] init];
    aboutMenuItem.title = @"About...";
    aboutMenuItem.action = @selector(onAbout:);
    aboutMenuItem.keyEquivalent = @"A";
    aboutMenuItem.keyEquivalentModifierMask = 0;
    [statusBarMenu addItem:aboutMenuItem];

    [statusBarMenu addItem:[NSMenuItem separatorItem]];

    exitMenuItem = [[NSMenuItem alloc] init];
    exitMenuItem.title = @"Exit";
    exitMenuItem.action = @selector(onExit:);
    exitMenuItem.keyEquivalent = @"Q";
    exitMenuItem.keyEquivalentModifierMask = 0;
    [statusBarMenu addItem:exitMenuItem];

	[self createMenuItemsForAccounts];

    checkingStatus = CheckingStatusIdle;

    [self startCheckingRepeatedly];

    [self checkNow];
}

- (void)createMenuItemsForAccounts{
	accountSubmenus = [NSMutableDictionary dictionaryWithCapacity:accounts.count];
	
	for(NSString *UID in accounts){
		Account *acc = accounts[UID];
		NSMenuItem *itm = [[NSMenuItem alloc] init];
		itm.title = acc.desc;
		
		NSMenu *subm = [[NSMenu alloc] init];
		[accountSubmenus setObject:subm forKey:acc.UID];
		
		itm.submenu = subm;
		
		[statusBarMenu insertItem:itm atIndex:kIndexToInsertAccountMenuItem];
	}
}

- (NSMenu *)accountSubmenuForAccount:(Account *)acc{
	return [accountSubmenus objectForKey:acc.UID];
}

#pragma mark -

- (void)setCheckingStatus:(CheckingStatus)st{
    checkingStatus = st;
    NSString *str = nil;
    switch (st) {
        case CheckingStatusError:
            str = @"Error occured";
            break;
        case CheckingStatusChecking:
            str = @"Checking ....";
            break;
        case CheckingStatusWait4Retry:
            str = @"Error, will try again soon";
            break;
        case CheckingStatusIdle:
            if(unreadCount > 0){
                str = [NSString stringWithFormat:@"You have %d unread mails", unreadCount];
            }else{
                str = @"Ahh, all mails are read";
            }
            break;
        default:
            break;
    }
    appStatusMenuItem.title = str;
}

#pragma mark -


- (void)checkForAccount:(Account *)acc
			 onComplete:(void (^)(Account *checkedAccount, NSError *error, NSArray *fetchedMessages))onComplete
{
	MCOIMAPSession *session = [[MCOIMAPSession alloc] init];
	[session setHostname:acc.server.hostname];
	[session setPort:acc.server.port];
	[session setUsername:acc.username];
	[session setPassword:acc.password];
	[session setConnectionType:acc.server.connType];
	
	MCOIMAPMessagesRequestKind requestKind = MCOIMAPMessagesRequestKindHeaders | MCOIMAPMessagesRequestKindFlags;
	MCOIndexSet *uids = [MCOIndexSet indexSetWithRange:MCORangeMake(0, kMaxMailsToFetch)];
	
	MCOIMAPFetchMessagesOperation *fetchOperation = [session fetchMessagesOperationWithFolder:kFolderInbox
																				  requestKind:requestKind uids:uids];
	
	NSLog(@"start check %@", acc.username);
	[fetchOperation start:^(NSError *error, NSArray *fetchedMessages, MCOIndexSet *vanishedMessages){
		NSLog(@"check %@ done, error %@, count %lu, vanished count: %u",
			  acc.username, error, fetchedMessages.count, vanishedMessages.count);
		onComplete(acc, error, fetchedMessages);
	}];
}


- (void)checkNow{
    if(checkingStatus == CheckingStatusChecking){
        return;
    }

    [self cancelWait4Retry];

    [self setCheckingStatus:CheckingStatusChecking];
	
	
	checkTotalCount = (int)accounts.count;
	checkCompletedCount = 0;
	
	unreadCount = 0;
	
	
	for(NSString *UID in accounts){
		Account *acc2chk = accounts[UID];
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			[self checkForAccount:acc2chk onComplete:^(Account *checkedAccount, NSError *error, NSArray *msgs) {
				NSMenu *accSubmenu = [self accountSubmenuForAccount:checkedAccount];
				[accSubmenu removeAllItems];
				
				if(error){
					NSMenuItem *itm = [[NSMenuItem alloc] init];
					itm.title = @"Error, unable to get messages";
					itm.enabled = NO;
					[accSubmenu addItem:itm];
					
				}else{
					NSMutableArray *msgContainer = [self messagesContainerForAccount:checkedAccount];
					[msgContainer removeAllObjects];
					[msgContainer addObjectsFromArray:msgs];
					
					for(int i=0; i<msgs.count; i++){
						MCOIMAPMessage *msg = msgs[i];
						
						NSString *subject = msg.header.subject;
						if(! subject){
							subject = @"<No Subject>";
						}
						BOOL isRead = msg.flags & MCOMessageFlagSeen;
						NSMenuItem *itm = [[NSMenuItem alloc] init];
						if(isRead){
							itm.title = subject;
						}else{
							unreadCount ++;
							NSFont *boldf = [[NSFontManager sharedFontManager] fontWithFamily:statusBarMenu.font.familyName
																					   traits:NSBoldFontMask
																					   weight:0
																						 size:statusBarMenu.font.fontDescriptor.pointSize];
							NSDictionary *attrs = @{NSFontAttributeName: boldf};
							itm.attributedTitle = [[NSAttributedString alloc] initWithString:subject attributes:attrs];
						}
						[itm setAction:@selector(onSelectMail:)];
						
						[accSubmenu insertItem:itm atIndex:0];
					}
					
				}
				
				[self checkAAccountComp];
			}];
		});
	}
}

- (void)checkAAccountComp{
	@synchronized(self){
		checkCompletedCount ++;
	}
	
	if(checkCompletedCount >= checkTotalCount){
		[self setCheckingStatus:CheckingStatusIdle];
		[self startCheckingRepeatedly];
	}
}

#pragma mark -

- (void)cancelWait4Retry{
    if(wait4retryTimer){
        [wait4retryTimer invalidate];
        wait4retryTimer = nil;
    }
}

- (void)wait4retry{
    [self setCheckingStatus:CheckingStatusWait4Retry];

    [self cancelWait4Retry];
    wait4retryTimer = [NSTimer timerWithTimeInterval:kWait4RetryDuration
											  target:self selector:@selector(onWait4RetryTimer:)
											userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:wait4retryTimer forMode:NSRunLoopCommonModes];
}

- (void)onWait4RetryTimer:(NSTimer *)t{
    [self cancelWait4Retry];

    [self checkNow];
}

#pragma mark -

- (void)startCheckingRepeatedly{
    if(repeatCheckTimer){
        [repeatCheckTimer invalidate];
    }
    repeatCheckTimer = [NSTimer timerWithTimeInterval:kCheckingInterval
											   target:self selector:@selector(onRepeatCheckTimer:)
											 userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:repeatCheckTimer forMode:NSRunLoopCommonModes];
}

- (void)onRepeatCheckTimer:(NSTimer *)t{
    if(checkingStatus == CheckingStatusIdle){
        [self checkNow];
    }
}

#pragma mark -

- (void)onCheckNow:(id)sender{
    [self checkNow];
}


- (void)onPerferences:(id)sender{

}

- (void)onAbout:(id)sender{

}

- (void)onExit:(id)sender{
    [[NSApplication sharedApplication] terminate:nil];
}


- (void)onSelectMail:(id)sender{

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
