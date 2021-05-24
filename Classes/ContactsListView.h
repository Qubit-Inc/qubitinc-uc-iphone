/*
 * Copyright (c) 2010-2020 Belledonne Communications SARL.
 *
 * This file is part of linphone-iphone 
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#import <UIKit/UIKit.h>

#import "UICompositeView.h"
#import "ContactsListTableView.h"
#import "UIInterfaceStyleButton.h"
#import "UIDigitButton.h"

typedef enum _ContactSelectionMode { ContactSelectionModeNone, ContactSelectionModeEdit } ContactSelectionMode;

@interface ContactSelection : NSObject <UISearchBarDelegate> {
}

+ (void)setSelectionMode:(ContactSelectionMode)selectionMode;
+ (ContactSelectionMode)getSelectionMode;
+ (void)setAddAddress:(NSString *)address;
+ (NSString *)getAddAddress;
/*!
 * Filters contacts by SIP domain.
 * @param domain SIP domain to filter. Use @"*" or nil to disable it.
 */
+ (void)setSipFilter:(NSString *)domain;

/*!
 * Weither contacts are filtered by SIP domain or not.
 * @return the filter used, or nil if none.
 */
+ (NSString *)getSipFilter;

/*!
 * Weither always keep contacts with an email address or not.
 * @param enable TRUE if you want to always keep contacts with an email.
 */
+ (void)enableEmailFilter:(BOOL)enable;

/*!
 * Weither always keep contacts with an email address or not.
 * @return TRUE if this behaviour is enabled.
 */
+ (BOOL)emailFilterEnabled;


+ (BOOL)getIdentifierFilter;

/*!
 * Filters contacts by name and/or email fuzzy matching pattern.
 * @param fuzzyName fuzzy word to match. Use nil to disable it.
 */
+ (void)setNameOrEmailFilter:(NSString *)fuzzyName;

/*!
 * Weither contacts are filtered by name and/or email.
 * @return the filter used, or nil if none.
 */
+ (NSString *)getNameOrEmailFilter;

@end

@interface ContactsListView : UIViewController <UICompositeViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate>

@property(strong, nonatomic) IBOutlet ContactsListTableView *tableController;
@property(strong, nonatomic) IBOutlet UIView *topBar;
@property(nonatomic, strong) IBOutlet UIButton *allButton;
@property(nonatomic, strong) IBOutlet UIButton *linphoneButton;
@property(nonatomic, strong) IBOutlet UIButton *addButton;
@property(strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property(weak, nonatomic) IBOutlet UIImageView *selectedButtonImage;
@property (weak, nonatomic) IBOutlet UIInterfaceStyleButton *toggleSelectionButton;
- (IBAction)refreshAction:(UIButton *)sender;

- (IBAction)onAllClick:(id)event;
- (IBAction)onLinphoneClick:(id)event;
- (IBAction)onAddContactClick:(id)event;
- (IBAction)onDeleteClick:(id)sender;
- (IBAction)onEditionChangeClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *keyboardView;
@property (weak, nonatomic) IBOutlet UIButton *dialButton;




//NUM pad outlets
@property (strong, nonatomic) IBOutlet UIView *numpadView;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property(nonatomic, strong) IBOutlet UIDigitButton *oneButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *twoButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *threeButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *fourButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *fiveButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *sixButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *sevenButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *eightButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *nineButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *starButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *zeroButton;
@property(nonatomic, strong) IBOutlet UIDigitButton *hashButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *backspaceButton;
@property (weak, nonatomic) IBOutlet UIButton *addContactButton;



@property (weak, nonatomic) IBOutlet UILabel *abcLabel;
@property (weak, nonatomic) IBOutlet UILabel *defLabel;

@property (weak, nonatomic) IBOutlet UILabel *ghiLabel;
@property (weak, nonatomic) IBOutlet UILabel *jklLabel;
@property (weak, nonatomic) IBOutlet UILabel *mnoLabel;

@property (weak, nonatomic) IBOutlet UILabel *pqrsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuvLabel;

@property (weak, nonatomic) IBOutlet UILabel *wxyzlabel;
@property (weak, nonatomic) IBOutlet UILabel *plusLabel;




- (IBAction)onAddressChange:(UITextField *)sender;
- (IBAction)onBackSpaceCLick:(UIButton *)sender;

- (IBAction)digitClicked:(UIButton *)sender;
- (IBAction)startClick:(UIButton *)sender;
- (IBAction)hashClick:(UIButton *)sender;
- (IBAction)addContactButonAction:(UIButton *)sender;
- (IBAction)callButtonAction:(UIButton *)sender;
- (IBAction)dialButtonAction:(UIButton *)sender;

- (void)setAddress:(NSString *)address;
- (IBAction)onFavouriteAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;

@end
