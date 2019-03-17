#define kWidth [[UIApplication sharedApplication] keyWindow].frame.size.width
#define kHeight [[UIApplication sharedApplication] keyWindow].frame.size.height

%hook SBDashBoardView
%property (nonatomic, retain) UILabel *batteryText;

- (instancetype)initWithFrame:(CGRect)arg1 {
	self = %orig;
	self.batteryText = [self updateBATTERYLabel: [UILabel alloc]];
	[self addSubview: self.batteryText];
	return self;
}

%new
- (UILabel *)updateBATTERYLabel:(UILabel *)label {
	label = [label initWithFrame:CGRectMake(0, 0, kWidth, 15)];
	label.center = CGPointMake((kWidth * 1/2), (kHeight * 31/32));
	int battery = [[UIDevice currentDevice] batteryLevel] * 100;
	label.text = [NSString stringWithFormat:@"%i%%", battery];
	label.font = [UIFont systemFontOfSize: 10];
	label.textColor = UIColor.whiteColor;
	label.textAlignment = NSTextAlignmentCenter;
	return label;
}

- (void)layoutSubviews {
	%orig;
	self.batteryText = [self updateBATTERYLabel: self.batteryText];
}

%end
