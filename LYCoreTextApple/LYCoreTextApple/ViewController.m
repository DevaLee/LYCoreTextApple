//
//  ViewController.m
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/15.
//  Copyright © 2020 LY. All rights reserved.
//

#import "ViewController.h"
#import "CTDisplayView.h"
#import "CTFrameParserConfig.h"
#import "CTFrameParser.h"
#import "UIView+frameAdjust.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupUserInterface];
    
    
    
}

-(void)setupUserInterface {
    
    CTDisplayView *displayView = [[CTDisplayView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:displayView];
    
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
    config.width = displayView.frame.size.width;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"json"];
    CoreTextData *data = [CTFrameParser parseTemplateFile:path config:config];
    displayView.data = data;
    displayView.y = 20;
    displayView.height = data.height + 20;
    displayView.backgroundColor = [UIColor whiteColor];
    
    

}


@end
