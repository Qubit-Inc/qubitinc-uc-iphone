//
//  HTTPClient.h
//  linphone
//
//  Created by SHAD HAIDARI on 13/11/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ServiceCompletionHandler)(id response,NSError *error);
typedef void(^myCompletion)(BOOL);



@interface HTTPClient : NSObject {
    NSString *baseUrl;
}


-(void) callGetApi :(NSString*) path parameters:(NSDictionary *) andCompletion :(ServiceCompletionHandler) completionBlock;
-(void)callPostApi:(NSString *)path parameters:(NSDictionary *)parameters andCompletion :(ServiceCompletionHandler) completionBlock;
-(void)downloadVoiceMail:(NSString *)path andCompletion :(ServiceCompletionHandler)completionBlock;

+ (id)sharedManager;

@end

NS_ASSUME_NONNULL_END
