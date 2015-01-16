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
    svr.type = tp;
    BOOL created = NO;
    switch (tp) {
        case ServerTypeNeteasyEnterprise:
            svr.name = @"imap.qiye.163.com";
            svr.port = 993;
            svr.connType = MCOConnectionTypeTLS;
            created = YES;
            break;

        default:
            break;
    }
    if(created){
        return svr;
    }
    return nil;
}

@end
