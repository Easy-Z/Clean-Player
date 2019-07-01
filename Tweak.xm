#import "libcolorpicker.h"

@interface MediaControlsTimeControl : UIView
@property (nonatomic,retain) UILabel * elapsedTimeLabel;
@property (nonatomic,retain) UILabel * remainingTimeLabel;
@end

@interface MediaControlsRoutingButtonView : UIButton
@property (nonatomic,retain) MediaControlsRoutingButtonView * packageView;
@end

@interface _MPUMarqueeContentView : UIView
@end

/*@interface MPVolumeSlider : UISlider
@property (readonly) Class superclass;
@end*/


static NSMutableDictionary *prefs;
static bool elabelEnabled;
//static bool sliderEnabled;
static bool slider2Enabled;
static bool apEnabled;
static NSString *pButtonColor = nil;

static void loadPrefs() {
  prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.eazy-z.cleanplayer.plist"];
   elabelEnabled = [prefs valueForKey:@"elabelEnabled"] ? [[prefs valueForKey:@"elabelEnabled"] boolValue] : YES;
   //sliderEnabled = [prefs valueForKey:@"sliderEnabled"] ? [[prefs valueForKey:@"sliderEnabled"] boolValue] : YES;
   slider2Enabled = [prefs valueForKey:@"slider2Enabled"] ? [[prefs valueForKey:@"slider2Enabled"] boolValue] : YES;
   apEnabled = [prefs valueForKey:@"apEnabled"] ? [[prefs valueForKey:@"apEnabled"] boolValue] : YES;
   pButtonColor = [prefs objectForKey:@"pButtonColor"];
   
}




%hook MediaControlsTimeControl

-(void)layoutSubviews {

    %orig;

     if (elabelEnabled) {
    self.elapsedTimeLabel.hidden = YES;
    self.remainingTimeLabel.hidden = YES;
}

    if (slider2Enabled) {
       	 self.hidden = YES;
  }
	}


%end

%hook PLPlatterCustomContentView 
-(void)setBackgroundColor:(id)arg1 {
  arg1 = LCPParseColorString(pButtonColor, @"#000000");
  %orig(arg1);
}

%end

%hook MediaControlsRoutingButtonView

- (void)layoutSubviews {
    %orig;
    if (apEnabled)
        self.packageView.hidden = YES;
    }

%end

/*%hook _MPUMarqueeContentView
- (void)layoutSubviews {
    %orig;
    self.hidden = YES;
}

%end*/

/*%hook MPVolumeSilder

- (void)layoutSubviews {
    %orig;
    if (sliderEnabled)
        self.superclass.hidden = YES;
    }

%end*/


%ctor {
  loadPrefs();
  CFNotificationCenterAddObserver(
	CFNotificationCenterGetDarwinNotifyCenter(), NULL,
	(CFNotificationCallback)loadPrefs,
	CFSTR("com.eazy-z.cleanplayer/prefChanged"), NULL,
	CFNotificationSuspensionBehaviorDeliverImmediately);
  loadPrefs();
}