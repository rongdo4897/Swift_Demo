//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDSettingsItemsGroup.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDSettingsItemsGroup.h"

@implementation SCDSettingsItemsGroup {
    NSArray<id<ISCDToolbarItem>> *_items;
}

@synthesize stackView = _stackView;

- (instancetype)initWithItems:(NSArray<id<ISCDToolbarItem>> *)items {
    self = [super init];
    if (self) {
        _items = items;
        _stackView = [SCIStackView new];
        _stackView.axis = SCILayoutConstraintAxisVertical;
        _stackView.spacing = 5;
#if TARGET_OS_OSX
        _stackView.alignment = NSLayoutAttributeLeft;
#endif
        for (id<ISCDToolbarItem> item in _items) {
            [_stackView addArrangedSubview:[item createView]];
        }
    }
    return self;
}

- (SCIView *)createView {
    return _stackView;
}

@end
