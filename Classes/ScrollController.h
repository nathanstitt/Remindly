//
//  ScrollViewPreviewViewController.h
//
//  Created by Björn Sållarp on 7/14/10.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import <UIKit/UIKit.h>
#import "PreviewScrollView.h"
#import "TapImage.h"
#import "Note.h"

@class MainViewController;

@interface ScrollController : UIViewController<PreviewScrollViewDelegate> {
	PreviewScrollView *scrollViewPreview;
	UIPageControl *pageControl;
	NSMutableArray *notes;
	MainViewController *mainView;
}

-(void) reload:(Note*)note;
-(void) selectNote:(Note*)note;
-(void) addNotes:(NSArray*)notes;
-(void) deleteNote:(Note*)note;
-(void) addNote:(Note*)note;
-(void) pageChanged:(NSInteger)index;
-(void) noteWasSelected:(Note*)note;
-(id)   initWithMainView:(MainViewController*)mv;

@property (nonatomic, retain) NSArray *scrollPages;
@property (nonatomic, retain) IBOutlet PreviewScrollView *scrollViewPreview;

@end

