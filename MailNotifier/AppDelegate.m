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

    statusMenu = [[NSMenu alloc] init];

    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:@"Mail"];
//    [statusItem setImage:[NSImage imageNamed:@"StatusBarIcon"]];
    [statusItem setHighlightMode:YES];

    [statusMenu addItem:[NSMenuItem separatorItem]];
    [statusMenu addItem:[NSMenuItem separatorItem]];

    [statusMenu addItemWithTitle:@"Exit" action:@selector(onExit:) keyEquivalent:@"X"];


    [self asdf];
}

- (void)onExit:(id)sender{
    [[NSApplication sharedApplication] terminate:nil];
}

- (void)asdf{
    MCOIMAPSession *session = [[MCOIMAPSession alloc] init];
    [session setHostname:@"imap.qiye.163.com"];
    [session setPort:993];
    [session setUsername:@"yang.zhang@ck-telecom.com"];
    [session setPassword:@"Ck654321"];
    [session setConnectionType:MCOConnectionTypeTLS];

    MCOIMAPMessagesRequestKind requestKind = MCOIMAPMessagesRequestKindHeaders | MCOIMAPMessagesRequestKindFlags;
    NSString *folder = @"INBOX";
    MCOIndexSet *uids = [MCOIndexSet indexSetWithRange:MCORangeMake(0, 1000)];

    //    MCOIMAPFetchMessagesOperation *fetchOperation = [session fetchMessagesByUIDOperationWithFolder:folder requestKind:requestKind uids:uids];
    MCOIMAPFetchMessagesOperation *fetchOperation = [session fetchMessagesOperationWithFolder:folder requestKind:requestKind uids:uids];

    [fetchOperation start:^(NSError * error, NSArray * fetchedMessages, MCOIndexSet * vanishedMessages) {
        //We've finished downloading the messages!

        //Let's check if there was an error:
        if(error) {
            NSLog(@"Error downloading message headers:%@", error);
        }

        //And, let's print out the messages...
//        NSLog(@"The post man delivereth:%@, \n%@", fetchedMessages, vanishedMessages);

        for(MCOIMAPMessage *msg in fetchedMessages){
            NSString *subject = msg.header.subject;
            if(! subject){
                subject = @"<Empty>";
            }
            BOOL isRead = msg.flags & MCOMessageFlagSeen;
            NSMenuItem *itm = [[NSMenuItem alloc] init];
            if(isRead){
                itm.title = subject;
            }else{
                NSFont *boldf = [[NSFontManager sharedFontManager] fontWithFamily:statusMenu.font.familyName
                                                          traits:NSBoldFontMask
                                                          weight:0
                                                            size:statusMenu.font.fontDescriptor.pointSize];

                NSDictionary *attrs = @{NSFontAttributeName: boldf};
                itm.attributedTitle = [[NSAttributedString alloc] initWithString:subject attributes:attrs];
            }
            [itm setAction:@selector(onSelectMail:)];
            [statusMenu insertItem:itm atIndex:1];
        }
    }];
}

- (void)onSelectMail:(id)sender{

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
