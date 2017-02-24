//
//  ViewController.m
//  ICPingyinConvert
//
//  Created by 朱封毅 on 23/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "ViewController.h"
#import "MyModel.h"
#import "ICPinyinGroup.h"
#define SCREEN_WIDTH CGRectGetWidth([[UIScreen mainScreen] bounds])
#define SCREEN_HEIGHT CGRectGetHeight([[UIScreen mainScreen] bounds])
@interface ViewController ()

@end

@implementation ViewController{

    UILabel *_myindex;//中间索引view
    UILabel *_indexView;//右边索引view
    CGFloat _indexHight;//索引高度
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initData];

}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
        
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        
    }
    
    return _tableView;
}
#pragma mark create method
- (void)initData {
    //init
    _dataArr = [[NSMutableArray alloc] init];
    _sortedArrForArrays = [[NSMutableArray alloc] init];
    _sectionHeadsKeys = [[NSMutableArray alloc] init];
    
    NSMutableArray * Arr = [NSMutableArray arrayWithArray:@[@"郭靖",@"黄蓉",@"杨过",@"苗若兰",@"令狐冲",@"小龙女",@"胡斐",@"水笙",@"任盈盈",@"白琇",@"狄云",@"石破天",@"殷素素",@"张翠山",@"张无忌",@"青青",@"袁冠南",@"萧中慧",@"袁承志",@"乔峰",@"王语嫣",@"段玉",@"虚竹",@"苏星河",@"丁春秋",@"庄聚贤",@"阿紫",@"阿朱",@"阿碧",@"鸠魔智",@"萧远山",@"慕容复",@"慕容博",@"Jim",@"Lily",@"Green小",@"Green大",@"DavidSmall",@"Kobe",@"Ethan"]];
    
    for(int i = 0;i<Arr.count; i++)
    {
        MyModel *model = [MyModel new];
        model.UserName = Arr[i];
        model.userId = Arr[i];
        
        [_dataArr addObject:model];
    }
    
    NSDictionary *dict = [ICPinyinGroup group:_dataArr key:@"UserName"];
    
    _sortedArrForArrays = [dict objectForKey:LEOPinyinGroupResultKey];
    
    _sectionHeadsKeys = [dict objectForKey:LEOPinyinGroupCharKey];
    
    [self.tableView reloadData];

    
    //    初始化显示的索引view
    _myindex=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    _myindex.font=[UIFont boldSystemFontOfSize:30];
    _myindex.backgroundColor=[UIColor greenColor];
    _myindex.textColor=[UIColor redColor];
    _myindex.textAlignment = NSTextAlignmentCenter;
    _myindex.center= self.view.center;
    _myindex.layer.cornerRadius=_myindex.frame.size.width/2;
    _myindex.layer.masksToBounds=YES;
    _myindex.alpha=0;
    
    [self.view addSubview:_myindex];

    
    _indexHight = 380/26*(_sectionHeadsKeys.count+1);
    //    初始化右边索引条
    _indexView=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15,(SCREEN_HEIGHT-_indexHight)/2,13,_indexHight)];
    _indexView.numberOfLines=0;
    _indexView.font=[UIFont systemFontOfSize:12];
    _indexView.backgroundColor=[UIColor clearColor];
    _indexView.textAlignment=NSTextAlignmentCenter;
    _indexView.userInteractionEnabled=YES;
    _indexView.layer.cornerRadius=5;
    _indexView.layer.masksToBounds=YES;
    _indexView.alpha=0.7;
    [self.view addSubview:_indexView];
    
    
    //    初始化索引条内容

    for (int i=0; i<_sectionHeadsKeys.count; i++)
    {
        NSString *str = [_sectionHeadsKeys objectAtIndex:i];
        _indexView.text=i==0?str:[NSString stringWithFormat:@"%@\n%@",_indexView.text,str];
    }
    
    NSLog(@"%@",_indexView.text);
    
}

//点击开始
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self myTouch:touches];
}

//点击进行中
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self myTouch:touches];
}

//点击结束
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 让中间的索引view消失
    [UIView animateWithDuration:1 animations:^{
        _myindex.alpha=0;
    }];
}

//点击会掉的方法
-(void)myTouch:(NSSet *)touches
{
    
    //    获取点击的区域
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:_indexView];
    
    int index=(int)((point.y/_indexHight)*_sectionHeadsKeys.count);
    if (index>_sectionHeadsKeys.count-1||index<0)return;
    //    让中间的索引view出现
    [UIView animateWithDuration:0.3 animations:^{
        
        _myindex.alpha=1;
    }];
    //    给显示的view赋标题
    _myindex.text=_sectionHeadsKeys[index];
    //    跳到tableview指定的区
    
    NSIndexPath *indpath=[NSIndexPath indexPathForRow:0 inSection:index];
    [_tableView  scrollToRowAtIndexPath:indpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
   
    
}

#pragma mark   - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [[self.sortedArrForArrays objectAtIndex:section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionHeadsKeys.count;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sectionHeadsKeys objectAtIndex:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellId = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId] ;
    }
    
    NSArray *arr = [self.sortedArrForArrays objectAtIndex:indexPath.section];
    if ([arr count] > indexPath.row) {
        MyModel *str = (MyModel *) [arr objectAtIndex:indexPath.row];
        cell.textLabel.text = str.UserName;
        cell.detailTextLabel.text = str.userId;
    }
  
    return cell;
}
@end
