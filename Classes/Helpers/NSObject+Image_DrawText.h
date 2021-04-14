//
//  NSObject+Image_DrawText.h
//  linphone
//
//  Created by Suhail on 26/12/20.
//

#import <Foundation/Foundation.h>
#import "LinphoneAppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (DrawWatermarkText)
-(UIImage*)drawWatermarkText:(NSString*)text;
@end
@implementation UIImage (DrawWatermarkText)
-(UIImage*)drawWatermarkText:(NSString*)text {
    UIColor *textColor = [UIColor whiteColor];
    UIColor *backgroundColor = [UIColor blackColor];
    
    if (@available(iOS 12.0, *)) {
        if( [LinphoneAppDelegate topMostController].traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){
            textColor = [UIColor blackColor];
            backgroundColor = [UIColor whiteColor];
        }
    }
    
    
    
    UIImage *bgImage = [self imageFromColor:backgroundColor];
    
    // Compute rect to draw the text inside
    CGSize imageSize = bgImage.size;
    UIFont *font = [UIFont systemFontOfSize:imageSize.height*0.5];
    NSDictionary *attr = @{NSForegroundColorAttributeName: textColor, NSFontAttributeName: font};
    CGSize textSize = [text sizeWithAttributes:attr];
    CGRect textRect = CGRectMake((imageSize.width/2) - (textSize.width / 2) , (imageSize.height/2) - (textSize.height / 2), textSize.width, textSize.height);

    // Create the image
    UIGraphicsBeginImageContext(imageSize);
    [bgImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    [text drawInRect:CGRectIntegral(textRect) withAttributes:attr];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 60, 60);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

NS_ASSUME_NONNULL_END
