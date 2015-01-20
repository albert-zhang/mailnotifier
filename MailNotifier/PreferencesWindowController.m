//
//  PreferencesWindowController.m
//  MailNotifier
//
//  Created by Albert Zhang on 1/17/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import "PreferencesWindowController.h"

@interface PreferencesWindowController ()
@property (weak) IBOutlet NSComboBox *checkIntervalCombobox;
@property (weak) IBOutlet NSButton *showFullMessageSubjectCheckbox;
@property (weak) IBOutlet NSButton *showInNotiCenterCheckbox;

@property (weak) IBOutlet NSTextField *descField;
@property (weak) IBOutlet NSTextField *accountField;
@property (weak) IBOutlet NSTextField *hostnameField;
@property (weak) IBOutlet NSTextField *portField;
@property (weak) IBOutlet NSButton *useSSLCheckbox;
@property (weak) IBOutlet NSButton *saveBtn;

@property (weak) IBOutlet NSButton *addAccountBtn;
@property (weak) IBOutlet NSButton *removeAccountBtn;

@end

@implementation PreferencesWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)onAddAccount:(id)sender {
}

- (IBAction)onRemoveAccount:(id)sender {
}

- (IBAction)onSave:(id)sender {
}

#pragma mark -

- (BOOL)windowShouldClose:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPreferencesWindowClosedNotification object:nil];
    return YES;
}

@end
