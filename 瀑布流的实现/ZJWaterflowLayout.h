//
//  ZJWaterflowLayout.h
//  瀑布流的实现
//
//  Created by 周君 on 16/10/21.
//  Copyright © 2016年 周君. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJWaterflowLayout;

@protocol ZJWaterflowLayoutDelegate <NSObject>
@required
- (CGFloat)waterflowLayout:(ZJWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (CGFloat)columnCountInWaterflowLayout:(ZJWaterflowLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(ZJWaterflowLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(ZJWaterflowLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(ZJWaterflowLayout *)waterflowLayout;
@end

@interface ZJWaterflowLayout : UICollectionViewLayout

/** 代理 */
@property (nonatomic, weak) id<ZJWaterflowLayoutDelegate> delegate;

@end
