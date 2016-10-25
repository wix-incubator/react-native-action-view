//
//  SwipeActionViewManager.m
//  SwipeActionView
//
//  Created by Leo Natan on 27/09/2016.
//
//

#import "SwipeActionViewManager.h"
#import "MGSwipeView.h"
#import "RCTConvert.h"

@interface RCMGSwipeView : MGSwipeView

@property (nonatomic, copy) RCTDirectEventBlock onButtonClickHandler;

@end

@implementation RCMGSwipeView @end

static NSDictionary* _transitionEnumMapping = nil;

@implementation SwipeActionViewManager

RCT_EXPORT_MODULE()

+ (void)initialize
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_transitionEnumMapping = @{ @"static": @(MGSwipeTransitionStatic),
					 @"border": @(MGSwipeTransitionBorder),
					 @"drag": @(MGSwipeTransitionDrag),
					 @"clipCenter": @(MGSwipeTransitionClipCenter),
					 @"rotate3d": @(MGSwipeTransitionRotate3D),
					 @"grow": @(MGSwipeTransitionGrow),
					 };
	});
}

- (UIView *)view
{
	MGSwipeView* _swipeView = [RCMGSwipeView new];
	
	_swipeView.rightSwipeSettings.transition = _swipeView.leftSwipeSettings.transition = MGSwipeTransitionStatic;
	_swipeView.rightSwipeSettings.enableSwipeBounces = _swipeView.leftSwipeSettings.enableSwipeBounces = YES;
	_swipeView.rightExpansion.fillOnTrigger = _swipeView.leftExpansion.fillOnTrigger = YES;
	
	return _swipeView;
}

- (MGSwipeTransition)_transitionFromString:(NSString*)str
{
	
	
	if(str == nil || _transitionEnumMapping[[str lowercaseString]] == nil)
	{
		return MGSwipeTransitionBorder;
	}
	
	return [_transitionEnumMapping[[str lowercaseString]] integerValue];
}

- (void)setSwipeSettingsTo:(MGSwipeSettings*)settings json:(id)json
{
	NSDictionary* data = [RCTConvert NSDictionary:json];
	
	settings.transition = [self _transitionFromString:data[@"transition"]];
	settings.threshold = data[@"threshold"] ? [data[@"threshold"] doubleValue] : settings.threshold;
	settings.enableSwipeBounces = data[@"enableSwipeBounces"] ? [data[@"enableSwipeBounces"] boolValue] : settings.enableSwipeBounces;
}

- (void)setExpansionSettingsTo:(MGSwipeExpansionSettings*)settings json:(id)json
{
	NSDictionary* data = [RCTConvert NSDictionary:json];

	settings.buttonIndex = data[@"buttonIndex"] ? [data[@"buttonIndex"] integerValue] : settings.buttonIndex;
	settings.fillOnTrigger = data[@"fillOnTrigger"] ? [data[@"fillOnTrigger"] integerValue] : settings.fillOnTrigger;
	settings.threshold = data[@"threshold"] ? [data[@"threshold"] integerValue] : settings.threshold;
}

RCT_EXPORT_VIEW_PROPERTY(swipeBackgroundColor, UIColor)

RCT_CUSTOM_VIEW_PROPERTY(leftSwipeSettings, NSDictionary, MGSwipeView)
{
	[self setSwipeSettingsTo:view.leftSwipeSettings json:json];
}
RCT_CUSTOM_VIEW_PROPERTY(rightSwipeSettings, NSDictionary, MGSwipeView)
{
	[self setSwipeSettingsTo:view.rightSwipeSettings json:json];
}

RCT_CUSTOM_VIEW_PROPERTY(leftExpansionSettings, NSDictionary, MGSwipeView)
{
	[self setExpansionSettingsTo:view.leftExpansion json:json];
}
RCT_CUSTOM_VIEW_PROPERTY(rightExpansionSettings, NSDictionary, MGSwipeView)
{
	[self setExpansionSettingsTo:view.rightExpansion json:json];
}

- (void)_handleButtonsForKeyPath:(NSString*)keyPath view:(RCMGSwipeView*)view json:(id)json
{
	NSMutableArray* newButtons = [NSMutableArray new];
	NSArray<NSDictionary*>* buttonsData = [RCTConvert NSArray:json];
	
	[buttonsData enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull buttonData, NSUInteger idx, BOOL * _Nonnull stop) {
		UIColor* color = buttonData[@"color"] ? [RCTConvert UIColor:buttonData[@"color"]] : [UIColor redColor];
		NSString* title = buttonData[@"title"] ?: NSLocalizedString(@"Title", @"");
		
		MGSwipeButton* button = [MGSwipeButton buttonWithTitle:title backgroundColor:color callback:^BOOL(MGSwipeView *sender) {
			RCMGSwipeView* rcView = (id)sender;
			
			if(rcView.onButtonClickHandler)
			{
				rcView.onButtonClickHandler(@{@"side": keyPath, @"index": @(idx)});
			}
			
			[rcView hideSwipeAnimated:YES];
			
			return NO;
		}];
		
		[newButtons addObject:button];
	}];
	
	[view setValue:newButtons forKey:keyPath];
}

RCT_CUSTOM_VIEW_PROPERTY(leftButtons, NSArray, RCMGSwipeView)
{
	[self _handleButtonsForKeyPath:@"leftButtons" view:view json:json];
}
RCT_CUSTOM_VIEW_PROPERTY(rightButtons, NSArray, RCMGSwipeView)
{
	[self _handleButtonsForKeyPath:@"rightButtons" view:view json:json];
}

RCT_REMAP_VIEW_PROPERTY(onButtonTapped, onButtonClickHandler, RCTDirectEventBlock)

- (NSDictionary<NSString *,id> *)constantsToExport
{
	return @{ @"SwipeTransitions" : _transitionEnumMapping};
}

@end

@interface RCTConvert (SwipeActionView) @end
@implementation RCTConvert (SwipeActionView)

RCT_ENUM_CONVERTER(MGSwipeTransition, _transitionEnumMapping, MGSwipeTransitionBorder, integerValue);

@end
