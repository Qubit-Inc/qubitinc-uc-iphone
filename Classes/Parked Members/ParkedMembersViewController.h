//
//  ParkedMembersViewController.h
//  sanchar
//
//  Created by Suhail Shabir on 17/04/21.
//

#import <UIKit/UIKit.h>
#import "UICompositeView.h"
#import "BSDropDown.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParkedMembersViewController : UIViewController<UICompositeViewDelegate, BSDropDownDelegate>
- (IBAction)showDropDown:(UIButton *)sender;

- (IBAction)backAction:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
