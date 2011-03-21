//
//  AlarmSoundsView.h
//  Remindly
//
//  Created by Nathan Stitt on 3/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@class AlarmPopUpController;


@interface AlarmSounds : UITableViewController {
    NoteSoundType snd;

}

-(id)initWithAlarmView:(AlarmPopUpController*)view frame:(CGRect)frame;

-(void) setFromNote:(Note*)note;
-(void) saveToNote: (Note*)note;

@end
