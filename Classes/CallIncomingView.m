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

#import "CallIncomingView.h"
#import "LinphoneManager.h"
#import "FastAddressBook.h"
#import "PhoneMainView.h"
#import "Utils.h"

@interface CallIncomingView ()
@property(nonatomic, strong)UIAlertAction *sendAction;

@end

@implementation CallIncomingView

#pragma mark - ViewController Functions

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[NSNotificationCenter.defaultCenter addObserver:self
										   selector:@selector(callUpdateEvent:)
											   name:kLinphoneCallUpdate
											 object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[NSNotificationCenter.defaultCenter removeObserver:self name:kLinphoneCallUpdate object:nil];
	_call = NULL;
}

#pragma mark - UICompositeViewDelegate Functions

static UICompositeViewDescription *compositeDescription = nil;

+ (UICompositeViewDescription *)compositeViewDescription {
	if (compositeDescription == nil) {
		compositeDescription = [[UICompositeViewDescription alloc] init:self.class
															  statusBar:StatusBarView.class
																 tabBar:nil
															   sideMenu:CallSideMenuView.class
															 fullscreen:false
														 isLeftFragment:YES
														   fragmentWith:nil];
		compositeDescription.darkBackground = true;
	}
	return compositeDescription;
}

- (UICompositeViewDescription *)compositeViewDescription {
	return self.class.compositeViewDescription;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	if (_earlyMedia && [LinphoneManager.instance lpConfigBoolForKey:@"pref_accept_early_media"] && linphone_core_get_calls_nb(LC) < 2) {
		_earlyMediaView.hidden = NO;
		linphone_core_set_native_video_window_id(LC, (__bridge void *)(_earlyMediaView));
	}
	if (_call) {
		[self update];
	}
}

#pragma mark - Event Functions

- (void)callUpdateEvent:(NSNotification *)notif {
	LinphoneCall *acall = [[notif.userInfo objectForKey:@"call"] pointerValue];
	LinphoneCallState astate = [[notif.userInfo objectForKey:@"state"] intValue];
	[self callUpdate:acall state:astate];
}

- (void)callUpdate:(LinphoneCall *)acall state:(LinphoneCallState)astate {
	if (_call == acall && (astate == LinphoneCallEnd || astate == LinphoneCallError)) {
		[_delegate incomingCallAborted:_call];
	} else if ([LinphoneManager.instance lpConfigBoolForKey:@"auto_answer"]) {
		LinphoneCallState state = linphone_call_get_state(_call);
		if (state == LinphoneCallIncomingReceived) {
			LOGI(@"Auto answering call");
			[self onAcceptClick:nil];
		}
	}
}

#pragma mark -

- (void)update {
	const LinphoneAddress *addr = linphone_call_get_remote_address(_call);
	[ContactDisplay setDisplayNameLabel:_nameLabel forAddress:addr withAddressLabel:_addressLabel];
	char *uri = linphone_address_as_string_uri_only(addr);
	ms_free(uri);
	[_avatarImage setImage:[FastAddressBook imageForAddress:addr] bordered:YES withRoundedRadius:YES];

	_tabBar.hidden = linphone_call_params_video_enabled(linphone_call_get_remote_params(_call));
	_tabVideoBar.hidden = !_tabBar.hidden;
}

#pragma mark - Property Functions
static void hideSpinner(LinphoneCall *call, void *user_data) {
	CallIncomingView *thiz = (__bridge CallIncomingView *)user_data;
	thiz.earlyMedia = TRUE;
	thiz.earlyMediaView.hidden = NO;
	linphone_core_set_native_video_window_id(LC, (__bridge void *)(thiz.earlyMediaView));
}

- (void)setCall:(LinphoneCall *)call {
	_call = call;
	_earlyMedia = FALSE;
	if ([LinphoneManager.instance lpConfigBoolForKey:@"pref_accept_early_media"] && linphone_core_get_calls_nb(LC) < 2) {
		linphone_call_accept_early_media(_call);
		// linphone_call_params_get_used_video_codec return 0 if no video stream enabled
		if (linphone_call_params_get_used_video_codec(linphone_call_get_current_params(_call))) {
			linphone_call_set_next_video_frame_decoded_callback(call, hideSpinner, (__bridge void *)(self));
		}
	} else {
		_earlyMediaView.hidden = YES;
	}
	
	[self update];
	[self callUpdate:_call state:linphone_call_get_state(call)];
}

#pragma mark - Action Functions

- (IBAction)onAcceptClick:(id)event {
	[_delegate incomingCallAccepted:_call evenWithVideo:YES];
}

- (IBAction)onDeclineClick:(id)event {
	[_delegate incomingCallDeclined:_call];
}

- (IBAction)declineWithMessage:(UIButton *)sender {
    
    NSArray *options = [[NSArray alloc] initWithObjects: @"Can't talk now. What's up?", @"I'll call you right back.", @"I'll call you later", @"Can't talk now. Call me later?", @"Write your own...", nil];
    
    BSDropDown *ddView=[[BSDropDown alloc] initWithWidth:250 withHeightForEachRow:50 originPoint:sender.center withOptions:options];
    ddView.delegate=self;
    if (@available(iOS 13.0, *)) {
        ddView.dropDownBGColor=[UIColor systemBackgroundColor];
        ddView.dropDownTextColor=[UIColor labelColor];
    } else {
        ddView.dropDownBGColor=[UIColor whiteColor];
        ddView.dropDownTextColor=[UIColor blackColor];
    }
    //    ddView.dropDownFont=[UIFont systemFontOfSize:13];
    [self.view addSubview:ddView];
}

- (IBAction)onAcceptAudioOnlyClick:(id)sender {
	[_delegate incomingCallAccepted:_call evenWithVideo:NO];
}


#pragma mark - DropDown Delegate
-(void)dropDownView:(UIView *)ddView AtIndex:(NSInteger)selectedIndex{
    NSLog(@"selectedIndex: %li",(long)selectedIndex);
    NSArray *options = [[NSArray alloc] initWithObjects: @"Can't talk now. What's up?",@"I'll call you right back.", @"I'll call you later",@"Can't talk now. Call me later?",@"Write your own...", nil];
    
    if(selectedIndex == 4) {
        [self showCustomMessageAlert];
    }
    else
        [_delegate incomingCallDeclined:_call];
}


-(void)showCustomMessageAlert {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @""
                                                                              message: @""
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Write your own...";
        if (@available(iOS 13.0, *)) {
            textField.textColor = [UIColor labelColor];
        } else {
            // Fallback on earlier versions
            textField.textColor = [UIColor blackColor];
        }
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.delegate = self;
    }];
    
     [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    
    self.sendAction = [UIAlertAction actionWithTitle:@"Send" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        NSLog(@"%@",namefield.text);
    }];
    [alertController addAction:self.sendAction];
    self.sendAction.enabled = NO;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self.sendAction setEnabled:(finalString.length >= 1)];
    return YES;
}

@end
