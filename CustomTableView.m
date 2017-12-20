//
//  CustomTableView.m
//  Table
//
//  Created by hipiao on 2017/12/7.
//  Copyright © 2017年 James. All rights reserved.
//

#import "CustomTableView.h"

#define JWidth [[UIScreen mainScreen]bounds].size.width
#define JHeight [[UIScreen mainScreen]bounds].size.height

@interface CustomTableView () <UITableViewDelegate,UITableViewDataSource>
{
    NSInteger provinceIndex;
    NSDictionary * cityDic;
    NSArray * sortedArray;
    NSDictionary *areaDic;
}
@property (nonatomic, strong) UITableView * tableFirst;
@property (nonatomic, strong) UITableView * tableSecond;
@property (nonatomic, strong) UITableView * tableThird;

@property (nonatomic, strong) NSArray * arrayFirst;
@property (nonatomic, strong) NSMutableArray * arraySecond;
@property (nonatomic, strong) NSArray * arrayThird;

@end

@implementation CustomTableView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        provinceIndex = 0 ;
        
        [self setprovinceMotherd];
        
        [self setCityDataWithIndex:0];
        
        [self setAreaDataWithIndex:0];
    }
    
    return self;
}
-(void)setprovinceMotherd{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    
    NSArray * components = [areaDic allKeys];
    sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    
    NSMutableArray * provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    self.arrayFirst = [[NSArray alloc] initWithArray: provinceTmp];
    
}

-(void)setCityDataWithIndex:(NSInteger)JSIndex{
   
    provinceIndex = JSIndex ;
    NSString *provinceName = [self.arrayFirst objectAtIndex:provinceIndex];
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:[NSString stringWithFormat:@"%li",provinceIndex]]objectForKey:provinceName]];
    
    NSArray * cityArray = [dic allKeys];
    cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    NSDictionary * dc = [[areaDic objectForKey:[NSString stringWithFormat:@"%li",JSIndex]]objectForKey:provinceName];
    NSLog(@"%@",[dc allKeys]);
    self.arraySecond = [NSMutableArray array];
    for (id key in dc) {
        NSDictionary * dicccc = dc[key];
        [self.arraySecond addObjectsFromArray:[dicccc allKeys]];
    }
    
    
    NSString * selectedCity = [self.arraySecond objectAtIndex: 0];
    self.arrayThird = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
    
}
-(void)setAreaDataWithIndex:(NSInteger)JSIndex{
    
    NSString *provinceName = [self.arrayFirst objectAtIndex:provinceIndex];
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:[NSString stringWithFormat:@"%li",provinceIndex]]objectForKey:provinceName]];
    
    NSArray * cityArray = [dic allKeys];
    cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:JSIndex]]];
    
    NSString * cityName = [self.arraySecond objectAtIndex: JSIndex];
    self.arrayThird = [[NSArray alloc] initWithArray: [cityDic objectForKey: cityName]];
    
}
-(void)dismissMotherd{
    
    [UIView animateWithDuration:0.35 animations:^{
        self.tableFirst.frame = CGRectMake(0, 0, JWidth, 0);
        self.tableSecond.frame = CGRectMake(0, 0, JWidth, 0);
        self.tableThird.frame = CGRectMake(0, 0, JWidth, 0);
    } completion:^(BOOL finish){
        if (finish) {
            [self.tableFirst removeFromSuperview];
            [self.tableSecond removeFromSuperview];
            [self.tableThird removeFromSuperview];
        }
    }];
    
}
-(void)createSubviews{
    [self addSubview:self.tableFirst];
    [self addSubview:self.tableSecond];
    [self addSubview:self.tableThird];
    self.tableThird.frame = CGRectMake(JWidth, 0, 0, JHeight/2);
    self.tableFirst.frame = CGRectMake(0, 0, 0, 0);
    self.tableSecond.frame = CGRectMake(0, 0, JWidth, 0);
    [UIView animateWithDuration:0.35 animations:^{
        self.tableFirst.frame = CGRectMake(0, 0, JWidth/2, JHeight/2);
        self.tableSecond.frame = CGRectMake(JWidth/2, 0, JWidth/2, JHeight/2);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableFirst) {
        return self.arrayFirst.count ;
    }
    if (tableView == self.tableSecond) {
        return self.arraySecond.count ;
    }
    if (tableView == self.tableThird) {
        return self.arrayThird.count ;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  * identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (tableView == self.tableFirst) {
        cell.textLabel.text = self.arrayFirst[indexPath.row];
    }
    if (tableView == self.tableSecond) {
        cell.contentView.backgroundColor = COLOR(236, 236, 236, 1);
        cell.textLabel.text = self.arraySecond[indexPath.row];
    }
    if (tableView == self.tableThird) {
        cell.contentView.backgroundColor = COLOR(199, 199, 199, 1);
        cell.textLabel.text = self.arrayThird[indexPath.row];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:0.35 animations:^{
        if (tableView == self.tableSecond) {
            self.tableFirst.frame = CGRectMake(0, 0, JWidth/10 * 3, JHeight/2);
            self.tableSecond.frame = CGRectMake(JWidth/10 * 3, 0, JWidth/10 * 3, JHeight/2);
            self.tableThird.frame = CGRectMake(JWidth/10 * 6, 0, JWidth/10 * 4, JHeight/2);
            [self setAreaDataWithIndex:indexPath.row];
            [self.tableThird reloadData];
        }
        if (tableView == self.tableFirst) {
            self.tableFirst.frame = CGRectMake(0, 0, JWidth/2, JHeight/2);
            self.tableSecond.frame = CGRectMake(JWidth/2, 0, JWidth/2, JHeight/2);
            self.tableThird.frame = CGRectMake(JWidth, 0, 0, JHeight/2);
            
            [self setCityDataWithIndex:indexPath.row];
            [self.tableSecond reloadData];
        }
        
    }];
}

-(UITableView *)tableFirst{
    if (!_tableFirst) {
        _tableFirst = [[UITableView alloc]init];
        _tableFirst.delegate = self;
        _tableFirst.dataSource = self;
        _tableFirst.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableFirst;
}
-(UITableView *)tableSecond{
    if (!_tableSecond) {
        _tableSecond = [[UITableView alloc]init];
        _tableSecond.delegate = self;
        _tableSecond.dataSource = self;
        _tableSecond.backgroundColor = COLOR(236, 236, 236, 1);
        _tableSecond.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableSecond;
}
-(UITableView *)tableThird{
    if (!_tableThird) {
        _tableThird = [[UITableView alloc]init];
        _tableThird.delegate = self;
        _tableThird.dataSource = self;
        _tableThird.backgroundColor = COLOR(199, 199, 199, 1);
        [self addSubview:_tableThird];
        _tableThird.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableThird;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
