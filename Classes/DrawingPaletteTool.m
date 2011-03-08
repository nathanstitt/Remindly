//
//  DrawingPaletteTool.m
//  Remindly
//
//  Created by Nathan Stitt on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DrawingPaletteTool.h"
#import <QuartzCore/QuartzCore.h> 

@implementation DrawingPaletteTool

@synthesize drawingWidth;


- (void)setupLayers {
    self.layer.cornerRadius = 10.0;
//    self.layer.borderColor = [UIColor redColor].CGColor;
//    self.layer.borderWidth = 1.0f;
    self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.layer.shadowOpacity = 1.5f;
    
    self.layer.shadowRadius = 2.5f;
    self.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.anchorPoint = CGPointMake(0.0f, 0.0f);
    gradient.position = CGPointMake(0.0f, 0.0f);
    gradient.bounds = self.layer.bounds;
    gradient.cornerRadius = 10.0;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithRed:0.82f
                                           green:0.82f
                                            blue:0.82f
                                           alpha:1.0].CGColor,
                       (id)[UIColor colorWithRed:0.52f
                                           green:0.52f
                                            blue:0.52f
                                           alpha:1.0].CGColor,
                       nil];
    
    [self.layer addSublayer:gradient];
}


-(void)setSelected:(BOOL)selected{
    [ super setSelected:selected ];
    if ( selected ){
        self.layer.shadowColor = [UIColor blackColor ].CGColor;
        self.layer.borderWidth = 2.0;
    } else {
        self.layer.shadowColor = [UIColor whiteColor ].CGColor;
        self.layer.borderWidth = 0.0;
    }
}


+(id)withImage:(UIImage*)image frame:(CGRect)frame {
    DrawingPaletteTool *btn = [ DrawingPaletteTool buttonWithType:UIButtonTypeCustom ];
    [ btn setImage:image forState:UIControlStateNormal ];
    [ btn setupLayers ];
    btn.frame = frame;
    return btn;
}



@end
