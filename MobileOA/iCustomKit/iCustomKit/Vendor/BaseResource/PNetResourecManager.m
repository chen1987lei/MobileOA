//
//  PNetResourecManager.m
//  PCustomKit
//
//  Created by renqingyang on 2017/12/25.
//  Copyright © 2017年 ren. All rights reserved.
//

#import "PNetResourecManager.h"

@interface PNetResourecManager ()

@property (nonatomic, copy) PNetErrorCodeRet errorCodeRet;

@end
@implementation PNetResourecManager

kSingleton_m(PNetResourecManager)

#pragma mark - ******************************Initial Methods****************************************

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

- (void)dealloc
{
    
}

#pragma mark - ******************************Notification Method************************************

#pragma mark - ******************************KVO Method*********************************************

#pragma mark - ******************************Event Response*****************************************

#pragma mark - ******************************API Request Method*************************************

#pragma mark - ******************************API Response Method************************************

#pragma mark - ******************************Private Method*****************************************

#pragma mark - ******************************Public Method******************************************

- (void)i_performHandlerWithErrorCodeCallback:(PNetErrorCodeRet)errorCodeCallback
{
    self.errorCodeRet = errorCodeCallback;
}
#pragma mark - ******************************Override Method****************************************

#pragma mark - ******************************Delegate***********************************************

#pragma mark - ******************************Setter & Getter****************************************

- (void)setError:(NSError *)error
{
    _error = error;

    if (self.errorCodeRet)
    {
        self.errorCodeRet(error);
    };
}
@end
