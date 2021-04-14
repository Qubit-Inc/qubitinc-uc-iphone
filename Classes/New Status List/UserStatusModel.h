//
//  UserStatusModel.h
//  linphone
//
//  Created by SHAD HAIDARI on 13/11/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserStatusModel : NSObject

@property(nonatomic,strong)NSString* contact;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSString* status;
@property(nonatomic,strong)NSString* statusColor;
@property(nonatomic,strong)NSString* statusColorHex;

-(instancetype) initModel:(NSDictionary*) json;


@end

NS_ASSUME_NONNULL_END
