//
//  TableSelectViewModel.m
//  Table
//
//  Created by hipiao on 2017/12/7.
//  Copyright © 2017年 James. All rights reserved.
//

#import "TableSelectViewModel.h"
#import "CustomTableView.h"
#import "AppDelegate.h"

#define JWidth [[UIScreen mainScreen]bounds].size.width
#define JHeight [[UIScreen mainScreen]bounds].size.height




@interface TableSelectViewModel ()
{
    UIView * sview;
    UIControl * control;
    
}
@property (nonatomic, strong) CustomTableView * customTable;

@end
@implementation TableSelectViewModel

//全局变量
static id _instance = nil;

+ (instancetype )shareTable {
    
    //避免每次线程过来都加锁，首先判断一次，如果为空才会继续加锁并创建对象
    if(!_instance)
    {
        //避免出现多个线程同时创建_instance,加锁
        @synchronized(self)
        {
            //使用懒加载，确保_instance 只创建一次
            if(_instance == nil)
            {
                _instance = [[self alloc]init];
            }
        }
    }
    return _instance;
    
}

//③重写 allocWithZone:方法---内存与 shareTable方法体基本相同
+(instancetype)allocWithZone:(struct NSZone *)zone
{
    //避免每次线程过来都加锁，首先判断一次，如果为空才会继续加锁并创建对象
    if(!_instance)
    {
        //避免出现多个线程同时创建_instance,加锁
        @synchronized(self)
        {
            //使用懒加载，确保_instance 只创建一次
            if(!_instance)
            {
                //调用父类方法，分配空间
                _instance = [super allocWithZone:zone];
            }
        }
    }
    return _instance;
}

//④重写 copyWithZone:方法,避免实例对象的 copy 操作导致创建新的对象
-(instancetype)copyWithZone:(NSZone *)zone
{
    //由于是对象方法，说明可能存在_instance对象，直接返回即可
    return _instance;
}

-(void)showTableWithSuperView:(UIView *)superView andFrame:(CGRect)frame;
{

    [sview removeFromSuperview];
    control = [[UIControl alloc] initWithFrame: CGRectMake(0, 0, JWidth, frame.size.height)];
    [control addTarget:self action:@selector(dismissMotherd) forControlEvents:UIControlEventTouchUpInside];
    sview = [[UIView alloc]initWithFrame:frame] ;
    sview.backgroundColor = [[UIColor blackColor ] colorWithAlphaComponent:0.5];
    
    
    self.customTable.frame = CGRectMake(0, 0, JWidth, JHeight/2);
    [self.customTable createSubviews];
    
    [sview addSubview:control];
    [sview addSubview:self.customTable];
    [superView addSubview:sview];
    
    [UIView animateWithDuration:0.35 animations:^{
        self.customTable.frame = CGRectMake(0, 0, JWidth, JHeight/2);
    }];
    
}
-(void)dismissMotherd{
    [UIView animateWithDuration:0.35 animations:^{
        self.customTable.frame = CGRectMake(0, 0, JWidth, 0);
        [self.customTable dismissMotherd];
    } completion:^(BOOL finish){
        if (finish) {
            [sview removeFromSuperview];
        }
    }];
}

-(CustomTableView * )customTable{
    if (!_customTable) {
        _customTable = [CustomTableView new];
    }
    return _customTable;
}


@end
