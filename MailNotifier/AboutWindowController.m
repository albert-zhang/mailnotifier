//
//  AboutWindowController.m
//  MailNotifier
//
//  Created by Yang Zhang on 1/20/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import "AboutWindowController.h"

@interface AboutWindowController ()
@property (weak) IBOutlet NSButton *idtksCheckbox;

@end

@implementation AboutWindowController

- (void)windowDidLoad {
    [super windowDidLoad];

    [self.window setLevel:NSStatusWindowLevel];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
- (IBAction)onIdthks:(id)sender {
    if(self.idtksCheckbox.state == NSOnState){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSAlert *alert = [[NSAlert alloc] init];
//            [alert setInformativeText:@"NO!"];
//            [alert setMessageText:@"Sorry but you can NOT think like that."];
//            [alert setAlertStyle:NSCriticalAlertStyle];
//            [alert runModal];
            self.idtksCheckbox.state = NSOffState;
        });
    }
}

#pragma mark -

- (BOOL)windowShouldClose:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:kAboutWindowClosedNotification object:nil];
    return YES;
}

@end
