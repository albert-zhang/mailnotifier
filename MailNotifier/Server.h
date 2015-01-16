//
//  Server.h
//  MailNotifier
//
//  Created by Yang Zhang on 1/16/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MCOConstants.h"

typedef enum {
    ServerTypeOther,
    ServerTypeGmail,
    ServerTypeOutlook,
    ServerTypeNeteasyEnterprise
}ServerType;

@interface Server : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int port;
@property (nonatomic, assign) MCOConnectionType connType;
@property (nonatomic, assign) ServerType type;

+ (Server *)serverWithType:(ServerType)tp;

@end
