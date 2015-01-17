//
//  Account.h
//  MailNotifier
//
//  Created by Yang Zhang on 1/16/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Server.h"

@interface Account : NSObject

@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) Server *server;

@property (nonatomic, readonly) NSString *UID;

@end
