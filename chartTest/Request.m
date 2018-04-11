//
//  Request.m
//  WoLaiYe
//
//  Created by 鲁征东 on 16/6/19.
//  Copyright © 2016年 鲁征东. All rights reserved.
//

#import "Request.h"

@implementation Request
+ (void)getData:(NSString*)urlString Completion:(block)completion;{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript", nil];
    
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"responseObject---%@",responseObject);

        if (completion) {
            completion(nil,(NSDictionary*)responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"+error+++++%@",error.description);

        completion(error,nil);
    }];
    
    
}

+(void)PostData:(NSString*)urlString Parameters:(NSDictionary*)parameter Completion:(block)completion;{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript", nil];
    
    
    [manager POST:urlString parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"responseObject---%@",responseObject);
        
        if (completion) {
            completion(nil,(NSDictionary*)responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"+error+++++%@",error.description);
        
        completion(error,nil);
        
    }];
    
    
    
}
@end
