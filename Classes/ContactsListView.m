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

#import "PhoneMainView.h"
#import "NumPadViewController.h"

@implementation ContactSelection

static ContactSelectionMode sSelectionMode = ContactSelectionModeNone;
static NSString *sAddAddress = nil;
static NSString *sSipFilter = nil;
static BOOL sIdentifierFilter = FALSE;
static BOOL sEnableEmailFilter = FALSE;
static NSString *sNameOrEmailFilter;
static BOOL addAddressFromOthers = FALSE;

+ (void)setSelectionMode:(ContactSelectionMode)selectionMode {
	sSelectionMode = selectionMode;
}

+ (ContactSelectionMode)getSelectionMode {
	return sSelectionMode;
}

+ (void)setAddAddress:(NSString *)address {
	sAddAddress = address;
	addAddressFromOthers = true;
}

+ (NSString *)getAddAddress {
	return sAddAddress;
}

+ (void)setSipFilter:(NSString *)domain {
	sSipFilter = domain;
}

+ (NSString *)getSipFilter {
	return sSipFilter;
}

+ (void)enableEmailFilter:(BOOL)enable {
	sEnableEmailFilter = enable;
}

+ (BOOL)emailFilterEnabled {
	return sEnableEmailFilter;
}

+ (void)setIdentifierFilter:(BOOL)enable {
    sIdentifierFilter = enable;
}

+ (BOOL)getIdentifierFilter {
    return sIdentifierFilter;
}

+ (void)setNameOrEmailFilter:(NSString *)fuzzyName {
	sNameOrEmailFilter = fuzzyName;
}

+ (NSString *)getNameOrEmailFilter {
	return sNameOrEmailFilter;
}

@end

@implementation ContactsListView

@synthesize tableController;
@synthesize allButton;
@synthesize linphoneButton;
@synthesize addButton;
@synthesize topBar;

typedef enum { ContactsAll, ContactsLinphone, ContactsMAX, ContactFavourite } ContactsCategory;

#pragma mark - UICompositeViewDelegate Functions

static UICompositeViewDescription *compositeDescription = nil;

+ (UICompositeViewDescription *)compositeViewDescription {
	if (compositeDescription == nil) {
		compositeDescription = [[UICompositeViewDescription alloc] init:self.class
															  statusBar:StatusBarView.class
																 tabBar:TabBarView.class
															   sideMenu:SideMenuView.class
															 fullscreen:false
														 isLeftFragment:YES
														   fragmentWith:ContactDetailsView.class];
	}
	return compositeDescription;
}

- (UICompositeViewDescription *)compositeViewDescription {
	return self.class.compositeViewDescription;
}

#pragma mark - ViewController Functions

- (void)viewDidLoad {
	[super viewDidLoad];
	tableController.tableView.accessibilityIdentifier = @"Contacts table";
	[self changeView:ContactsAll];
	/*if ([tableController totalNumberOfItems] == 0) {
		[self changeView:ContactsAll];
	 }*/
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
								   initWithTarget:self
								   action:@selector(dismissKeyboards)];
	
	[tap setDelegate:self];
	[self.view addGestureRecognizer:tap];
    
    //NumPadViewController * dialerView = [[NumPadViewController alloc] initWithNibName:@"NumPadViewController" bundle:nil];
    //dialerView.view.frame = self.keyboardView.bounds;
    _numpadView.frame = self.keyboardView.bounds;
    [self.keyboardView addSubview:_numpadView];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[ContactSelection setNameOrEmailFilter:@""];
	_searchBar.showsCancelButton = (_searchBar.text.length > 0);

	int y = _searchBar.frame.origin.y + _searchBar.frame.size.height;
	[tableController.tableView setFrame:CGRectMake(tableController.tableView.frame.origin.x,
												   y,
												   tableController.tableView.frame.size.width,
												   tableController.tableView.frame.size.height)];
	[tableController.emptyView setFrame:CGRectMake(tableController.emptyView.frame.origin.x,
												   y,
												   tableController.emptyView.frame.size.width,
												   tableController.emptyView.frame.size.height)];

	if (tableController.isEditing) {
		tableController.editing = NO;
	}
	[self refreshButtons];
	[_toggleSelectionButton setImage:[UIImage imageNamed:@"select_all_default.png"] forState:UIControlStateSelected];
	if ([LinphoneManager.instance lpConfigBoolForKey:@"hide_linphone_contacts" inSection:@"app"]) {
		self.linphoneButton.hidden = TRUE;
		self.selectedButtonImage.hidden = TRUE;
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if (![FastAddressBook isAuthorized]) {
		UIAlertController *errView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Address book", nil)
																		 message:NSLocalizedString(@"You must authorize the application to have access to address book.\n"
																								   "Toggle the application in Settings > Privacy > Contacts",
																								   nil)
																  preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Continue", nil)
																style:UIAlertActionStyleDefault
															  handler:^(UIAlertAction * action) {}];
		
		[errView addAction:defaultAction];
		[self presentViewController:errView animated:YES completion:nil];
		[PhoneMainView.instance popCurrentView];
	}
	
	// show message toast when add contact from address
	if ([ContactSelection getAddAddress] != nil && addAddressFromOthers) {
		UIAlertController *infoView = [UIAlertController
									   alertControllerWithTitle:NSLocalizedString(@"Info", nil)
									   message:NSLocalizedString(@"Select a contact or create a new one.",nil)
									   preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
																style:UIAlertActionStyleDefault
															  handler:^(UIAlertAction *action){
															  }];
		
		[infoView addAction:defaultAction];
		addAddressFromOthers = FALSE;
		[PhoneMainView.instance presentViewController:infoView animated:YES completion:nil];
	}
    
    [self darkmodeApplication];
}



- (void) viewWillDisappear:(BOOL)animated {
	self.view = NULL;
	[self.tableController removeAllContacts];
}


- (void) darkmodeApplication {
    
    if (@available(iOS 12.0, *)) {
        if( self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){
            [_oneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_twoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_threeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_fourButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_fiveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_sixButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_sevenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_eightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_nineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_zeroButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
           // [_swipeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_hashButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_starButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //_numberView.backgroundColor = [UIColor blackColor];
            //_swipeButton.backgroundColor = [UIColor blackColor];
            _addContactButton.backgroundColor = [UIColor blackColor];
            _callButton.backgroundColor = [UIColor blackColor];
            
            UIColor *textColor = [UIColor whiteColor];
            [_abcLabel setTextColor: textColor];
            [_defLabel setTextColor: textColor];
            [_ghiLabel setTextColor: textColor];
            [_jklLabel setTextColor: textColor];
            [_mnoLabel setTextColor: textColor];
            [_pqrsLabel setTextColor: textColor];
            [_tuvLabel setTextColor: textColor];
            [_wxyzlabel setTextColor: textColor];
            [_plusLabel setTextColor: textColor];
            

            NSDictionary *attributes = @{ NSForegroundColorAttributeName : textColor };
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:_addContactButton.titleLabel.text  attributes:attributes];
            
            [_addContactButton setAttributedTitle:attrStr forState:UIControlStateNormal];
        
            //[_padView setBackgroundColor:[UIColor blackColor]];
            //is dark
        }else{
            //is light
            [_oneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_twoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_threeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_fourButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_fiveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_sixButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_sevenButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_eightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_nineButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_zeroButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //[_swipeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_hashButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_callButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_starButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            //_swipeButton.backgroundColor = [UIColor whiteColor];
            _addContactButton.backgroundColor = [UIColor whiteColor];
            _callButton.backgroundColor = [UIColor whiteColor];
            
            UIColor *textColor = [UIColor blackColor];
            [_abcLabel setTextColor: textColor];
            [_defLabel setTextColor: textColor];
            [_ghiLabel setTextColor: textColor];
            [_jklLabel setTextColor: textColor];
            [_mnoLabel setTextColor: textColor];
            [_pqrsLabel setTextColor: textColor];
            [_tuvLabel setTextColor: textColor];
            [_wxyzlabel setTextColor: textColor];
            [_plusLabel setTextColor: textColor];
            
            
            [_addContactButton setTitleColor:textColor forState:UIControlStateNormal];
     
           // [_padView setBackgroundColor:[UIColor whiteColor]];
        }
        
        NSDictionary *grayColorAttributes = @{ NSForegroundColorAttributeName : [UIColor grayColor] };
        NSAttributedString *conferenceAttrStr = [[NSAttributedString alloc] initWithString:_addContactButton.titleLabel.text  attributes:grayColorAttributes];
        [_addContactButton setAttributedTitle:conferenceAttrStr forState:UIControlStateDisabled];
        
        //[self setAttributedButtonHighlightColor:_addContactButton];
        
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark -

- (void)changeView:(ContactsCategory)view {
	CGRect frame = _selectedButtonImage.frame;
	if (view == ContactsAll && !allButton.selected) {
		//REQUIRED TO RELOAD WITH FILTER
		[LinphoneManager.instance setContactsUpdated:TRUE];
		frame.origin.x = allButton.frame.origin.x;
		[ContactSelection setSipFilter:nil];
		[ContactSelection enableEmailFilter:FALSE];
        [ContactSelection setIdentifierFilter:FALSE];
		allButton.selected = TRUE;
		linphoneButton.selected = FALSE;
        _favouriteButton.selected = FALSE;
		[tableController loadData];
	} else if (view == ContactsLinphone && !linphoneButton.selected) {
		//REQUIRED TO RELOAD WITH FILTER
		[LinphoneManager.instance setContactsUpdated:TRUE];
		frame.origin.x = linphoneButton.frame.origin.x;
		[ContactSelection setSipFilter:LinphoneManager.instance.contactFilter];
		[ContactSelection enableEmailFilter:FALSE];
        [ContactSelection setIdentifierFilter:FALSE];
		linphoneButton.selected = TRUE;
		allButton.selected = FALSE;
        _favouriteButton.selected = FALSE;
		[tableController loadData];
    } else if (view == ContactFavourite && !_favouriteButton.selected) {
        //Filter contacts here
        frame.origin.x = _favouriteButton.frame.origin.x;
        linphoneButton.selected = FALSE;
        allButton.selected = FALSE;
        _favouriteButton.selected = TRUE;
        
        [LinphoneManager.instance setContactsUpdated:TRUE];
        [ContactSelection setSipFilter:nil];
        [ContactSelection enableEmailFilter:FALSE];
        [ContactSelection setIdentifierFilter:TRUE];
        [ContactSelection getIdentifierFilter];
        [tableController loadData];
    }
	_selectedButtonImage.frame = frame;
	if ([LinphoneManager.instance lpConfigBoolForKey:@"hide_linphone_contacts" inSection:@"app"]) {
		allButton.selected = FALSE;
	}
}

- (void)refreshButtons {
	[addButton setHidden:FALSE];
	[self changeView:[ContactSelection getSipFilter] ? ContactsLinphone : ContactsAll];
}

#pragma mark - Action Functions

- (IBAction)onAllClick:(id)event {
	[self changeView:ContactsAll];
}

- (IBAction)refreshAction:(UIButton *)sender {
    LinphoneAppDelegate* sharedDelegate = [LinphoneAppDelegate appDelegate];
    [sharedDelegate getUserStatus:TRUE];
}

- (IBAction)onLinphoneClick:(id)event {
	[self changeView:ContactsLinphone];
}

- (IBAction)onAddContactClick:(id)event {
	ContactDetailsView *view = VIEW(ContactDetailsView);
	[PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
	view.isAdding = TRUE;
	if ([ContactSelection getAddAddress] == nil) {
		[view newContact];
	} else {
		[view newContact:[ContactSelection getAddAddress]];
	}
}

- (IBAction)onDeleteClick:(id)sender {
	NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"Do you want to delete selected contacts?\nThey will also be deleted from your phone's address book.", nil)];
	[LinphoneManager.instance setContactsUpdated:TRUE];
	[UIConfirmationDialog ShowWithMessage:msg
		cancelMessage:nil
		confirmMessage:nil
		onCancelClick:^() {
		  [self onEditionChangeClick:nil];
		}
		onConfirmationClick:^() {
		  [tableController removeSelectionUsing:nil];
		  [tableController loadData];
		  [self onEditionChangeClick:nil];
		}];
}

- (IBAction)onEditionChangeClick:(id)sender {
	allButton.hidden = linphoneButton.hidden = _selectedButtonImage.hidden = addButton.hidden =	self.tableController.isEditing;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	searchBar.text = @"";
	[self searchBar:searchBar textDidChange:@""];
	[LinphoneManager.instance setContactsUpdated:TRUE];
	[tableController loadData];
	[searchBar resignFirstResponder];
}

- (void)dismissKeyboards {
	if ([self.searchBar isFirstResponder]){
		[self.searchBar resignFirstResponder];
	}
}

#pragma mark - searchBar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	// display searchtext in UPPERCASE
	// searchBar.text = [searchText uppercaseString];
	[ContactSelection setNameOrEmailFilter:searchText];
	if (searchText.length == 0) {
		[LinphoneManager.instance setContactsUpdated:TRUE];
		[tableController loadData];
	} else {
		[tableController loadSearchedData];
	}
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	[searchBar setShowsCancelButton:FALSE animated:TRUE];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	[searchBar setShowsCancelButton:TRUE animated:TRUE];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
}

#pragma mark - GestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	return NO;
}

- (IBAction)onAddressChange:(UITextField *)sender {
    [self addressChanged];
}
- (IBAction)onBackSpaceCLick:(UIButton *)sender {
    if ([_addressField.text length] > 0) {
        [_addressField setText:[_addressField.text substringToIndex:[_addressField.text length] - 1]];
    }
    [self addressChanged];
}

- (IBAction)onFavouriteAction:(UIButton *)sender {
    [self changeView:ContactFavourite];
}

- (void)setAddress:(NSString *)address {
    [_addressField setText:address];
}

- (IBAction)dialButtonAction:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    
    if(sender.isSelected) {
        //show keyboardview
        [self hideAnimation:FALSE forView:self.keyboardView completion:^(BOOL finished) {
            
        }];
    }
    else {
        //Hide keyboardview
        [self hideAnimation:TRUE forView:self.keyboardView completion:^(BOOL finished) {
           
        }];
    }
}


- (void)hideAnimation:(BOOL)hidden forView:(UIView *)target completion:(void (^)(BOOL finished))completion {
    if (hidden) {
    int original_y = target.frame.origin.y;
    CGRect newFrame = target.frame;
    newFrame.origin.y = self.view.frame.size.height;
    [UIView animateWithDuration:0.5
        delay:0.0
        options:UIViewAnimationOptionCurveEaseIn
        animations:^{
          target.frame = newFrame;
        
        CGRect newFrame = _dialButton.frame;
        int original_y = self.view.frame.size.height - 70;
        newFrame.origin.y = original_y;
        _dialButton.frame = newFrame;
        }
        completion:^(BOOL finished) {
          CGRect originFrame = target.frame;
          originFrame.origin.y = original_y;
          target.hidden = YES;
          target.frame = originFrame;
          if (completion)
              completion(finished);
        }];
    } else {
        CGRect frame = target.frame;
        int original_y = frame.origin.y;
        original_y = self.view.frame.size.height - frame.size.height;
        target.frame = frame;
        frame.origin.y = original_y;
        target.hidden = NO;

        [UIView animateWithDuration:0.5
            delay:0.0
            options:UIViewAnimationOptionCurveEaseOut
            animations:^{
              target.frame = frame;
            
            CGRect newFrame =  _dialButton.frame;
            int original_y = self.keyboardView.frame.origin.y - 70;
            newFrame.origin.y = original_y;
            _dialButton.frame = newFrame;
            
            }
            completion:^(BOOL finished) {
              target.frame = frame; // in case application did not finish
              if (completion)
                  completion(finished);
            }];
    }
}



- (IBAction)callButtonAction:(UIButton *)sender {
    NSString *address = _addressField.text;
    if (address.length == 0) {
        LinphoneCallLog *log = linphone_core_get_last_outgoing_call_log(LC);
        if (log) {
            const LinphoneAddress *to = linphone_call_log_get_to_address(log);
            const char *domain = linphone_address_get_domain(to);
            char *bis_address = NULL;
            LinphoneProxyConfig *def_proxy = linphone_core_get_default_proxy_config(LC);

            // if the 'to' address is on the default proxy, only present the username
            if (def_proxy) {
                const char *def_domain = linphone_proxy_config_get_domain(def_proxy);
                if (def_domain && domain && !strcmp(domain, def_domain)) {
                    bis_address = ms_strdup(linphone_address_get_username(to));
                }
            }
            if (bis_address == NULL) {
                bis_address = linphone_address_as_string_uri_only(to);
            }
            [_addressField setText:[NSString stringWithUTF8String:bis_address]];
            ms_free(bis_address);
            // return after filling the address, let the user confirm the call by pressing again
            return;
        }
    }

    if ([address length] > 0) {
        LinphoneAddress *addr = [LinphoneUtils normalizeSipOrPhoneAddress:address];
        [LinphoneManager.instance call:addr];
        if (addr)
            linphone_address_unref(addr);
    }
}

- (IBAction)addContactButonAction:(UIButton *)sender {
    [ContactSelection setSelectionMode:ContactSelectionModeEdit];
    [ContactSelection setAddAddress:[_addressField text]];
    [ContactSelection setSipFilter:nil];
    [ContactSelection setNameOrEmailFilter:nil];
    [ContactSelection enableEmailFilter:FALSE];
    [PhoneMainView.instance changeCurrentView:ContactsListView.compositeViewDescription];
}

- (IBAction)hashClick:(UIButton *)sender {
    NSString *address = [NSString stringWithFormat:@"%@#", _addressField.text];
    [_addressField setText: address];
    [self addressChanged];
}

- (IBAction)startClick:(UIButton *)sender {
    NSString *address = [NSString stringWithFormat:@"%@*", _addressField.text];
    [_addressField setText: address];
    [self addressChanged];
}

- (IBAction)digitClicked:(UIButton *)sender {
    NSString *address = [NSString stringWithFormat:@"%@%ld", _addressField.text, sender.tag];
    [_addressField setText: address];
    [self addressChanged];
}


-(void)addressChanged {
    _addContactButton.enabled = _backspaceButton.enabled = ([[_addressField text] length] > 0);
    _callButton.enabled = _addContactButton.enabled;
    if ([_addressField.text length] == 0) {
        [self.view endEditing:YES];
    }
    
    [self filterContacts];
}


-(void)filterContacts {
    
    NSString *searchText = _addressField.text;
    [ContactSelection setSipFilter:searchText];
    if (searchText.length == 0) {
        [LinphoneManager.instance setContactsUpdated:TRUE];
        [tableController loadData];
    } else {
        [tableController loadSIpFilteredData];
    }
}


@end
