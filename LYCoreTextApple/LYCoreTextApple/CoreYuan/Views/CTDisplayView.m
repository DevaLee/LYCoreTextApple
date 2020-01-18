//
//  CTDisplayView.m
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/17.
//  Copyright © 2020 LY. All rights reserved.
//

#import "CTDisplayView.h"
#import "CoreTextImageData.h"

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


@end
