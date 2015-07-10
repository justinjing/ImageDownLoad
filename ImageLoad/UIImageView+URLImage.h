//
//  UIImageView+URLImage.h
//  ImageLoad
//
//  Created by justinjing on 15/7/10.
//  Copyright (c) 2015年 justinjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageDownDelegate : NSObject
 
@end


@interface UIImageView (URLImage)
@property(nonatomic,strong)ImageDownDelegate* callback;

/**
*	@brief	异步加载网络图片
*
*	@param 	url 	 网络图片url
*	@param 	imgName  本地默认图片名称
*
*	@return	空
*/
-(void)setImageWithUrl:(NSString*)url placeholderImgName:(NSString*)imgName progress:(void(^)(int progress, NSError* error)) progress;


@end



//UIButton
@interface UIButton (URLImage)

/**
*	@brief	异步加载网络图片
*
*	@param 	url 	 网络图片url
*	@param 	imgName  本地默认图片名称
*
*	@return	空
*/
-(void)setBackImageWithUrl:(NSString*)url placeholderImgName:(NSString*)imgName progress:(void(^)(int progress, NSError* error)) progress;

@end
