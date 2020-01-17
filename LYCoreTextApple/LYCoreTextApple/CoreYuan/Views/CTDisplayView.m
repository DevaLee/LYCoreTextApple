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

-(void)setData:(CoreTextData *)data {
    _data = data;
    self.state = CTDisplayViewStateNormal;
}

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
