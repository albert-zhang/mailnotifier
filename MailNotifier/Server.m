//
//  Server.m
//  MailNotifier
//
//  Created by Yang Zhang on 1/16/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import "Server.h"

@implementation Server

+ (Server *)serverWithType:(ServerType)tp{
    Server *svr = [[Server alloc] init];
    BOOL created = NO;
	switch (tp) {
		case ServerTypeGmail:
			svr.hostname = @"imap.gmail.com";
			svr.port = 993;
			svr.connType = MCOConnectionTypeTLS;
			svr->_templateName = @"Gmail";
			created = YES;
			break;
		case ServerTypeOutlook:
			svr.hostname = @"imap-mail.outlook.com";
			svr.port = 993;
			svr.connType = MCOConnectionTypeTLS;
			svr->_templateName = @"Outlook";
			created = YES;
			break;
        case ServerType163Enterprise:
            svr.hostname = @"imap.qiye.163.com";
            svr.port = 993;
			svr.connType = MCOConnectionTypeTLS;
			svr->_templateName = @"163 Enterprise";
            created = YES;
			break;
		case ServerType126:
			svr.hostname = @"imap.126.com";
			svr.port = 993;
			svr.connType = MCOConnectionTypeTLS;
			svr->_templateName = @"126";
			created = YES;
			break;
        default:
			svr.hostname = @"imap.example.com";
			svr.port = 993;
			svr.connType = MCOConnectionTypeTLS;
			svr->_templateName = nil;
			created = YES;
            break;
    }
    if(created){
        return svr;
    }
    return nil;
}

+ (NSArray *)serversOfConfiguredTypes{
	static NSMutableArray *servers_of_types = nil;
	if(servers_of_types == nil){
		servers_of_types = [NSMutableArray array];
	}
	NSArray *tps = @[@(ServerTypeGmail),
					 @(ServerTypeOutlook),
					 @(ServerType163Enterprise),
					 @(ServerType126)];
	for(int i=0; i<tps.count; i++){
		ServerType tp = [tps[i] intValue];
		Server *svr = [Server serverWithType:tp];
		[servers_of_types addObject:svr];
	}
	return servers_of_types;
}

@end
