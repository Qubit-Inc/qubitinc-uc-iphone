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

#import "TabBarView.h"
#import "PhoneMainView.h"
#import "UserListWithStatusView.h"
#import "VoiceMailViewController.h"

@implementation TabBarView

#pragma mark - ViewController Functions

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[NSNotificationCenter.defaultCenter addObserver:self
										   selector:@selector(changeViewEvent:)
											   name:kLinphoneMainViewChange
											 object:nil];
	[NSNotificationCenter.defaultCenter addObserver:self
										   selector:@selector(callUpdate:)
											   name:kLinphoneCallUpdate
											 object:nil];
	[NSNotificationCenter.defaultCenter addObserver:self
										   selector:@selector(messageReceived:)
											   name:kLinphoneMessageReceived
											 object:nil];
	[self update:FALSE];
    
    [self darkmodeApplication];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)didRotateFromInterfaceOrientation: (UIInterfaceOrientation)fromInterfaceOrientation {
	[self update:FALSE];
}

- (void) darkmodeApplication {
    
    if (@available(iOS 12.0, *)) {
        if( self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){
            UIColor *textColor = [UIColor whiteColor];

            NSDictionary *attributes = @{ NSForegroundColorAttributeName : textColor };
            
            NSAttributedString *statusAttrStr = [[NSAttributedString alloc] initWithString:_statusButton.titleLabel.text  attributes:attributes];
            [_statusButton setAttributedTitle:statusAttrStr forState:UIControlStateNormal];
            
            NSAttributedString *historyAttrStr = [[NSAttributedString alloc] initWithString:_historyButton.titleLabel.text  attributes:attributes];
            [_historyButton setAttributedTitle:historyAttrStr forState:UIControlStateNormal];
            
            NSAttributedString *contactAttrStr = [[NSAttributedString alloc] initWithString:_contactsButton.titleLabel.text  attributes:attributes];
            [_contactsButton setAttributedTitle:contactAttrStr forState:UIControlStateNormal];
            
            NSAttributedString *dialerAttrStr = [[NSAttributedString alloc] initWithString:_dialerButton.titleLabel.text  attributes:attributes];
            [_dialerButton setAttributedTitle:dialerAttrStr forState:UIControlStateNormal];
            
            NSAttributedString *chatAttrStr = [[NSAttributedString alloc] initWithString:_chatButton.titleLabel.text  attributes:attributes];
            [_chatButton setAttributedTitle:chatAttrStr forState:UIControlStateNormal];
            
        }
    }
}

#pragma mark - Event Functions

- (void)callUpdate:(NSNotification *)notif {
	// LinphoneCall *call = [[notif.userInfo objectForKey: @"call"] pointerValue];
	// LinphoneCallState state = [[notif.userInfo objectForKey: @"state"] intValue];
	[self updateMissedCall:linphone_core_get_missed_calls_count(LC) appear:TRUE];
}

- (void)changeViewEvent:(NSNotification *)notif {
	UICompositeViewDescription *view = [notif.userInfo objectForKey:@"view"];
	if (view != nil) {
		[self updateSelectedButton:view];
	}
}

- (void)messageReceived:(NSNotification *)notif {
	[self updateUnreadMessage:TRUE];
}

#pragma mark - UI Update

- (void)update:(BOOL)appear {
	[self updateSelectedButton:[PhoneMainView.instance currentView]];
	[self updateMissedCall:linphone_core_get_missed_calls_count(LC) appear:appear];
	[self updateUnreadMessage:appear];
}

- (void)updateUnreadMessage:(BOOL)appear {
	int unreadMessage = [LinphoneManager unreadMessageCount];
	if (unreadMessage > 0) {
		_chatNotificationLabel.text = [NSString stringWithFormat:@"%i", unreadMessage];
		[_chatNotificationView startAnimating:appear];
	} else {
		[_chatNotificationView stopAnimating:appear];
	}
}

- (void)updateMissedCall:(int)missedCall appear:(BOOL)appear {
	if (missedCall > 0) {
		_historyNotificationLabel.text = [NSString stringWithFormat:@"%i", missedCall];
		[_historyNotificationView startAnimating:appear];
	} else {
		[_historyNotificationView stopAnimating:appear];
	}
}

- (void) updateLabelColor {
    UIColor *defaultColor = UIColor.blackColor;
    if (@available(iOS 12.0, *)) {
        if( self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){
            defaultColor = [UIColor whiteColor];
        }
    }
    _labelChats.textColor = _chatButton.isSelected ? LINPHONE_MAIN_COLOR : defaultColor;
    _labelKeypad.textColor = _dialerButton.isSelected ? LINPHONE_MAIN_COLOR : defaultColor;
    _labelContacts.textColor = _contactsButton.isSelected ? LINPHONE_MAIN_COLOR : defaultColor;
    _labelHistory.textColor = _historyButton.isSelected ? LINPHONE_MAIN_COLOR : defaultColor;
    _labelStatus.textColor = _statusButton.isSelected ? LINPHONE_MAIN_COLOR : defaultColor;
    
}
- (void)updateSelectedButton:(UICompositeViewDescription *)view {
        
    _statusButton.selected = [view equal:UserListWithStatusView.compositeViewDescription];

	_historyButton.selected = [view equal:HistoryListView.compositeViewDescription] ||
							  [view equal:HistoryDetailsView.compositeViewDescription];
	_contactsButton.selected = [view equal:ContactsListView.compositeViewDescription] ||
							   [view equal:ContactDetailsView.compositeViewDescription];
	_dialerButton.selected = [view equal:DialerView.compositeViewDescription];
	_chatButton.selected = [view equal:ChatsListView.compositeViewDescription] ||
						   [view equal:ChatConversationCreateView.compositeViewDescription] ||
						   [view equal:ChatConversationInfoView.compositeViewDescription] ||
						   [view equal:ChatConversationImdnView.compositeViewDescription] ||
						   [view equal:ChatConversationView.compositeViewDescription];
    
    [self updateLabelColor];
	CGRect selectedNewFrame = _selectedButtonImage.frame;
	if ([self viewIsCurrentlyPortrait]) {
        
		selectedNewFrame.origin.x =
			(_statusButton.selected
             ? _statusButton.frame.origin.x
             : _historyButton.selected
				 ? _historyButton.frame.origin.x
				 : (_contactsButton.selected
						? _contactsButton.frame.origin.x
						: (_dialerButton.selected
							   ? _dialerButton.frame.origin.x
							   : (_chatButton.selected
									  ? _chatButton.frame.origin.x
									  : -selectedNewFrame.size.width /*hide it if none is selected*/))));
	} else {
		selectedNewFrame.origin.y =
			(_statusButton.selected
             ? _statusButton.frame.origin.y
             : _historyButton.selected
				 ? _historyButton.frame.origin.y
				 : (_contactsButton.selected
						? _contactsButton.frame.origin.y
						: (_dialerButton.selected
							   ? _dialerButton.frame.origin.y
							   : (_chatButton.selected
									  ? _chatButton.frame.origin.y
									  : -selectedNewFrame.size.height /*hide it if none is selected*/))));
	}

	CGFloat delay = ANIMATED ? 0.3 : 0;
	[UIView animateWithDuration:delay
					 animations:^{
					   _selectedButtonImage.frame = selectedNewFrame;

					 }];
}

#pragma mark - Action Functions

- (IBAction)onHistoryClick:(id)event {
	linphone_core_reset_missed_calls_count(LC);
	[self update:FALSE];
	[PhoneMainView.instance updateApplicationBadgeNumber];
	[PhoneMainView.instance changeCurrentView:HistoryListView.compositeViewDescription];
}

- (IBAction)onStatusButtonClick:(id)sender {
    
    [PhoneMainView.instance changeCurrentView:UserListWithStatusView.compositeViewDescription];
}

- (IBAction)onContactsClick:(id)event {
	[ContactSelection setAddAddress:nil];
	[ContactSelection enableEmailFilter:FALSE];
	[ContactSelection setNameOrEmailFilter:nil];
	[PhoneMainView.instance changeCurrentView:ContactsListView.compositeViewDescription];
}

- (IBAction)onDialerClick:(id)event {
	[PhoneMainView.instance changeCurrentView:DialerView.compositeViewDescription];
}

- (IBAction)onSettingsClick:(id)event {
	[PhoneMainView.instance changeCurrentView:SettingsView.compositeViewDescription];
}

- (IBAction)onChatClick:(id)event {
	[PhoneMainView.instance changeCurrentView:ChatsListView.compositeViewDescription];
}

- (IBAction)voiceMailAction:(UIButton *)sender {
//    [PhoneMainView.instance changeCurrentView:VoiceMailViewController .compositeViewDescription];
//voice mail changed to setting
            SettingsView* settingsController =[[SettingsView alloc] initWithNibName:@"SettingsView" bundle:nil];
            [PhoneMainView.instance presentView:settingsController];
}
@end
