//
//  HLScaleImageView.h
//  Hoolink_IoT
//
//  Created by hoolink on 2018/5/27.
//  Copyright © 2018年 hoolink_IoT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HLScaleImageViewDelegate <NSObject>

@optional

-(void)removeEnlargeImageImageView;

@end

@interface HLScaleImageView : UIView
@property(nonatomic, weak) id<HLScaleImageViewDelegate> delegate;

-(void)slideImageView:(int)totalPages withHomePage:(int)homePage withImageURL:(NSArray *)imageURL  ;

-(void)localImageView:(int)totalPages withHomePage:(int)homePage withArrayImage:(NSArray *)arrayImage;

@end
