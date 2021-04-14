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

#import "UIHistoryCell.h"
#import "LinphoneManager.h"
#import "PhoneMainView.h"
#import "Utils.h"

@implementation UIHistoryCell

@synthesize callLog;
@synthesize displayNameLabel;

#pragma mark - Lifecycle Functions

- (id)initWithIdentifier:(NSString *)identifier {
	if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]) != nil) {
		NSArray *arrayOfViews =
			[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];

		// resize cell to match .nib size. It is needed when resized the cell to
		// correctly adapt its height too
		UIView *sub = ((UIView *)[arrayOfViews objectAtIndex:0]);
		[self setFrame:CGRectMake(0, 0, sub.frame.size.width, sub.frame.size.height)];
		[self addSubview:sub];
		_detailsButton.hidden = IPAD;
		callLog = NULL;
	}
	return self;
}

#pragma mark - Action Functions

- (void)setCallLog:(LinphoneCallLog *)acallLog {
	callLog = acallLog;

	[self update];
}

#pragma mark - Action Functions

- (IBAction)onDetails:(id)event {
	if (callLog != NULL) {
		HistoryDetailsView *view = VIEW(HistoryDetailsView);
		if (linphone_call_log_get_call_id(callLog) != NULL) {
			// Go to History details view
			[view setCallLogId:[NSString stringWithUTF8String:linphone_call_log_get_call_id(callLog)]];
		}
		[PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
	}
}

#pragma mark -

- (NSString *)accessibilityValue {
	BOOL incoming = linphone_call_log_get_dir(callLog) == LinphoneCallIncoming;
	BOOL missed = linphone_call_log_get_status(callLog) == LinphoneCallMissed;
	NSString *call_type = incoming ? (missed ? @"Missed" : @"Incoming") : @"Outgoing";
	return [NSString stringWithFormat:@"%@ call from %@", call_type, displayNameLabel.text];
}

- (void)update {
	if (callLog == NULL) {
		LOGW(@"Cannot update history cell: null callLog");
		return;
	}

    _missedStatus.hidden = TRUE;
    _sendStatus.hidden = TRUE;
    _receivedStatus.hidden = TRUE;
    
	// Set up the cell...
	const LinphoneAddress *addr;
	UIImage *image;
	if (linphone_call_log_get_dir(callLog) == LinphoneCallIncoming) {
		if (linphone_call_log_get_status(callLog) != LinphoneCallMissed) {
			image = [UIImage imageNamed:@"call_status_incoming.png"];
            _receivedStatus.hidden = FALSE;
		} else {
			image = [UIImage imageNamed:@"call_status_missed.png"];
            _missedStatus.hidden = FALSE;
		}
		addr = linphone_call_log_get_from_address(callLog);
	} else {
		image = [UIImage imageNamed:@"call_status_outgoing.png"];
        _sendStatus.hidden = FALSE;
		addr = linphone_call_log_get_to_address(callLog);
	}
	_stateImage.image = image;

	[ContactDisplay setDisplayNameLabel:displayNameLabel forAddress:addr];

	size_t count = bctbx_list_size(linphone_call_log_get_user_data(callLog)) + 1;
	if (count > 1) {
		displayNameLabel.text =
			[displayNameLabel.text stringByAppendingString:[NSString stringWithFormat:@" (%lu)", count]];
	}

	[_avatarImage setImage:[FastAddressBook imageForAddress:addr] bordered:NO withRoundedRadius:YES];
    NSString* imageName = [_avatarImage accessibilityIdentifier];
    if([imageName containsString:@"avatar"] || imageName == nil ) {
        NSRange myRange = NSMakeRange(0, 1);
        [_avatarImage setImage: [_avatarImage.image drawWatermarkText:[displayNameLabel.text substringWithRange:myRange]]];
    }
}

- (void)setEditing:(BOOL)editing {
	[self setEditing:editing animated:FALSE];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
	}
	if (editing) {
		[_detailsButton setAlpha:0.0f];
	} else {
		[_detailsButton setAlpha:1.0f];
	}
	if (animated) {
		[UIView commitAnimations];
	}
    
    
}

- (UIView*)recursivelyFindConfirmationButtonInView:(UIView*)view
{
    for(UIView *subview in view.subviews) {
        NSLog(@"View type %@, tag %d", NSStringFromClass([subview class]), subview.tag);
        if([NSStringFromClass([subview class]) isEqualToString:@"UIButtonLabel"]) return subview;
        UIView *recursiveResult = [self recursivelyFindConfirmationButtonInView:subview];
        if(recursiveResult) return recursiveResult;
    }
    return nil;
}

-(void)overrideConfirmationButtonColor
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *confirmationButton = [self recursivelyFindConfirmationButtonInView:self];
        if(confirmationButton)
            confirmationButton.backgroundColor = [UIColor orangeColor];
    });
}

@end
