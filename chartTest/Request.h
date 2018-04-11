//
//  Request.h
//  WoLaiYe
//
//  Created by 鲁征东 on 16/6/19.
//  Copyright © 2016年 鲁征东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"AFNetworking.h"


typedef void (^block)(NSError* error,id resultDict);

@interface Request : NSObject


+ (void)getData:(NSString*)urlString Completion:(block)completion;

+(void)PostData:(NSString*)urlString Parameters:(NSDictionary*)parameter Completion:(block)completion;

@end
