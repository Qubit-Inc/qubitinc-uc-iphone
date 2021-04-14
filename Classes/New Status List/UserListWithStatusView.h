//
//  UserListWithStatusView.h
//  linphone
//
//  Created by Suhail on 09/11/20.
//

#import <UIKit/UIKit.h>
#import "UICompositeView.h"
#import "UserStatusTableViewCell.h"
#import "StatusHeaderCell.h"
#import "linphoneapp-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserListWithStatusView : UIViewController<UICompositeViewDelegate, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate, UpdateCheckButtonDelegate,UITextFieldDelegate> {
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UILabel *labelDataNotFound;


@end

NS_ASSUME_NONNULL_END
