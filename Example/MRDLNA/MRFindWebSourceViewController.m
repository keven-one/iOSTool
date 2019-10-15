//
//  MRFindWebSourceViewController.m
//  MRDLNA_Example
//
//  Created by King on 2019/10/15.
//  Copyright © 2019 MQL9011. All rights reserved.
//

#import "MRFindWebSourceViewController.h"
#import <WebKit/WebKit.h>
#import "SechemaURLProtocol.h"
#import "DLNASearchVC.h"
@interface MRFindWebSourceViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,WKNavigationDelegate,WKUIDelegate>
{
    BOOL first;
}
@property (strong, nonatomic)  WKWebView *webView1;
@property (strong, nonatomic)  NSMutableDictionary *dic;
@property (strong, nonatomic)  UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftcon;
- (IBAction)btnAction:(id)sender;

@end

@implementation MRFindWebSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    first = YES;
    [NSURLProtocol registerClass:[SechemaURLProtocol class]];
    self.webView1 = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    
    // Do any additional setup after loading the view.
    [self.webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    typeof(self) weakSelf = self;
    self.webView1.UIDelegate = self;
    self.webView1.navigationDelegate = weakSelf;
    [self.view addSubview:self.webView1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showURL:) name:@"showURL" object:nil];
    self.dic = [NSMutableDictionary dictionary];
    self.leftcon.constant = UIScreen.mainScreen.bounds.size.width;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    tap.numberOfTouchesRequired=1;
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self.backgroundView addGestureRecognizer:tap];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    // 点击了tableViewCell，view的类名为UITableViewCellContentView，则不接收Touch点击事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
-(void)tap{
    [UIView animateWithDuration:1 animations:^{
        self.leftcon.constant = UIScreen.mainScreen.bounds.size.width;
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {
        self.backgroundView.hidden = YES;
        
    }];
}

-(void)showURL:(NSNotification *)not{
    NSString *string = not.object;
    NSInteger count = [[not.object mutableCopy] replaceOccurrencesOfString:@"https://" // 要查询的字符串中的某个字符
                                                                withString:not.object
                                                                   options:NSLiteralSearch
                                                                     range:NSMakeRange(0, [not.object length])];
    if (count > 1) {
        [self.dic setObject:string forKey:string];
        NSArray *arr = [string componentsSeparatedByString:@"https://"];
        
        int current = 0;
        for (int i = 0 ; i<arr.count; i++) {
            
            current++;
            if ([arr[i] length]==0) {
                continue;
            }
            NSString *tmp=@"";
            for (int j=0; j<arr.count; j++) {
                if (j==current) {
                    tmp = [[tmp stringByAppendingString:@"https://"] stringByAppendingString:arr[j]];
                }
            }
            if (tmp.length !=0) {
                [self.dic setObject:tmp forKey:tmp];
            }
            
            
        }
        
    }else
    {
        [self.dic setObject:string forKey:string];
    }
    [self.tableView reloadData];
    if (self.backgroundView.hidden || self.leftcon.constant == UIScreen.mainScreen.bounds.size.width) {
        [self.view bringSubviewToFront:self.btn];

        [self.view bringSubviewToFront:self.backgroundView];
        self.backgroundView.hidden = NO;
        
        [UIView animateWithDuration:1 animations:^{
            self.leftcon.constant = 0;
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)dealloc
{
    [NSURLProtocol unregisterClass:[SechemaURLProtocol class]];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [self.dic allValues][indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dic allValues].count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLNASearchVC *dlna = [[DLNASearchVC alloc]init];
    dlna.testUrl = [self.dic allValues][indexPath.row];
    [self.navigationController pushViewController:dlna animated:YES];
}


- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if (navigationAction.request.URL) {
        
        NSURL *url = navigationAction.request.URL;
        NSString *urlPath = url.absoluteString;
        if ([urlPath rangeOfString:@"https://"].location != NSNotFound || [urlPath rangeOfString:@"http://"].location != NSNotFound) {
            
            [self.webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlPath]]];
        }
    }
    
    return nil;
}

- (IBAction)btnAction:(id)sender {
    if (self.backgroundView.hidden || self.leftcon.constant == UIScreen.mainScreen.bounds.size.width) {
        [self.view bringSubviewToFront:self.btn];

        [self.view bringSubviewToFront:self.backgroundView];
        self.backgroundView.hidden = NO;
        
        [UIView animateWithDuration:1 animations:^{
            self.leftcon.constant = 0;
            [self.view layoutIfNeeded];
        }];
    }
}
@end
