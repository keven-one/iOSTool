//
//  MRVideoPlayViewController.m
//  MRDLNA_Example
//
//  Created by King on 2019/10/15.
//  Copyright © 2019 MQL9011. All rights reserved.
//

#import "MRVideoPlayViewController.h"
#import "MRFindWebSourceViewController.h"
#import <Toast.h>

@interface MRVideoPlayViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *titleArray;
    NSArray *urlArray;
}
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation MRVideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titleArray = @[@"贝贝影视",@"奈菲影视",@"➕"];
    urlArray = @[@"http://v.hibbba.com",@"https://www.nfmovies.com"];
    [self setExtraCellLineHidden:self.table];
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text =titleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row+1 == titleArray.count) {
        [self add];
        return;
    }
    MRFindWebSourceViewController *timeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MRFindWebSourceViewController"];
    timeVC.url = urlArray[indexPath.row];
    [self.navigationController pushViewController:timeVC animated:YES];
    
}

-(void)add
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入Wifi名字和密码" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入网址";
    }];
   
    __weak typeof(UIAlertController *) weakAlert = alert;
    __weak typeof(MRVideoPlayViewController *) weakself = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (weakAlert.textFields.firstObject.text.length !=0) {
            MRFindWebSourceViewController *timeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MRFindWebSourceViewController"];
            timeVC.url = weakAlert.textFields.firstObject.text;
            [weakself.navigationController pushViewController:timeVC animated:YES];
        }else
        {
            [self.view makeToast:@"网址不能为空"];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL]];
    
    [self presentViewController:alert animated:YES completion:NULL];
    
    
}
@end
