//
//  AppDelegate.m
//  MailNotifier
//
//  Created by Yang Zhang on 1/15/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "MailCore.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application

    [self createMenu];
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
    // place holder for the mails
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
    
    
    [self checkNow];
}

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

- (void)setCheckingStatus:(CheckingStatus)st{
    NSString *str = nil;
    switch (st) {
        case CheckingStatusError:
            str = @"Error occured";
            break;
        case CheckingStatusLookingUp:
            str = @"Looking Up ....";
            break;
        case CheckingStatusWait4Retry:
            str = @"Will try again soon";
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


- (void)checkNow{
    [self setCheckingStatus:CheckingStatusLookingUp];

    MCOIMAPSession *session = [[MCOIMAPSession alloc] init];
    [session setHostname:@"imap.qiye.163.com"];
    [session setPort:993];
    [session setUsername:@"yang.zhang@ck-telecom.com"];
    [session setPassword:@"Ck654321"];
    [session setConnectionType:MCOConnectionTypeTLS];

    MCOIMAPMessagesRequestKind requestKind = MCOIMAPMessagesRequestKindHeaders | MCOIMAPMessagesRequestKindFlags;
    NSString *folder = @"INBOX";
    MCOIndexSet *uids = [MCOIndexSet indexSetWithRange:MCORangeMake(0, kMaxMailsToFetch)];

    MCOIMAPFetchMessagesOperation *fetchOperation = [session fetchMessagesOperationWithFolder:folder requestKind:requestKind uids:uids];

    [fetchOperation start:^(NSError * error, NSArray * fetchedMessages, MCOIndexSet * vanishedMessages) {
        if(error) {
            NSLog(@"Error downloading message headers:%@", error);
            [self setCheckingStatus:CheckingStatusError];

        }else{
            unreadCount = 0;

            if(mailMenuItems){
                for(NSMenuItem *itm in mailMenuItems){
                    [statusBarMenu removeItem:itm];
                }
            }

            mailMenuItems = [NSMutableArray array];

            for(int i=0; i<fetchedMessages.count; i++){
                MCOIMAPMessage *msg = fetchedMessages[i];

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
                [statusBarMenu insertItem:itm atIndex:kMailIndexToInsertInMenu];

                [mailMenuItems addObject:itm];
            }

            [self setCheckingStatus:CheckingStatusIdle];
        }
    }];
}

- (void)onSelectMail:(id)sender{

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
