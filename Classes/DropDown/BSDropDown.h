//
//  BSDropDown.h
//  sanchar
//
//  Created by Suhail Shabir on 17/04/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BSDropDownDelegate <NSObject>
@required
-(void)dropDownView:(UIView*)ddView AtIndex:(NSInteger)selectedIndex ;
@end

@interface BSDropDown : UIView<UITableViewDelegate,UITableViewDataSource>

- (id) initWithWidth:(float)width withHeightForEachRow:(float)height originPoint:(CGPoint)originPoint withOptions:(NSArray*)options;

@property (nonatomic) NSInteger selectedIndex;
@property (weak,nonatomic) id<BSDropDownDelegate> delegate;

-(void)addAsSubviewTo:(UIView*)parentView;

-(void)setDropDownFont:(UIFont*)font;
-(void)setDropDownBGColor:(UIColor*)color;
-(void)setDropDownTextColor:(UIColor*)color;

@end
NS_ASSUME_NONNULL_END
