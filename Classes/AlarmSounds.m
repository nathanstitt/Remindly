//
//  AlarmSoundsView.m
//  Remindly
//
//  Created by Nathan Stitt on 3/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlarmSounds.h"
#import "AlarmPopUpController.h"

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
    return 40.0;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    // id cell = [ tableView cellForRowAtIndexPath:indexPath ];
    

}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    return snd == indexPath.row ?  UITableViewCellAccessoryCheckmark  : UITableViewCellAccessoryNone;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    snd = indexPath.row;
    [ tableView reloadData ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [ tableView dequeueReusableCellWithIdentifier:@"SoundsCell" ];
    if (cell == nil) {
        cell = [[[ UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: @"SoundsCell" ] autorelease];
    }
    switch ( indexPath.row ) {
        case 0:
            cell.textLabel.text = @"Human Voice";
            break;
        case 1:
            cell.textLabel.text = @"Bell";
            break;
        case 2:
            cell.textLabel.text = @"Trumpet";
            break;
        case 3:
            cell.textLabel.text = @"System Default";
            break;
        default:
            break;
    }
    return cell;
}

@end
