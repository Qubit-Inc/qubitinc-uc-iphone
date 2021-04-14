//
//  StatusHeaderCell.h
//  linphone
//
//  Created by Suhail on 26/12/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UpdateCheckButtonDelegate <NSObject>

-(void)checkboxOptionChanged : (BOOL) checkedStatus;

@end


@interface StatusHeaderCell : UITableViewCell
@property(nonatomic, strong) id<UpdateCheckButtonDelegate> checkButtonDelegate;

@property (weak, nonatomic) IBOutlet UIButton *buttonUnCheck;
@property (weak, nonatomic) IBOutlet UIButton *buttonCheck;
- (IBAction)uncheckAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSearch;
- (IBAction)checkAction:(UIButton *)sender;

- (void) updateButton: (BOOL) isChecked;


@end

NS_ASSUME_NONNULL_END
