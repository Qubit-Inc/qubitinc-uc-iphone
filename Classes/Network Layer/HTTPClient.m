//
//  HTTPClient.m
//  linphone
//
//  Created by SHAD HAIDARI on 13/11/20.
//

#import "HTTPClient.h"


@implementation HTTPClient


+ (id)sharedManager {
    static HTTPClient *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    //    self.someProperty = @"";
    return sharedMyManager;
}

- (id)initWithBaseUrl {
    if (self = [super init]) {
        [self setBaseurl];
    }
    return self;
}

-(void)setBaseurl {
    const MSList *proxies = linphone_core_get_proxy_config_list(LC);
    LinphoneProxyConfig *proxy = NULL;
    if (proxies) {
        proxy = proxies->data;
        const LinphoneAddress *identity_addr = linphone_proxy_config_get_identity_address(proxy);
        baseUrl = [NSString stringWithFormat:@"http://%s:8061/coraluc/phoneapi/v1/", linphone_address_get_domain(identity_addr)];
    }
    else {
        baseUrl = @"http://collaboration.coraltele.com:8061/coraluc/phoneapi/v1/";
    }
}


- (void)callGetApi:(NSString *)path parameters:(NSDictionary *)andCompletion :(ServiceCompletionHandler)completionBlock {
    
    NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration];
        
    if (baseUrl == NULL) {
        [self setBaseurl];
    }
    
    NSString *strUrl = [NSString stringWithFormat: @"%@%@", baseUrl, path];
    NSURL * url = [NSURL URLWithString:strUrl];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data != nil) {
            NSError *err = Nil;
            id jsonObject =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            
            if ([jsonObject isKindOfClass:[NSArray class]]) {
                NSLog(@"Probably An Array");
                completionBlock(jsonObject, error);
            }
            else {
                
                NSDictionary *jsonDictionary=(NSDictionary *)jsonObject;
                NSLog(@"Probably An Array %@", jsonDictionary);
                completionBlock(jsonDictionary, error);
                
            }
        } else {
            completionBlock(@"Something went wrong", error);
        }
    }];
    [dataTask resume];
}


- (void)downloadVoiceMail:(NSString *)path andCompletion :(ServiceCompletionHandler)completionBlock {
    
    NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration];
    
    if (baseUrl == NULL) {
        [self setBaseurl];
    }
    
    NSString *strUrl = [NSString stringWithFormat: @"%@%@", baseUrl, path];
    NSURL * url = [NSURL URLWithString:strUrl];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if(httpResponse.statusCode == 200) {
            completionBlock(data, error);
        }else {
            completionBlock(data, error);
        }
    }];
    [dataTask resume];
}


- (void)callPostApi:(NSString *)path parameters:(NSDictionary *)parameters andCompletion :(ServiceCompletionHandler)completionBlock {
        
    if (baseUrl == NULL) {
        [self setBaseurl];
    }
    
    NSString *strUrl = [NSString stringWithFormat: @"%@%@", baseUrl, path];
    NSURL * url = [NSURL URLWithString:strUrl];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSString *post = @"";
    for (NSString* key in parameters) {
        NSString* value = [parameters objectForKey:key];
        post = [post stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,value] ];
    }
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];

    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    

    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data != nil) {
            NSError *err = Nil;
            id jsonObject =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            
            if ([jsonObject isKindOfClass:[NSArray class]]) {
                NSLog(@"Probably An Array");
                completionBlock(jsonObject, error);
            }
            else {
                
                NSDictionary *jsonDictionary=(NSDictionary *)jsonObject;
                NSLog(@"Probably An Array %@", jsonDictionary);
                completionBlock(jsonDictionary, error);
                
            }
        } else {
            completionBlock(@"Something went wrong", error);
        }
    }];

    [postDataTask resume];
    
}






- (void)dealloc {
    // Should never be called, but just here for clarity really.
    baseUrl = NULL;
}

@end
