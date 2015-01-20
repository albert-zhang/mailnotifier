//
//  IAPManager.m
//  MailNotifier
//
//  Created by Yang Zhang on 1/20/15.
//  Copyright (c) 2015 Yang Zhang. All rights reserved.
//

#import "IAPManager.h"

@implementation IAPManager

+ (IAPManager *)sharedManager{
    static IAPManager *glbIAPManager = nil;
    if(! glbIAPManager){
        glbIAPManager = [[IAPManager alloc] init];
    }
    return glbIAPManager;
}


@end
