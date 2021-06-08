//
//  UserStatusTableViewCell.h
//  linphone
//
//  Created by Suhail on 11/11/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserStatusTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelStatusColor;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UIIconButton *detailsButton;

@end

NS_ASSUME_NONNULL_END
