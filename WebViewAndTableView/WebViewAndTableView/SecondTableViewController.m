//
//  SecondTableViewController.m
//  WebViewAndTableView
//
//  Created by rpweng on 2019/4/27.
//  Copyright © 2019 rpweng. All rights reserved.
//

#import "SecondTableViewController.h"
#import <WebKit/WebKit.h>
#import "UIView+Common.h"

/**
 * 最上面有个View，WebView和TableView
 */
@interface SecondTableViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,
WKNavigationDelegate>
{
    CGFloat _lastWebViewContentHeight;
    CGFloat _lastTableViewContentHeight;
}
@property (nonatomic, strong) WKWebView     *webView;

@property (nonatomic, strong) UITableView   *tableView;

@property (nonatomic, strong) UIScrollView  *containerScrollView;

@property (nonatomic, strong) UIView        *contentView;

@property (nonatomic, strong) UIView        *topView;

@end

@implementation SecondTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initValue];
    [self initView];
    [self addObservers];
    
    //    NSString *path = @"https://www.jianshu.com/p/f31e39d3ce41";
    //    NSString *path2 = @"http://127.0.0.1/openItunes.html";
    //
    //    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:path]];
    //    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    //    [self.webView loadRequest:request];
    
    NSString *goodsDesc =  [NSString stringWithFormat:@"<p><span style=\"font-size:48px\"><span style=\"color:#000000\">活动规则</span></span></p><p><span style=\"color:#000000\"><span style=\"font-size:36px\"><span style=\"line-height:1.5\">品类说明：</span></span></span></p><p><span style=\"font-size:36px\"><span style=\"color:#cccccc\"><span style=\"line-height:1.5\">本券为10元无门槛券，订单满10元可用。</span></span></span></p><p><span style=\"color:#000000\"><span style=\"font-size:36px\"><span style=\"line-height:1.5\">兑换说明：</span></span></span></p><p><span style=\"font-size:36px\"><span style=\"line-height:1.5\"><span style=\"color:#cccccc\">1. 注册登录东方购物APP；  </span><span style=\"color:#c0392b\"><a href=\"http://k.zol-img.com.cn/sjbbs/7692/a7691515_s.jpg\" target=\"\">查看图片</a></span></span></span></p><p><span style=\"font-size:36px\"><span style=\"line-height:1.5\"><span style=\"color:#cccccc\">2. 登入后点击“我的”-“我的钱包”-“抵用券”；  </span><span style=\"color:#c0392b\"><a href=\"http://www.baidu.com/\" target=\"\">查看图片</a></span></span></span></p><p><span style=\"font-size:36px\"><span style=\"color:#cccccc\"><span style=\"line-height:1.5\">3. 输入兑换码，点击“确认兑换”；</span></span></span></p><p><span style=\"color:#000000\"><span style=\"font-size:36px\"><span style=\"line-height:1.5\">使用说明：</span></span></span></p><p><span style=\"font-size:36px\"><span style=\"color:#cccccc\"><span style=\"line-height:1.5\">1. 单笔订单额满抵扣：每笔订单仅限使用一张优惠券，满足指定金额后抵扣订单金额，优惠券不可叠加使用，一码兑换一券；</span></span></span></p><p><span style=\"font-size:36px\"><span style=\"color:#cccccc\"><span style=\"line-height:1.5\">2. 活动渠道：移动端（含东方购物APP客户端、移动网页版）；</span></span></span></p><p><span style=\"font-size:36px\"><span style=\"color:#cccccc\"><span style=\"line-height:1.5\">3. 每张优惠券都有有效期，请在有效期内使用。本次活动券有效期至2019年6月30日；</span></span></span></p><p><span style=\"font-size:36px\"><span style=\"color:#cccccc\"><span style=\"line-height:1.5\">4. 优惠券不可使用商品包括但不仅限于：移动版专享首购折扣、汽车、房产、旅游、保险、团购、拼团、商城、会员俱乐部、东方全球购商品、爆款商品、无形商品、贵金属类、收藏品类、黄金类、钻石类、虫草夏草、影票商品、定金类商品、定制类商品、母婴商品、苹果数码产品、戴森部分商品、广播专享商品、专供商品及其他特殊商品等，实际以购物车及下单页面为准；</span></span></span></p><p><span style=\"font-size:36px\"><span style=\"color:#cccccc\"><span style=\"line-height:1.5\">5. 优惠券不同类型：如仅限某品类使用的优惠券，此类优惠券只适用于所属类别；</span></span></span></p><p><span style=\"font-size:36px\"><span style=\"color:#cccccc\"><span style=\"line-height:1.5\">6. 不管发生任何情况的退换货，概不补券；如遇到电话取消订购，优惠券也已作废，不补券。如遇网站在线取消订购时，优惠券即时返还到顾客账号；</span></span></span></p><p><span style=\"font-size:36px\"><span style=\"color:#cccccc\"><span style=\"line-height:1.5\">7. 在法律允许的范围内，东方购物保留本次活动最终解释权。</span></span></span></p>"];
    [self.webView loadHTMLString:goodsDesc baseURL:nil];
}

- (void)dealloc{
    [self removeObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initValue{
    _lastWebViewContentHeight = 0;
    _lastTableViewContentHeight = 0;
}

- (void)initView{
    
    [self.contentView addSubview:self.topView];
    [self.contentView addSubview:self.webView];
    [self.contentView addSubview:self.tableView];
    
    [self.view addSubview:self.containerScrollView];
    [self.containerScrollView addSubview:self.contentView];
    
    self.contentView.frame = CGRectMake(0, 0, self.view.width, self.view.height * 2);
    self.topView.frame = CGRectMake(0, 0, self.view.width, 200);
    
    self.webView.top = self.topView.height;
    self.webView.height = self.view.height;
    self.tableView.top = self.webView.bottom;
}


#pragma mark - Observers
- (void)addObservers{
    [self.webView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers{
    [self.webView removeObserver:self forKeyPath:@"scrollView.contentSize"];
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == _webView) {
        if ([keyPath isEqualToString:@"scrollView.contentSize"]) {
            [self updateContainerScrollViewContentSize:0 webViewContentHeight:0];
        }
    }else if(object == _tableView) {
        if ([keyPath isEqualToString:@"contentSize"]) {
            [self updateContainerScrollViewContentSize:0 webViewContentHeight:0];
        }
    }
}

- (void)updateContainerScrollViewContentSize:(NSInteger)flag webViewContentHeight:(CGFloat)inWebViewContentHeight{
    
    CGFloat webViewContentHeight = flag==1 ?inWebViewContentHeight :self.webView.scrollView.contentSize.height;
    CGFloat tableViewContentHeight = self.tableView.contentSize.height;
    
    if (webViewContentHeight == _lastWebViewContentHeight && tableViewContentHeight == _lastTableViewContentHeight) {
        return;
    }
    
    _lastWebViewContentHeight = webViewContentHeight;
    _lastTableViewContentHeight = tableViewContentHeight;
    
    self.containerScrollView.contentSize = CGSizeMake(self.view.width, self.webView.top + webViewContentHeight + tableViewContentHeight);
    
    CGFloat webViewHeight = (webViewContentHeight < self.view.height) ?webViewContentHeight :self.view.height ;
    CGFloat tableViewHeight = tableViewContentHeight < self.view.height ?tableViewContentHeight :self.view.height;
    self.webView.height = webViewHeight <= 0.1 ?0.1 :webViewHeight;
    self.contentView.height = self.webView.top +webViewHeight + tableViewHeight;
    self.tableView.height = tableViewHeight;
    self.tableView.top = self.webView.bottom;
    
    //Fix:contentSize变化时需要更新各个控件的位置
    [self scrollViewDidScroll:self.containerScrollView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_containerScrollView != scrollView) {
        return;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat webViewHeight = self.webView.height;
    CGFloat tableViewHeight = self.tableView.height;
    
    CGFloat webViewContentHeight = self.webView.scrollView.contentSize.height;
    CGFloat tableViewContentHeight = self.tableView.contentSize.height;
    //CGFloat topViewHeight = self.topView.height;
    CGFloat webViewTop = self.webView.top;
    
    CGFloat netOffsetY = offsetY - webViewTop;
    
    if (netOffsetY <= 0) {
        self.contentView.top = 0;
        self.webView.scrollView.contentOffset = CGPointZero;
        self.tableView.contentOffset = CGPointZero;
    }else if(netOffsetY  < webViewContentHeight - webViewHeight){
        self.contentView.top = netOffsetY;
        self.webView.scrollView.contentOffset = CGPointMake(0, netOffsetY);
        self.tableView.contentOffset = CGPointZero;
    }else if(netOffsetY < webViewContentHeight){
        self.contentView.top = webViewContentHeight - webViewHeight;
        self.webView.scrollView.contentOffset = CGPointMake(0, webViewContentHeight - webViewHeight);
        self.tableView.contentOffset = CGPointZero;
    }else if(netOffsetY < webViewContentHeight + tableViewContentHeight - tableViewHeight){
        self.contentView.top = offsetY - webViewHeight - webViewTop;
        self.tableView.contentOffset = CGPointMake(0, offsetY - webViewContentHeight - webViewTop);
        self.webView.scrollView.contentOffset = CGPointMake(0, webViewContentHeight - webViewHeight);
    }else if(netOffsetY <= webViewContentHeight + tableViewContentHeight ){
        self.contentView.top = self.containerScrollView.contentSize.height - self.contentView.height;
        self.webView.scrollView.contentOffset = CGPointMake(0, webViewContentHeight - webViewHeight);
        self.tableView.contentOffset = CGPointMake(0, tableViewContentHeight - tableViewHeight);
    }else {
        //do nothing
        NSLog(@"do nothing");
    }
}

#pragma mark - UITableViewDataSouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor redColor];
    }
    
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
}

#pragma mark - private
- (WKWebView *)webView{
    if (_webView == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.scrollView.scrollEnabled = NO;
        _webView.navigationDelegate = self;
    }
    
    return _webView;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.scrollEnabled = NO;
        
    }
    return _tableView;
}

- (UIScrollView *)containerScrollView{
    if (_containerScrollView == nil) {
        _containerScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _containerScrollView.delegate = self;
        _containerScrollView.alwaysBounceVertical = YES;
    }
    
    return _containerScrollView;
}

- (UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
    }
    
    return _contentView;
}

- (UIView *)topView{
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor yellowColor];
    }
    
    return _topView;
}


@end

