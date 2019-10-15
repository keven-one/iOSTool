//
//  MRWifiSelectorViewController.m
//  MRDLNA_Example
//
//  Created by King on 2019/9/9.
//  Copyright © 2019 MQL9011. All rights reserved.
//

#import "MRWifiSelectorViewController.h"
#import <NetworkExtension/NEHotspotConfigurationManager.h>
#import <SystemConfiguration/CaptiveNetwork.h>

#import <Toast.h>
@interface MRWifiSelectorViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *wifiArray;
    NSString *wifiname;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MRWifiSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    wifiArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"wifi"] mutableCopy];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self currentWifiName];
}

-(void)currentWifiName
{
    NSString *name = @"";
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    name = [(NSDictionary*)info objectForKey:@"SSID"];
    wifiname = name;
    [self.tableView reloadData];
}





-(void)add
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入Wifi名字和密码" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入Wifi名字";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入Wifi密码";
    }];
    __weak typeof(UIAlertController *) weakAlert = alert;
    __weak typeof(MRWifiSelectorViewController *) weakself = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (weakAlert.textFields.firstObject.text.length !=0 && weakAlert.textFields[1].text.length != 0) {
            NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] objectForKey:@"wifi"] mutableCopy];
            if (array.count == 0) {
                array = [NSMutableArray array];
            }
            [array addObject:@{@"name":weakAlert.textFields.firstObject.text,@"password":weakAlert.textFields[1].text}];
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"wifi"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            wifiArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"wifi"] mutableCopy];

            [weakself.tableView reloadData];
        }else
        {
            [self.view makeToast:@"名称和密码不能为空"];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL]];
    
    [self presentViewController:alert animated:YES completion:NULL];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return wifiArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    if (wifiname.length == 0 && wifiname == wifiArray[indexPath.row][@"name"]) {
        cell.detailTextLabel.text = @"当前连接";
    }else
    {
        cell.detailTextLabel.text = @"";
    }
    cell.textLabel.text = wifiArray[indexPath.row][@"name"];
    return  cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (@available(iOS 11.0, *)) {
        NEHotspotConfiguration * hotspotConfig = [[NEHotspotConfiguration alloc] initWithSSID:wifiArray[indexPath.row][@"name"] passphrase:wifiArray[indexPath.row][@"password"] isWEP:NO];
        //调用此方法系统会自动弹窗确认)
        __weak typeof(MRWifiSelectorViewController *) weakSelf = self;

        [[NEHotspotConfigurationManager sharedManager]  applyConfiguration:hotspotConfig completionHandler:^(NSError * _Nullable error) {
            if (error == nil) {
                [weakSelf.view makeToast:@"连接成功" duration:3 position:CSToastPositionCenter];
            }
            if (error.code == 13) {
                [weakSelf.view makeToast:@"已连接" duration:3 position:CSToastPositionCenter];
            }
            
        }];
    } else {
        // Fallback on earlier versions
    }
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [wifiArray removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        [[NSUserDefaults standardUserDefaults] setObject:wifiArray forKey:@"wifi"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
