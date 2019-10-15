//
//  MRHomeViewController.m
//  MRDLNA_Example
//
//  Created by King on 2019/9/9.
//  Copyright © 2019 MQL9011. All rights reserved.
//

#import "MRHomeViewController.h"
#import "MRWifiSelectorViewController.h"
#import "MRTimeComputeViewController.h"
#import "MRViewController.h"
#import "MRVideoPlayViewController.h"
@interface MRHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSArray *titleArray;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collection;

@end

@implementation MRHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titleArray = @[@"WIFI切换",@"投屏助手",@"时间计算",@"嗅探＋投屏"];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.labeltext.text = titleArray[indexPath.section*3+indexPath.item];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ((section+1)*3<=titleArray.count) {
        return 3;
    }else if (section*3+2<=titleArray.count){
        return 2;
    }else
    {
        
    return 1;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    int count = titleArray.count%3==0?titleArray.count/3:titleArray.count/3+1;
    return count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSString *title = titleArray[indexPath.section*3+indexPath.item];
    if ([title isEqualToString:@"WIFI切换"]) {
        MRWifiSelectorViewController *wifiVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MRWifiSelectorViewController"];
        [self.navigationController pushViewController:wifiVC animated:YES];
    }else if([title isEqualToString:@"投屏助手"]){
        MRViewController *mrVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MRViewController"];
        [self.navigationController pushViewController:mrVC animated:YES];
    }else if ([title isEqualToString:@"时间计算"]){
        MRTimeComputeViewController *timeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MRTimeComputeViewController"];
        [self.navigationController pushViewController:timeVC animated:YES];
    }else if ([title isEqualToString:@"嗅探＋投屏"]){
        MRVideoPlayViewController *timeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MRVideoPlayViewController"];
        [self.navigationController pushViewController:timeVC animated:YES];
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 50)/3, ([UIScreen mainScreen].bounds.size.width - 50)/3);
    return  size;
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


@implementation HomeCollectionCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.cornerRadius = 5;
}

@end
