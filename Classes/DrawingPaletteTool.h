//
//  DrawingPaletteTool.h
//  Remindly
//
//  Created by Nathan Stitt on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DrawingPaletteTool : UIButton {
    NSInteger drawingWidth;
}

+(id)withImage:(UIImage*)image frame:(CGRect)frame;

@property (nonatomic) NSInteger drawingWidth;

@end
