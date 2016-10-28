//
//  ZJShopCollectionViewCell.m
//  瀑布流的实现
//
//  Created by 周君 on 16/10/28.
//  Copyright © 2016年 周君. All rights reserved.
//

#import "ZJShopCollectionViewCell.h"
#import "Shop.h"
#import "UIImageView+WebCache.h"

@interface ZJShopCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation ZJShopCollectionViewCell

- (void)setShop:(Shop *)shop
{
    _shop = shop;
    
    // 1.图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    // 2.价格
    self.priceLabel.text = shop.price;
}

@end
