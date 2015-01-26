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
#import "Server.h"
#import "Account.h"

@interface PreferencesWindowController ()
@property (weak) IBOutlet NSPopUpButton *checkIntervalPopup;
@property (weak) IBOutlet NSButton *showFullMessageSubjectCheckbox;
@property (weak) IBOutlet NSButton *showInNotiCenterCheckbox;

@property (weak) IBOutlet NSTableView *accountTable;
@property (weak) IBOutlet NSButton *addAccountBtn;
@property (weak) IBOutlet NSButton *removeAccountBtn;
@property (weak) IBOutlet NSTextField *descField;
@property (weak) IBOutlet NSTextField *accountField;
@property (weak) IBOutlet NSSecureTextField *passwordField;
@property (weak) IBOutlet NSTextField *hostnameField;
@property (weak) IBOutlet NSTextField *portField;
@property (weak) IBOutlet NSButton *useSSLCheckbox;
@property (weak) IBOutlet NSButton *saveBtn;
@property (weak) IBOutlet NSPopUpButton *serverTemplatePopup;

@end

@implementation PreferencesWindowController

- (void)windowDidLoad {
    [super windowDidLoad];

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.

    [self setupCheckIntervalPopup];
	[self setupServerTemplatePopup];

    if(! [IAPManager sharedManager].hasPurchasedPro){
        [SettingsManager sharedManager].checkingInterval = CheckingInterval30;
    }
    [self setSelectedCheckInterval:[SettingsManager sharedManager].checkingInterval];
	
	self.accountTable.delegate = self;
	self.accountTable.dataSource = self;
	
	showingAccounts = [NSMutableArray arrayWithArray:
					   [SettingsManager sharedManager].accounts];
	
	[self.accountTable reloadData];

    if(showingAccounts.count > 0){
        [self.accountTable selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        [self showAccountAtIndex:0];
    }

    [self.window setLevel:NSStatusWindowLevel];
}


- (IBAction)onAddAccount:(id)sender {
	if(tmpCreatingAccount){
		return;
	}
	tmpCreatingAccount = [[Account alloc] init];
	[showingAccounts addObject:tmpCreatingAccount];
	long lastIndex = showingAccounts.count - 1;
	[self.accountTable insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:lastIndex]
							 withAnimation:NSTableViewAnimationSlideUp];
	[self.accountTable selectRowIndexes:[NSIndexSet indexSetWithIndex:lastIndex]
				   byExtendingSelection:NO];
}

- (IBAction)onRemoveAccount:(id)sender {
}

- (IBAction)onSave:(id)sender {
    Account *acc = [self showingAccount];
    if(acc){
        acc.desc = self.descField.stringValue;
        acc.username = self.accountField.stringValue;
        acc.password = self.passwordField.stringValue;
        // TODO: here
        NSLog(@"saved %@", acc.desc);
    }
}

- (IBAction)onCheckIntervalChange:(id)sender {
    int intvals[kCheckingIntervalCount] = CheckingIntervalCArray;
    int index = (int)[self.checkIntervalPopup indexOfSelectedItem];
    CheckingInterval intvalSelected = intvals[index];
    if(! [IAPManager sharedManager].hasPurchasedPro){
        if(intvalSelected != CheckingInterval30){
            intvalSelected = CheckingInterval30;
            [self setSelectedCheckInterval:CheckingInterval30];
        }
    }
    NSLog(@"selected: %lu", intvalSelected);
    [SettingsManager sharedManager].checkingInterval = intvalSelected;
}

- (IBAction)onServerTemplateChange:(id)sender {
	int index = (int)[self.serverTemplatePopup indexOfSelectedItem];
	if(index > 0){
		index -= 1; // substract the first tip item
		
		NSArray *svrs = [Server serversOfConfiguredTypes];
		Server *svr = svrs[index];
		[self.hostnameField setStringValue:svr.hostname];
		[self.portField setStringValue:[NSString stringWithFormat:@"%d", svr.port]];
		if(svr.connType == MCOConnectionTypeTLS){
			[self.useSSLCheckbox setState:1];
		}else{
			[self.useSSLCheckbox setState:0];
		}
		
		[self.serverTemplatePopup selectItemAtIndex:0];
	}
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

- (void)setSelectedCheckInterval:(CheckingInterval)intval{
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

- (void)setupServerTemplatePopup{
	[self.serverTemplatePopup removeAllItems];
	[self.serverTemplatePopup addItemWithTitle:@"Set server with..."];
	NSArray *svrs = [Server serversOfConfiguredTypes];
	for(int i=0; i<svrs.count; i++){
		Server *svr = svrs[i];
		[self.serverTemplatePopup addItemWithTitle:svr.templateName];
	}
}

#pragma mark -

- (void)showAccountAtIndex:(NSInteger)rowIndex{
    if(rowIndex < 0 || rowIndex >= showingAccounts.count){
        return;
    }

	Account *acc = showingAccounts[rowIndex];
	
	[self.descField setStringValue:acc.desc];
	[self.accountField setStringValue:acc.username];
	[self.passwordField setStringValue:acc.password];
	[self.hostnameField setStringValue:acc.server.hostname];
	[self.portField setStringValue:[NSString stringWithFormat:@"%d", acc.server.port]];
	if(acc.server.connType == MCOConnectionTypeTLS){
		[self.useSSLCheckbox setState:1];
	}else{
		[self.useSSLCheckbox setState:0];
	}
}

- (Account *)showingAccount{
    Account *acc = nil;
    NSInteger rowIndex = self.accountTable.selectedRow;
    if(rowIndex >= 0 && rowIndex < showingAccounts.count){
        acc = showingAccounts[rowIndex];
    }
    return acc;
}

#pragma mark -

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
	return showingAccounts.count;
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
				  row:(NSInteger)row
{
	NSTableCellView *result = [tableView makeViewWithIdentifier:@"MyView" owner:self];
	
	Account *acc = showingAccounts[row];
	result.textField.stringValue = acc.desc;
	return result;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification{
	NSUInteger index = self.accountTable.selectedRowIndexes.firstIndex;
	[self showAccountAtIndex:index];
	NSLog(@"changed: %lu", index);
}

#pragma mark -

- (BOOL)windowShouldClose:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPreferencesWindowClosedNotification object:nil];
    return YES;
}

@end
