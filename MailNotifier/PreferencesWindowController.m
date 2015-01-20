//
//  PreferencesWindowController.m
//  MailNotifier
//
//  Created by Albert Zhang on 1/17/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import "PreferencesWindowController.h"
#import "SettingsManager.h"
#import "IAPManager.h"

@interface PreferencesWindowController ()
@property (weak) IBOutlet NSPopUpButton *checkIntervalPopup;
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

    [self setupCheckIntervalPopup];

    if(! [IAPManager sharedManager].hasPurchasedPro){
        [SettingsManager sharedManager].checkingInterval = CheckingInterval30;
    }
    [self setCheckInterval:[SettingsManager sharedManager].checkingInterval];
}


- (IBAction)onAddAccount:(id)sender {
}

- (IBAction)onRemoveAccount:(id)sender {
}

- (IBAction)onSave:(id)sender {
}

- (IBAction)onCheckIntervalChange:(id)sender {
    int intvals[kCheckingIntervalCount] = CheckingIntervalCArray;
    int index = (int)[self.checkIntervalPopup indexOfSelectedItem];
    CheckingInterval intvalSelected = intvals[index];
    NSLog(@"selected: %lu", intvalSelected);
}

#pragma mark -

- (void)setupCheckIntervalPopup{
    [self.checkIntervalPopup removeAllItems];
    int intvals[kCheckingIntervalCount] = CheckingIntervalCArray;
    for(int i=0; i<kCheckingIntervalCount; i++){
        int intval = intvals[i];
        NSString *str = [self intervalStringFromInterval:intval];
        [self.checkIntervalPopup addItemWithTitle:str];
    }
}

- (void)setCheckInterval:(CheckingInterval)intval{
    int foundIndex = -1;
    for(int i=0; i<kCheckingIntervalCount; i++){
        NSString *targetStr = [self intervalStringFromInterval:intval];
        NSString *str = [self.checkIntervalPopup itemTitleAtIndex:i];
        if([str isEqualToString:targetStr]){
            foundIndex = i;
            break;
        }
    }
    if(foundIndex >= 0){
        [self.checkIntervalPopup selectItemAtIndex:foundIndex];
    }
}

- (NSString *)intervalStringFromInterval:(CheckingInterval)interval{
    return [NSString stringWithFormat:@"%lu minute%@", interval, interval > 1 ? @"s":@""];
}

#pragma mark -

- (BOOL)windowShouldClose:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPreferencesWindowClosedNotification object:nil];
    return YES;
}

@end
