//
//  GetUserStatus.m
//  linphone
//
//  Created by Suhail on 27/12/20.
//

#import "GetUserStatus.h"
#import "PhoneMainView.h"
#import "UserStatusModel.h"
#import "LinphoneManager.h"
#import "UICompositeView.h"
#import "HTTPClient.h"
#import "SVProgressHUD.h"

@implementation GetUserStatus

@synthesize someProperty;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static Singleton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        getCon
    }
    return self;
}


-(void) getContactStatus {
    
    HTTPClient *sharedManager = [HTTPClient sharedManager];
    NSDictionary *param = [[NSDictionary alloc] init];
    LinphoneProxyConfig *default_proxy = linphone_core_get_default_proxy_config(LC);
    
    if (default_proxy != NULL) {
        
        const char *userName = linphone_address_get_username(linphone_proxy_config_get_identity_address(default_proxy));
        
        NSString *encryptedUserName = [self getEncryptedName:[NSString stringWithFormat:@"%s", userName]];
        NSString *path = [NSString stringWithFormat:@"getstatuslist/%@", encryptedUserName];
        
        [SVProgressHUD show];
        [sharedManager callGetApi:path parameters:param :^(id  _Nonnull response, NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            userModelArray = [NSMutableArray new];
            if (error == nil){
                NSDictionary *jsonDictionary=(NSDictionary *)response;
                NSInteger status = [[jsonDictionary valueForKey:@"status"] intValue];
                if (status == 0) {
                    NSMutableArray *arrayData = [jsonDictionary valueForKey:@"data"];
                    for(NSDictionary *json in arrayData) {
                        UserStatusModel *model = [[UserStatusModel new] initModel:json];
                        [userModelArray addObject:model];
                    }
                    original = [[NSArray alloc] initWithArray:userModelArray];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.labelDataNotFound.text = @"";
                        [self.tableView reloadData];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.labelDataNotFound.text = @"Records not found";
                        
                    });
                }
            }
        }];
    }
    
}


@end
