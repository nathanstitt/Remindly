//
//  AlarmSoundsView.h
//  Remindly
//
//  Created by Nathan Stitt on 3/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import <AVFoundation/AVAudioPlayer.h>

@class AlarmPopUpController,ToggleButton;


@interface AlarmSounds : UITableViewController < AVAudioPlayerDelegate > {
    NoteSoundType snd;
    ToggleButton  *playingBtn;
    AVAudioPlayer *player;
}

-(id)initWithAlarmView:(AlarmPopUpController*)view;

-(void) setFromNote:(Note*)note;
-(void) saveToNote: (Note*)note;

@end
