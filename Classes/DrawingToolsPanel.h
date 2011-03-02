//
//  DrawingToolsPanel.h
//  Remindly
//
//  Created by Nathan Stitt on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DrawingToolsPanel : UIView {
    CGRect lastPos;
    NSMutableArray *colorButtons;
}

@property (nonatomic) BOOL isShowing;

@end
