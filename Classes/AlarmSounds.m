//
//  AlarmSoundsView.m
//  Remindly
//
//  Created by Nathan Stitt on 3/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlarmSounds.h"
#import "AlarmPopUpController.h"
#import <AudioToolbox/AudioServices.h>

@implementation AlarmSounds

-(id)initWithAlarmView:(AlarmPopUpController*)view frame:(CGRect)frame
{
    self = [super initWithStyle: UITableViewStyleGrouped ];
    if (self) {

    }
    return self;
}

-(void)viewDidLoad {
    [ super viewDidLoad ];
    self.view.backgroundColor = [ UIColor blackColor ];
}

-(void) setFromNote:(Note*)n {
    snd = n.soundTag;
}

-(void) saveToNote: (Note*)note{
    note.soundTag = snd;
}

- (void)dealloc
{
    [super dealloc];
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return SOUND_TYPE_MAX;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    // id cell = [ tableView cellForRowAtIndexPath:indexPath ];
    

}

//- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    return snd == indexPath.row ?  UITableViewCellAccessoryCheckmark  : UITableViewCellAccessoryNone;
//}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return 36.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    snd = indexPath.row;
    [ tableView reloadData ];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [ player release ];
}

-(void)playSound:(UIButton*)btn {
    UITableViewCell *cell = ( (UITableViewCell*) btn.superview.superview );
    NSIndexPath *indexPath = [ self.tableView indexPathForCell:cell ];
    NSLog(@"Row: %d", indexPath.row );
    
    if ( indexPath.row > 1 ){
        NSString *path = [[NSBundle mainBundle] pathForResource:[ NSString stringWithFormat:@"%d", indexPath.row ] ofType:@"caf"];
        if ( path ){
            AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
            player.delegate = self;
            [ player play ];
        }

    }


}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [ tableView dequeueReusableCellWithIdentifier:@"SoundsCell" ];
    UILabel *label;
    if (cell == nil) {
        cell = [[[ UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: @"SoundsCell" ] autorelease];
        UIButton *btn = [ UIButton buttonWithType:UIButtonTypeCustom ];
        btn.frame = CGRectMake( 8, 3, 30, 30);
        [btn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal ];
        btn.backgroundColor = [ UIColor clearColor ];
        [btn addTarget:self action:@selector(playSound:) forControlEvents: UIControlEventTouchUpInside ];
        [ cell.contentView addSubview: btn ];        
        label = [[[ UILabel alloc ] initWithFrame:CGRectMake(45, 0, 200, 30) ] autorelease];
        [ cell.contentView addSubview:label ];
    } else {
        label = [cell.contentView.subviews objectAtIndex:1 ];
    }
    cell.accessoryType = snd == indexPath.row ?  UITableViewCellAccessoryCheckmark  : UITableViewCellAccessoryNone;
    cell.tag = indexPath.row;
    switch ( indexPath.row ) {
        case SOUND_VOICE_TYPE:
            label.text = @"Verbal";
            break;
        case SOUND_SYSTEM_DEF_TYPE:
            label.text = @"System Default";
            break;
        case SOUND_BELL_TYPE:
            label.text = @"Bell";
            break;
        case SOUND_MELODY_TYPE:
            label.text = @"Melody";
            break;
        case SOUND_CHIRP_TYPE:
            label.text = @"Chirp Chrip";
            break;
        case SOUND_ROBOT_TYPE:
            label.text = @"Computer Bloop";
            break;
        case SOUND_TIMER_TYPE:
            label.text = @"Electronic Timer";
            break;
        case SOUND_KLAXOM_TYPE:
            label.text = @"Klaxon";
            break;
        default:
            break;
    }
    
    return cell;
}

@end
