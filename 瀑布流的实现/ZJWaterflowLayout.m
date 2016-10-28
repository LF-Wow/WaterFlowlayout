//
//  ZJWaterflowLayout.m
//  瀑布流的实现
//
//  Created by 周君 on 16/10/21.
//  Copyright © 2016年 周君. All rights reserved.
//

#import "ZJWaterflowLayout.h"

/** 默认的列数 */
static const NSInteger ZJDefaultColumnCount = 3;
/** 每一列之间的间距 */
static const CGFloat ZJDefaultColumnMargin = 10;
/** 每一行之间的间距 */
static const CGFloat ZJDefaultRowMargin = 10;
/** 边缘间距 */
static const UIEdgeInsets ZJDefaultEdgeInsets = {10, 10, 10, 10};

@interface ZJWaterflowLayout()

/** 存放所有列的当前高度*/
@property (nonatomic, strong) NSMutableArray *columnHeights;
/** 存放每一个布局属性*/
@property (nonatomic, strong) NSMutableArray *attributesArray;
/** 内容的高度 */
@property (nonatomic, assign) CGFloat contentHeight;

- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
- (UIEdgeInsets)edgeInsets;

@end

@implementation ZJWaterflowLayout

#pragma mark - 常见数据处理
- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    } else {
        return ZJDefaultRowMargin;
    }
}

- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [self.delegate columnMarginInWaterflowLayout:self];
    } else {
        return ZJDefaultColumnMargin;
    }
}

- (NSInteger)columnCount
{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        return [self.delegate columnCountInWaterflowLayout:self];
    } else {
        return ZJDefaultColumnCount;
    }
}

- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.delegate edgeInsetsInWaterflowLayout:self];
    } else {
        return ZJDefaultEdgeInsets;
    }
}


#pragma mark - 初始化数据
- (NSMutableArray *)columnHeights
{
    if(!_columnHeights)
    {
        _columnHeights = [NSMutableArray arrayWithCapacity:1];
    }
    
    return _columnHeights;
}
- (NSMutableArray *)attributesArray
{
    if(!_attributesArray)
    {
        _attributesArray = [NSMutableArray array];
    }
    
    return _attributesArray;
}

/** 初始化，在每一次重新加载的时候调用*/
- (void)prepareLayout
{
    [super prepareLayout];
    
    //初始化的时候，用一个数组存储第一行的每个cell的maxY值,并清除之前计算的所有高度
    [self.columnHeights removeAllObjects];
    
    for (NSInteger i = 0; i < self.columnCount; ++i)
    {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    
    //初始化每一个cell对应的布局属性
    [self.attributesArray removeAllObjects];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; ++i)
    {
        //创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        //获取indexPath对应的布局属性
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributesArray addObject:attributes];
    }
    
}

/** 决定cell的排布*/
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributesArray;
}

/** 返回indexPath位置cell对应的布局属性*/
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //先创建布局属性
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //cell宽度 = （collectionView的宽度 - 左边距 - 右边距 - （列数 - 1）* 列间距）/ 3
    CGFloat width = (self.collectionView.frame.size.width - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
    //cell高度 = 传进来的高度
    CGFloat height = [self.delegate waterflowLayout:self heightForItemAtIndex:indexPath.item itemWidth:width];
    
    //如果是第一行
    //y = 上边距
    
    /**
     * 如果不是第一行，需要找出最短的一列
     * 初始化的时候，用一个数组存储第一行的每个cell的maxY值
     * 定义一个最短高度的变量，遍历cellmaxY值数组，让变量等于最短的那一个，得到最短的列
     */
    //最短的行号，默认第一列
    NSInteger minColumnCount = 0;
    //最短的y值,默认第一列
    CGFloat minColunmnMaxY = [self.columnHeights[0] floatValue];
    
    for (NSInteger i = 1; i < self.columnCount; ++i)
    {
        //取出第i列高度
        CGFloat columnHeight = [self.columnHeights[i] floatValue];
        
        if (minColunmnMaxY > columnHeight)
        {
            minColunmnMaxY = columnHeight;
            minColumnCount = i;
        }
    }
    
    //x = 左边距 + 最短列位置 * （宽度 + 列间距）
    CGFloat x = self.edgeInsets.left + minColumnCount * (width + self.columnMargin);
    //有了最短的行，y = 最短列maxY值 + 列间距
    CGFloat y = minColunmnMaxY;
    if (y != self.edgeInsets.top)
    {
        y += self.rowMargin;
    }
    
    //设置frame
    attributes.frame = CGRectMake(x, y, width, height);
    
    //更新高度
    self.columnHeights[minColumnCount] = @(CGRectGetMaxY(attributes.frame));
    
    // 记录内容的高度
    CGFloat columnHeight = [self.columnHeights[minColumnCount] floatValue];
    if (self.contentHeight < columnHeight)
    {
        self.contentHeight = columnHeight;
    }
    
    
    return attributes;
}

/** 返回内容高度*/
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}

@end
