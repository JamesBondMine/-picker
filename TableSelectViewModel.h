//
//  TableSelectViewModel.h
//  Table
//
//  Created by hipiao on 2017/12/7.
//  Copyright © 2017年 James. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableSelectViewModel : NSObject 



+ (TableSelectViewModel *)shareTable;

-(void)showTableWithSuperView:(UIView *)superView andFrame:(CGRect)frame;

@end
