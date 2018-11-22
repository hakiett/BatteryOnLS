#define kWidth [[UIApplication sharedApplication] keyWindow].frame.size.width
#define kHeight [[UIApplication sharedApplication] keyWindow].frame.size.height

@interface BCBatteryDeviceController {
	NSArray *_sortedDevices;
}

+ (id)sharedInstance;
@end

@interface BCBatteryDevice {
	long long _percentCharge;
	NSString *_name;
}
@end

@interface SBDashBoardView : UIView
@property (nonatomic, retain) UILabel *kietText;
- (UILabel *)updateKIETLabel:(UILabel *)label;
@end

%hook SBDashBoardView
%property (nonatomic, retain) UILabel *kietText;

- (instancetype)initWithFrame:(CGRect)arg1 {
	self = %orig;
	self.kietText = [self updateKIETLabel: [UILabel alloc]];
	[self addSubview: self.kietText];
	return self;
}

%new
- (UILabel *)updateKIETLabel:(UILabel *)label {
	label = [label initWithFrame:CGRectMake(0, 0, kWidth, 15)];
	label.center = CGPointMake((kWidth * 1/2), (kHeight * 31/32));
	BCBatteryDeviceController *bcb = [%c(BCBatteryDeviceController) sharedInstance];
	NSArray *devices = MSHookIvar<NSArray *>(bcb, "_sortedDevices");
	NSMutableString *newMessage = [NSMutableString new];
	for (BCBatteryDevice *device in devices) {
			long long deviceCharge = MSHookIvar<long long>(device, "_percentCharge");
			[newMessage appendString:[NSString stringWithFormat:@"%lld%%\n",deviceCharge]];
		}
	label.text = newMessage;
	label.font = [UIFont systemFontOfSize: 10];
	label.textColor = UIColor.whiteColor;
	label.textAlignment = NSTextAlignmentCenter;
	return label;
}

- (void)layoutSubviews {
	%orig;
	self.kietText = [self updateKIETLabel: self.kietText];
}

%end
