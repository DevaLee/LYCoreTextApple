//
//  CTDisplayView.m
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/17.
//  Copyright © 2020 LY. All rights reserved.
//

#import "CTDisplayView.h"
#import "CoreTextImageData.h"
#import "CoreTextUtil.h"

NSString *const CTDisplayViewImagePressedNotification = @"CTDisplayViewImagePressedNotification";
NSString *const CTDisplayViewLinkPressedNotification = @"CTDisplayViewLinkPressedNotification";

typedef enum CTDisplayViewState: NSInteger {
    CTDisplayViewStateNormal,
    CTDisplayViewTouching,
    CTDisplayViewStateSelecting
}CTDisplayViewState;

@interface CTDisplayView ()
@property (nonatomic,assign) NSInteger selectionStartPosition;
@property (nonatomic,assign) NSInteger selectionEndPosition;
@property (nonatomic,assign) CTDisplayViewState state;
@property (nonatomic,strong) UIImageView *leftSelectionAnchor;
@property (nonatomic,strong) UIImageView *rightSelectionAnchor;
@end

@implementation CTDisplayView


-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupEvents];
    }
    return self;
}

#pragma mark -- set

-(void)setData:(CoreTextData *)data {
    _data = data;
    self.state = CTDisplayViewStateNormal;
}

-(void)setState:(CTDisplayViewState)state {
    if (_state == state) {
        return;
    }
    _state = state;
    if (_state == CTDisplayViewStateNormal) {
        _selectionStartPosition = -1;
        _selectionEndPosition = -1;

    }
}
#pragma mark -- Set up

-(void)setupEvents {
    UITapGestureRecognizer *tapRecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapGestureDetected:)];
    [self addGestureRecognizer:tapRecoginzer];

    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(userLongPressedGestureDected:)];
    [self addGestureRecognizer:longPressRecognizer];

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(userPanGestureDetected:)];
    [self addGestureRecognizer:panGesture];

    self.userInteractionEnabled = YES;
}

#pragma mark -- UITapGestureAction
- (void)userTapGestureDetected:(UITapGestureRecognizer *)tapGesture {
    CGPoint point = [tapGesture locationInView:self];
    if (_state == CTDisplayViewStateNormal) {
        for (CoreTextImageData *imageData in self.data.imageArray) {
            // 翻转坐标系，因为imageData中的坐标是CoreText的坐标系
            CGRect imageRect = imageData.imagePosition;
            CGPoint imagePosition = imageRect.origin;
            imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
            CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
            // 检测点击位置 Point 是否在rect之内
            if (CGRectContainsPoint(rect, point)) {
                NSLog(@"hit image");
                
                NSDictionary *userInfo = @{@"imageData": imageData};
                [[NSNotificationCenter defaultCenter] postNotificationName:CTDisplayViewImagePressedNotification object:self userInfo:userInfo];
                return;
            }
        }
        
        CoreTextLinkData *linkData = [CoreTextUtil touchLinkInView:self atPoint:point data:self.data];
        if (linkData) {
            NSLog(@"hint Link");
            NSDictionary *userInfo = @{@"linkData": linkData};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:CTDisplayViewLinkPressedNotification object:self userInfo:userInfo];
            return;
        }
    }
}

- (void)userLongPressedGestureDected:(UITapGestureRecognizer *)tapGesture {

}

- (void)userPanGestureDetected:(UIPanGestureRecognizer *)panGesture {

}


#pragma mark -- DrawRect

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.data == nil) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if (self.state == CTDisplayViewTouching || self.state == CTDisplayViewStateSelecting) {
        
    }
    CTFrameDraw(_data.ctFrame, context);
    
    for (CoreTextImageData *imageData in self.data.imageArray) {
        UIImage *image = [UIImage imageNamed:imageData.name];
        if (image) {
            CGContextDrawImage(context, imageData.imagePosition, image.CGImage);
        }
    }
    
}

/*
 frame #0: 0x000000010b8eeb7b LYCoreTextApple`-[CTDisplayView drawRect:](self=0x00007f986d404840, _cmd="drawRect:", rect=(origin = (x = 0, y = 0), size = (width = 375, height = 449))) at CTDisplayView.m:116:5
 frame #1: 0x00007fff47d33f37 UIKitCore`-[UIView(CALayerDelegate) drawLayer:inContext:] + 632
 frame #2: 0x00007fff2b13864f QuartzCore`-[CALayer drawInContext:] + 285
 frame #3: 0x00007fff2b002743 QuartzCore`CABackingStoreUpdate_ + 190
 frame #4: 0x00007fff2b141079 QuartzCore`___ZN2CA5Layer8display_Ev_block_invoke + 53
 frame #5: 0x00007fff2b137fd2 QuartzCore`-[CALayer _display] + 2022
 frame #6: 0x00007fff2b14aa10 QuartzCore`CA::Layer::layout_and_display_if_needed(CA::Transaction*) + 502
 frame #7: 0x00007fff2b0917c8 QuartzCore`CA::Context::commit_transaction(CA::Transaction*, double) + 324
 frame #8: 0x00007fff2b0c6ad1 QuartzCore`CA::Transaction::commit() + 643
 frame #9: 0x00007fff47867461 UIKitCore`__34-[UIApplication _firstCommitBlock]_block_invoke_2 + 81
 frame #10: 0x00007fff23bb204c CoreFoundation`__CFRUNLOOP_IS_CALLING_OUT_TO_A_BLOCK__ + 12
 frame #11: 0x00007fff23bb17b8 CoreFoundation`__CFRunLoopDoBlocks + 312
 frame #12: 0x00007fff23bac644 CoreFoundation`__CFRunLoopRun + 1284
 frame #13: 0x00007fff23babe16 CoreFoundation`CFRunLoopRunSpecific + 438
 frame #14: 0x00007fff38438bb0 GraphicsServices`GSEventRunModal + 65
 frame #15: 0x00007fff4784fb48 UIKitCore`UIApplicationMain + 1621
 frame #16: 0x000000010b8f4c2d LYCoreTextApple`main(argc=1, argv=0x00007ffee4311d48) at main.m:18:12
 frame #17: 0x00007fff51a1dc25 libdyld.dylib`start + 1
 frame #18: 0x00007fff51a1dc25 libdyld.dylib`start + 1
 
 
 */


@end
