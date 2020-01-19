//
//  CTCustomLayer.m
//  LYCoreTextApple
//
//  Created by 9tong on 2020/1/19.
//  Copyright © 2020 LY. All rights reserved.
//

#import "CTCustomLayer.h"
#import <CoreGraphics/CoreGraphics.h>


@implementation CTCustomLayer


-(void)display {
    [super display];
//    CGContextRef context = UIGraphicsGetCurrentContext();
   
}

/*
thread #1, queue = 'com.apple.main-thread', stop reason = breakpoint 1.1
* frame #0: 0x000000010b8eeb7b LYCoreTextApple`-[CTDisplayView drawRect:](self=0x00007f986d404840, _cmd="drawRect:", rect=(origin = (x = 0, y = 0), size = (width = 375, height = 449))) at CTDisplayView.m:116:5
  frame #1: 0x00007fff47d33f37 UIKitCore`-[UIView(CALayerDelegate) drawLayer:inContext:] + 632
  frame #2: 0x00007fff2b13864f QuartzCore`-[CALayer
 :] + 285
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
