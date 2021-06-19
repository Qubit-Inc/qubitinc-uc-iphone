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

#import <AudioToolbox/AudioToolbox.h>

#import "LinphoneManager.h"
#import "PhoneMainView.h"

@implementation DialerView

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
														   fragmentWith:nil];
		compositeDescription.darkBackground = true;
	}
	return compositeDescription;
}

- (UICompositeViewDescription *)compositeViewDescription {
	return self.class.compositeViewDescription;
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
            [_swipeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_videoCallButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_hashButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_starButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _numberView.backgroundColor = [UIColor blackColor];
            _swipeButton.backgroundColor = [UIColor blackColor];
            _addContactButton.backgroundColor = [UIColor blackColor];
            _callButton.backgroundColor = [UIColor blackColor];
            _videoCallButton.backgroundColor = [UIColor blackColor];
            
            UIColor *textColor = [UIColor whiteColor];
            [_lbl2 setTextColor: textColor];
            [_lbl3 setTextColor: textColor];
            [_lbl4 setTextColor: textColor];
            [_lbl5 setTextColor: textColor];
            [_lbl6 setTextColor: textColor];
            [_lbl7 setTextColor: textColor];
            [_lbl8 setTextColor: textColor];
            [_lbl9 setTextColor: textColor];
            [_lblPlus setTextColor: textColor];
            

            NSDictionary *attributes = @{ NSForegroundColorAttributeName : textColor };
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:_addContactButton.titleLabel.text  attributes:attributes];
            
            [_addContactButton setAttributedTitle:attrStr forState:UIControlStateNormal];
        
            [_padView setBackgroundColor:[UIColor blackColor]];
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
            [_swipeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_hashButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_callButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_videoCallButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_starButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            _swipeButton.backgroundColor = [UIColor whiteColor];
            _addContactButton.backgroundColor = [UIColor whiteColor];
            _callButton.backgroundColor = [UIColor whiteColor];
            _videoCallButton.backgroundColor = [UIColor whiteColor];
            
            UIColor *textColor = [UIColor blackColor];
            [_lbl2 setTextColor: textColor];
            [_lbl3 setTextColor: textColor];
            [_lbl4 setTextColor: textColor];
            [_lbl5 setTextColor: textColor];
            [_lbl6 setTextColor: textColor];
            [_lbl7 setTextColor: textColor];
            [_lbl8 setTextColor: textColor];
            [_lbl9 setTextColor: textColor];
            [_lblPlus setTextColor: textColor];
            
            [_addContactButton setTitleColor:textColor forState:UIControlStateNormal];
     
            [_padView setBackgroundColor:[UIColor whiteColor]];
        }
        
        NSDictionary *grayColorAttributes = @{ NSForegroundColorAttributeName : [UIColor grayColor] };
        NSAttributedString *conferenceAttrStr = [[NSAttributedString alloc] initWithString:_addContactButton.titleLabel.text  attributes:grayColorAttributes];
        [_addContactButton setAttributedTitle:conferenceAttrStr forState:UIControlStateDisabled];
        
        //[self setAttributedButtonHighlightColor:_addContactButton];
        
    } else {
        // Fallback on earlier versions
    }
    
  
}

-(void) adjustButtonLabelsSize {
    CGFloat size = _oneButton.frame.size.width / 5;
    [self setButttonsFontSize:_oneButton size: size];
    [self setButttonsFontSize: _twoButton size: size];
    [self setButttonsFontSize: _threeButton size: size];
    [self setButttonsFontSize: _fourButton size: size];
    [self setButttonsFontSize:_fiveButton size: size];
    [self setButttonsFontSize: _sixButton size: size];
    [self setButttonsFontSize: _sevenButton size: size];
    [self setButttonsFontSize: _eightButton size: size];
    [self setButttonsFontSize:_nineButton size: size];
    [self setButttonsFontSize: _starButton size: size * 1.3];
    [self setButttonsFontSize: _zeroButton size: size];
    [self setButttonsFontSize: _callButton size: size];
    [self setButttonsFontSize: _videoCallButton size: size];
    [self setButttonsFontSize: _swipeButton size: size * 0.9];
    [self setButttonsFontSize: _hashButton size: size];
    
    _addressField.font = [UIFont systemFontOfSize: _oneButton.frame.size.width / 5];
    [self adjustLabelLabelsSize];
   
}

-(void) adjustLabelLabelsSize {
    CGFloat labelFontSize = _abcLabel.frame.size.width / 30;

    _abcLabel.font = [UIFont systemFontOfSize:labelFontSize];
    _defLabel.font = [UIFont systemFontOfSize:labelFontSize];
    _ghiLabel.font = [UIFont systemFontOfSize:labelFontSize];
    _jklLabel.font = [UIFont systemFontOfSize:labelFontSize];
    _mnoLabel.font = [UIFont systemFontOfSize:labelFontSize];
    _pqrsLabel.font = [UIFont systemFontOfSize:labelFontSize];
    _tuvLabel.font = [UIFont systemFontOfSize:labelFontSize];
    _wxyzlabel.font = [UIFont systemFontOfSize:labelFontSize];
    _plusLabel.font = [UIFont systemFontOfSize:labelFontSize * 1.3];
}


-(void) setButttonsFontSize:(UIButton*) button size:(CGFloat) size {
    //CGFloat size = button.frame.size.width / 5;
    [button.titleLabel setFont: [button.titleLabel.font fontWithSize: size]];
}


- (void)setAttributedButtonHighlightColor:(UIButton*) button {
    
    NSDictionary *grayColorAttributes = @{ NSForegroundColorAttributeName :  [UIColor colorWithRed:197.0f / 255.0f green:197.0f / 255.0f blue:197.0f / 255.0f alpha:1.0f] };
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:button.titleLabel.text  attributes:grayColorAttributes];
    [button setAttributedTitle:attrStr forState:UIControlStateHighlighted];
    
}


- (void)viewDidDisappear:(BOOL)animated {
      [self darkmodeApplication];
}

#pragma mark - ViewController Functions

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	_padView.hidden =
		!IPAD && UIInterfaceOrientationIsLandscape(PhoneMainView.instance.mainViewController.currentOrientation);

	// Set observer
	[NSNotificationCenter.defaultCenter addObserver:self
										   selector:@selector(callUpdateEvent:)
											   name:kLinphoneCallUpdate
											 object:nil];

	[NSNotificationCenter.defaultCenter addObserver:self
										   selector:@selector(coreUpdateEvent:)
											   name:kLinphoneCoreUpdate
											 object:nil];

	// Update on show
	LinphoneManager *mgr = LinphoneManager.instance;
	LinphoneCall *call = linphone_core_get_current_call(LC);
	LinphoneCallState state = (call != NULL) ? linphone_call_get_state(call) : 0;
	[self callUpdate:call state:state];

	if (IPAD) {
		BOOL videoEnabled = linphone_core_video_display_enabled(LC);
		BOOL previewPref = [mgr lpConfigBoolForKey:@"preview_preference"];

		if (videoEnabled && previewPref) {
			linphone_core_set_native_preview_window_id(LC, (__bridge void *)(_videoPreview));

			if (!linphone_core_video_preview_enabled(LC)) {
				linphone_core_enable_video_preview(LC, TRUE);
			}

			[_backgroundView setHidden:FALSE];
			[_videoCameraSwitch setHidden:FALSE];
		} else {
			linphone_core_set_native_preview_window_id(LC, NULL);
			linphone_core_enable_video_preview(LC, FALSE);
			[_backgroundView setHidden:TRUE];
			[_videoCameraSwitch setHidden:TRUE];
		}
	} else {
		linphone_core_enable_video_preview(LC, FALSE);
	}
	[_addressField setText:@""];
    //[self setFontSize];
    [self adjustButtonLabelsSize];
    [self darkmodeApplication];
}

//- (void)setFontSize{
//
//    double buttonFontSize = _fiveButton.frame.size.height * 0.3;
//    _oneButton.titleLabel.font = [UIFont systemFontOfSize:buttonFontSize];
//    _twoButton.titleLabel.font = [UIFont systemFontOfSize:buttonFontSize];
//    _threeButton.titleLabel.font = [UIFont systemFontOfSize:buttonFontSize];
//    _fiveButton.titleLabel.font = [UIFont systemFontOfSize:buttonFontSize];
//    _fourButton.titleLabel.font = [UIFont systemFontOfSize:buttonFontSize];
//    _sixButton.titleLabel.font = [UIFont systemFontOfSize:buttonFontSize];
//    _sevenButton.titleLabel.font = [UIFont systemFontOfSize:buttonFontSize];
//    _eightButton.titleLabel.font = [UIFont systemFontOfSize:buttonFontSize];
//    _nineButton.titleLabel.font = [UIFont systemFontOfSize:buttonFontSize];
//    _starButton.titleLabel.font = [UIFont systemFontOfSize:buttonFontSize * 1.7];
//    _zeroButton.titleLabel.font = [UIFont systemFontOfSize:buttonFontSize];
//    _hashButton.titleLabel.font = [UIFont systemFontOfSize:buttonFontSize];
//
//
//    _callButton.titleLabel.font = [UIFont fontWithName:@"Wingdings" size:buttonFontSize * 1.7];
//    _swipeButton.titleLabel.font = [UIFont fontWithName:@"Wingdings3" size:buttonFontSize * 1.7];
//
//    _addressField.font = [UIFont systemFontOfSize:buttonFontSize * 1.3];
//
//    double labelFontSize = (_fiveButton.frame.size.height * 0.3) * 0.32;
//    _abcLabel.font = [UIFont systemFontOfSize:labelFontSize];
//    _defLabel.font = [UIFont systemFontOfSize:labelFontSize];
//    _ghiLabel.font = [UIFont systemFontOfSize:labelFontSize];
//    _jklLabel.font = [UIFont systemFontOfSize:labelFontSize];
//    _mnoLabel.font = [UIFont systemFontOfSize:labelFontSize];
//    _pqrsLabel.font = [UIFont systemFontOfSize:labelFontSize];
//    _tuvLabel.font = [UIFont systemFontOfSize:labelFontSize];
//    _wxyzlabel.font = [UIFont systemFontOfSize:labelFontSize];
//    _plusLabel.font = [UIFont systemFontOfSize:labelFontSize];
//}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[_zeroButton setDigit:'0'];
	[_oneButton setDigit:'1'];
	[_twoButton setDigit:'2'];
	[_threeButton setDigit:'3'];
	[_fourButton setDigit:'4'];
	[_fiveButton setDigit:'5'];
	[_sixButton setDigit:'6'];
	[_sevenButton setDigit:'7'];
	[_eightButton setDigit:'8'];
	[_nineButton setDigit:'9'];
	[_starButton setDigit:'*'];
	[_hashButton setDigit:'#'];
    

	[_addressField setAdjustsFontSizeToFitWidth:TRUE]; // Not put it in IB: issue with placeholder size

	UILongPressGestureRecognizer *backspaceLongGesture =
		[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onBackspaceLongClick:)];
	[_backspaceButton addGestureRecognizer:backspaceLongGesture];

	UILongPressGestureRecognizer *zeroLongGesture =
		[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onZeroLongClick:)];
	[_zeroButton addGestureRecognizer:zeroLongGesture];

	UILongPressGestureRecognizer *oneLongGesture =
		[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onOneLongClick:)];
	[_oneButton addGestureRecognizer:oneLongGesture];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
																					initWithTarget:self
																					action:@selector(dismissKeyboards)];
	
	[self.view addGestureRecognizer:tap];

	if (IPAD) {
		if (LinphoneManager.instance.frontCamId != nil) {
			// only show camera switch button if we have more than 1 camera
			[_videoCameraSwitch setHidden:FALSE];
		}
	}
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(darkmodeApplication)
                                               name:@"applicationDidBecomeActive"
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(onstartVideoPreferenceUpdated:)
                                               name: @"startVideoPreference"
                                             object:nil];
//    [NSNotificationCenter.defaultCenter addObserver:self
//                                           selector:@selector(onDNDCallForwardOptionChanged:)
//                                               name: @"accept_video_preference"
//                                             object:nil];
    
}

- (void)onstartVideoPreferenceUpdated:(NSNotification *)notif {
    NSLog(@" onstartVideoPreferenceUpdated" );
    [self updateCallButton];
}

- (void) updateCallButton {
    BOOL showVideoIcon = [[NSUserDefaults standardUserDefaults] boolForKey:@"startVideoPreference"] ?: FALSE;
    
    NSLog(@"SHow Video icon %@", showVideoIcon ? @"True" : @"False");
    
    [_videoCallButton setHidden:!showVideoIcon];
    [_callButton setHidden: showVideoIcon];
        
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
										 duration:(NSTimeInterval)duration {
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	switch (toInterfaceOrientation) {
		case UIInterfaceOrientationPortrait:
			[_videoPreview setTransform:CGAffineTransformMakeRotation(0)];
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			[_videoPreview setTransform:CGAffineTransformMakeRotation(M_PI)];
			break;
		case UIInterfaceOrientationLandscapeLeft:
			[_videoPreview setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
			break;
		case UIInterfaceOrientationLandscapeRight:
			[_videoPreview setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
			break;
		default:
			break;
	}
	CGRect frame = self.view.frame;
	frame.origin = CGPointMake(0, 0);
	_videoPreview.frame = frame;
	_padView.hidden = !IPAD && UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
	if (linphone_core_get_calls_nb(LC)) {
		_backButton.hidden = FALSE;
		_addContactButton.hidden = TRUE;
	} else {
		_backButton.hidden = TRUE;
		_addContactButton.hidden = FALSE;
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    [self darkmodeApplication];
	[LinphoneManager.instance shouldPresentLinkPopup];
    LinphoneAppDelegate* sharedDelegate = [LinphoneAppDelegate appDelegate];
    [sharedDelegate getUserStatus:FALSE];
    
    [self updateCallButton];
}

#pragma mark - Event Functions

- (void)callUpdateEvent:(NSNotification *)notif {
	LinphoneCall *call = [[notif.userInfo objectForKey:@"call"] pointerValue];
	LinphoneCallState state = [[notif.userInfo objectForKey:@"state"] intValue];
	[self callUpdate:call state:state];
}

- (void)coreUpdateEvent:(NSNotification *)notif {
	@try {
		if (IPAD) {
			if (linphone_core_video_display_enabled(LC) && linphone_core_video_preview_enabled(LC)) {
				linphone_core_set_native_preview_window_id(LC, (__bridge void *)(_videoPreview));
				[_backgroundView setHidden:FALSE];
				[_videoCameraSwitch setHidden:FALSE];
			} else {
				linphone_core_set_native_preview_window_id(LC, NULL);
				[_backgroundView setHidden:TRUE];
				[_videoCameraSwitch setHidden:TRUE];
			}
		}
	} @catch (NSException *exception) {
		if ([exception.name isEqualToString:@"LinphoneCoreException"]) {
			LOGE(@"Core already destroyed");
			return;
		}
		LOGE(@"Uncaught exception : %@", exception.description);
		abort();
	}
}

#pragma mark - Debug Functions
- (void)presentMailViewWithTitle:(NSString *)subject forRecipients:(NSArray *)recipients attachLogs:(BOOL)attachLogs {
	if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
		if (controller) {
			controller.mailComposeDelegate = self;
			[controller setSubject:subject];
			[controller setToRecipients:recipients];

			if (attachLogs) {
				char *filepath = linphone_core_compress_log_collection();
				if (filepath == NULL) {
					LOGE(@"Cannot sent logs: file is NULL");
					return;
				}

				NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
				NSString *filename = [appName stringByAppendingString:@".gz"];
				NSString *mimeType = @"text/plain";

				if ([filename hasSuffix:@".gz"]) {
					mimeType = @"application/gzip";
					filename = [appName stringByAppendingString:@".gz"];
				} else {
					LOGE(@"Unknown extension type: %@, cancelling email", filename);
					return;
				}
				[controller setMessageBody:NSLocalizedString(@"Application logs", nil) isHTML:NO];
				[controller addAttachmentData:[NSData dataWithContentsOfFile:[NSString stringWithUTF8String:filepath]]
									 mimeType:mimeType
									 fileName:filename];

				ms_free(filepath);
			}
			self.modalPresentationStyle = UIModalPresentationPageSheet;
			[self.view.window.rootViewController presentViewController:controller
															  animated:TRUE
															completion:^{
															}];
		}

	} else {
		UIAlertController *errView = [UIAlertController alertControllerWithTitle:subject
																		 message:NSLocalizedString(@"Error: no mail account configured",
																								   nil)
																  preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
																style:UIAlertActionStyleDefault
															  handler:^(UIAlertAction * action) {}];
		
		[errView addAction:defaultAction];
		[self presentViewController:errView animated:YES completion:nil];
	}
}

- (BOOL)displayDebugPopup:(NSString *)address {
	LinphoneManager *mgr = LinphoneManager.instance;
	NSString *debugAddress = [mgr lpConfigStringForKey:@"debug_popup_magic" withDefault:@""];
	if (![debugAddress isEqualToString:@""] && [address isEqualToString:debugAddress]) {
		UIAlertController *errView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Debug", nil)
																		 message:NSLocalizedString(@"Choose an action", nil)
																  preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
																style:UIAlertActionStyleDefault
															  handler:^(UIAlertAction * action) {}];
		
		[errView addAction:defaultAction];

		int debugLevel = [LinphoneManager.instance lpConfigIntForKey:@"debugenable_preference"];
		BOOL debugEnabled = (debugLevel >= ORTP_DEBUG && debugLevel < ORTP_ERROR);

		if (debugEnabled) {
			UIAlertAction* continueAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Send logs", nil)
																	 style:UIAlertActionStyleDefault
																   handler:^(UIAlertAction * action) {
																	   NSString *appName =
																	   [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
																	   NSString *logsAddress = [mgr lpConfigStringForKey:@"debug_popup_email" withDefault:@""];
																	   [self presentMailViewWithTitle:appName forRecipients:@[ logsAddress ] attachLogs:true];
																   }];
			[errView addAction:continueAction];
		}
		NSString *actionLog =
			(debugEnabled ? NSLocalizedString(@"Disable logs", nil) : NSLocalizedString(@"Enable logs", nil));
		
		UIAlertAction* logAction = [UIAlertAction actionWithTitle:actionLog
															style:UIAlertActionStyleDefault
														  handler:^(UIAlertAction * action) {
																   int newDebugLevel = debugEnabled ? 0 : ORTP_DEBUG;
																   [LinphoneManager.instance lpConfigSetInt:newDebugLevel forKey:@"debugenable_preference"];
																   [Log enableLogs:newDebugLevel];
															   }];
		[errView addAction:logAction];
		
		UIAlertAction* remAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Remove account(s) and self destruct", nil)
															style:UIAlertActionStyleDefault
														  handler:^(UIAlertAction * action) {
															  linphone_core_clear_proxy_config([LinphoneManager getLc]);
															  linphone_core_clear_all_auth_info([LinphoneManager getLc]);
															  @try {
																  [LinphoneManager.instance destroyLinphoneCore];
															  } @catch (NSException *e) {
																  LOGW(@"Exception while destroying linphone core: %@", e);
															  } @finally {
																  if ([NSFileManager.defaultManager
																	   isDeletableFileAtPath:[LinphoneManager preferenceFile:@"linphonerc"]] == YES) {
																	  [NSFileManager.defaultManager
																	   removeItemAtPath:[LinphoneManager preferenceFile:@"linphonerc"]
																	   error:nil];
																  }
#ifdef DEBUG
																  [LinphoneManager instanceRelease];
#endif
															  }
															  [UIApplication sharedApplication].keyWindow.rootViewController = nil;
															  // make the application crash to be sure that user restart it properly
															  LOGF(@"Self-destructing in 3..2..1..0!");
														  }];
		[errView addAction:remAction];
		
		[self presentViewController:errView animated:YES completion:nil];
		return true;
	}
	return false;
}

#pragma mark -

- (void)callUpdate:(LinphoneCall *)call state:(LinphoneCallState)state {
	BOOL callInProgress = (linphone_core_get_calls_nb(LC) > 0);
	_addContactButton.hidden = callInProgress;
	_backButton.hidden = !callInProgress;
	//[_callButton updateIcon];
}

- (IBAction)onCallButtonClick:(UIButton *)sender {
    
}

- (void)setAddress:(NSString *)address {
	[_addressField setText:address];
}

#pragma mark - UITextFieldDelegate Functions

- (BOOL)textField:(UITextField *)textField
	shouldChangeCharactersInRange:(NSRange)range
				replacementString:(NSString *)string {
	//[textField performSelector:@selector() withObject:nil afterDelay:0];
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == _addressField) {
		[_addressField resignFirstResponder];
	}
	if (textField.text.length > 0) {
		LinphoneAddress *addr = [LinphoneUtils normalizeSipOrPhoneAddress:textField.text];
		[LinphoneManager.instance call:addr];
		if (addr)
			linphone_address_destroy(addr);
	}
	return YES;
}

#pragma mark - MFComposeMailDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError *)error {
	[controller dismissViewControllerAnimated:TRUE completion:nil];
	[self.navigationController setNavigationBarHidden:TRUE animated:FALSE];
}

#pragma mark - Action Functions

- (IBAction)onAddContactClick:(id)event {
	[ContactSelection setSelectionMode:ContactSelectionModeEdit];
	[ContactSelection setAddAddress:[_addressField text]];
	[ContactSelection setSipFilter:nil];
	[ContactSelection setNameOrEmailFilter:nil];
	[ContactSelection enableEmailFilter:FALSE];
	[PhoneMainView.instance changeCurrentView:ContactsListView.compositeViewDescription];
}

- (IBAction)onBackClick:(id)event {
	[PhoneMainView.instance popToView:CallView.compositeViewDescription];
}

- (IBAction)onAddressChange:(id)sender {
	if ([self displayDebugPopup:_addressField.text]) {
		_addressField.text = @"";
	}
	_addContactButton.enabled = _backspaceButton.enabled = ([[_addressField text] length] > 0);
   // _callButton.enabled = _addContactButton.enabled;
    if ([_addressField.text length] == 0) {
        [self.view endEditing:YES];
    }
}

- (IBAction)onBackspaceClick:(id)sender {
	if ([_addressField.text length] > 0) {
		[_addressField setText:[_addressField.text substringToIndex:[_addressField.text length] - 1]];
    }
}

- (void)onBackspaceLongClick:(id)sender {
	[_addressField setText:@""];
}

- (void)onZeroLongClick:(id)sender {
	// replace last character with a '+'
	NSString *newAddress =
		[[_addressField.text substringToIndex:[_addressField.text length] - 1] stringByAppendingString:@"+"];
	[_addressField setText:newAddress];
	linphone_core_stop_dtmf(LC);
}

- (void)onOneLongClick:(id)sender {
	LinphoneManager *lm = LinphoneManager.instance;
	NSString *voiceMail = [lm lpConfigStringForKey:@"voice_mail_uri"];
	LinphoneAddress *addr = [LinphoneUtils normalizeSipOrPhoneAddress:voiceMail];
	if (addr) {
		linphone_address_set_display_name(addr, NSLocalizedString(@"Voice mail", nil).UTF8String);
		[lm call:addr];
		linphone_address_destroy(addr);
	} else {
		LOGE(@"Cannot call voice mail because URI not set or invalid!");
	}
	linphone_core_stop_dtmf(LC);
}

- (void)dismissKeyboards {
	[self.addressField resignFirstResponder];
}
@end
