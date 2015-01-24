//
//  SettingsManager.m
//  MailNotifier
//
//  Created by Albert Zhang on 1/17/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import "SettingsManager.h"
#import "Account.h"
#import "IAPManager.h"

@implementation SettingsManager

+ (SettingsManager *)sharedManager{
	static SettingsManager *glbSettingsManager = nil;
	if(! glbSettingsManager){
		glbSettingsManager = [[SettingsManager alloc] init];
	}
	return glbSettingsManager;
}


- (NSTimeInterval)checkingIntervalValue{
    NSTimeInterval min = self.checkingInterval;
    return min * 60.0;
}


- (instancetype)init
{
	self = [super init];
	if (self) {
		_showFullSubject = NO;
		[self readSettings];
	}
	return self;
}


- (void)readSettings{
	[self test_values];//////////////////////////////////////////////////////////////
}


- (void)test_values{
	_showFullSubject = NO;
	[IAPManager sharedManager].hasPurchasedPro = YES;
	_checkingInterval = CheckingInterval30;
	
	
	NSMutableArray *accs = [NSMutableArray array];
	Account *a = nil;
	
	a = [[Account alloc] init];
	a.desc = @"CK Tech";
	a.username = @"yang.zhang@ck-telecom.com";
	a.password = @"Ck654321";
	a.server = [Server serverWithType:ServerType163Enterprise];
	[accs addObject:a];
	
	a = [[Account alloc] init];
	a.desc = @"126";
	a.username = @"daodaner@126.com";
	a.password = @"123654987";
	a.server = [Server serverWithType:ServerType126];
	[accs addObject:a];
	
	a = [[Account alloc] init];
	a.desc = @"Outlook";
	a.username = @"edistein.zhang@outlook.com";
	a.password = @"asdf";
	a.server = [Server serverWithType:ServerTypeOutlook];
	[accs addObject:a];
	
	_accounts = accs;
}


@end
