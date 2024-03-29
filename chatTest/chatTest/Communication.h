//
//  Communication.h
//  chatTest
//
//  Created by Simin Liu on 3/2/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Communication : UIViewController<NSStreamDelegate>
+ (void)initNetworkCommunication;
+ (void)send:(NSData *)myData;
+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;


+(CGFloat)cornerScaleFactor:(UIView*) thisView;
+(CGFloat)cornerRadius:(UIView*) thisView;
+(CGFloat)cornerOffset:(UIView*) thisView;
+(UIImage*)compressToSmallSquare:(UIImage*)oldImage;
+(NSString*)parseIntoJson:(NSDictionary*)dict;
+(NSDictionary*)parseFromJson:(NSData*)json;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIImage *)imageWithColor:(UIColor *)color;
+(void)addFriend:(NSDictionary*)info :(NSData*)userPic;
@end
NSInputStream* inputStream;
NSOutputStream* outputStream;
