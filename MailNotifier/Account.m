//
//  Account.m
//  MailNotifier
//
//  Created by Yang Zhang on 1/16/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import "Account.h"

@implementation Account

- (instancetype)init
{
	self = [super init];
	if (self) {
	}
	return self;
}

- (NSString *)UID{
	NSString *str = [NSString stringWithFormat:@"%@-%@-%@-%d",
					 self.desc, self.username, self.server.hostname, self.server.port];
	return str;
}

- (BOOL)isEqual:(id)object{
	return [self.UID isEqualToString:((Account *)object).UID];
}

@end
