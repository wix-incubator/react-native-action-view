//
//  SwipeActionViewManager.m
//  SwipeActionView
//
//  Created by Leo Natan on 27/09/2016.
//
//

#import "SwipeActionViewManager.h"
#import "MGSwipeView.h"

#if __has_include(<React/RCTConvert.h>)
#import <React/RCTConvert.h>
#else
#import "RCTConvert.h"
#endif

static NSString* const SwipeActionViewManagerDidSwipeSomeView = @"SwipeActionViewManagerDidSwipeSomeView";

@interface RCMGSwipeView : UIView <MGSwipeViewDelegate>

@property (nonatomic, strong) MGSwipeView* swipeView;
@property (nonatomic, copy) RCTDirectEventBlock onButtonClickHandler;

@end

@implementation RCMGSwipeView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	if(self)
	{
		_swipeView = [[MGSwipeView alloc] initWithFrame:frame];
		_swipeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_swipeView.delegate = self;
		[self addSubview:_swipeView];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_someSwipeViewDidSwipe:) name:SwipeActionViewManagerDidSwipeSomeView object:nil];
	}
	
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) swipeViewWillBeginSwiping:(MGSwipeView *) view
{
	[[NSNotificationCenter defaultCenter] postNotificationName:SwipeActionViewManagerDidSwipeSomeView object:_swipeView];
}

- (void)_someSwipeViewDidSwipe:(NSNotification*)note
{
	if(note.object == _swipeView)
	{
		return;
	}
	
	[_swipeView hideSwipeAnimated:YES];
}


- (void)addSubview:(UIView *)view
{
	if([view isKindOfClass:[MGSwipeView class]])
	{
		[super addSubview:view];
		return;
	}
	
	[_swipeView.swipeContentView addSubview:view];
}

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index
{
	if([view isKindOfClass:[MGSwipeView class]])
	{
		[super insertSubview:view atIndex:index];
		return;
	}
	
	[_swipeView.swipeContentView insertSubview:view atIndex:index];
}

@end

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
	RCMGSwipeView* _swipeView = [RCMGSwipeView new];
	
	_swipeView.swipeView.rightSwipeSettings.transition = _swipeView.swipeView.leftSwipeSettings.transition = MGSwipeTransitionStatic;
	_swipeView.swipeView.rightSwipeSettings.enableSwipeBounces = _swipeView.swipeView.leftSwipeSettings.enableSwipeBounces = YES;
	_swipeView.swipeView.rightExpansion.fillOnTrigger = _swipeView.swipeView.leftExpansion.fillOnTrigger = YES;
	
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

RCT_CUSTOM_VIEW_PROPERTY(leftSwipeSettings, NSDictionary, RCMGSwipeView)
{
	[self setSwipeSettingsTo:view.swipeView.leftSwipeSettings json:json];
}
RCT_CUSTOM_VIEW_PROPERTY(rightSwipeSettings, NSDictionary, RCMGSwipeView)
{
	[self setSwipeSettingsTo:view.swipeView.rightSwipeSettings json:json];
}

RCT_CUSTOM_VIEW_PROPERTY(leftExpansionSettings, NSDictionary, RCMGSwipeView)
{
	[self setExpansionSettingsTo:view.swipeView.leftExpansion json:json];
}
RCT_CUSTOM_VIEW_PROPERTY(rightExpansionSettings, NSDictionary, RCMGSwipeView)
{
	[self setExpansionSettingsTo:view.swipeView.rightExpansion json:json];
}

- (void)_handleButtonsForKeyPath:(NSString*)keyPath view:(RCMGSwipeView*)view json:(id)json
{
	NSMutableArray* newButtons = [NSMutableArray new];
	NSArray<NSDictionary*>* buttonsData = [RCTConvert NSArray:json];
	
	[buttonsData enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull buttonData, NSUInteger idx, BOOL * _Nonnull stop) {
		UIColor* color = buttonData[@"color"] ? [RCTConvert UIColor:buttonData[@"color"]] : [UIColor redColor];
		NSString* title = buttonData[@"title"] ?: NSLocalizedString(@"Title", @"");
		
		MGSwipeButton* button = [MGSwipeButton buttonWithTitle:title backgroundColor:color callback:^BOOL(MGSwipeView *sender) {
			RCMGSwipeView* rcView = (id)[sender superview];
			
			if(rcView.onButtonClickHandler)
			{
				rcView.onButtonClickHandler(@{@"side": keyPath, @"index": @(idx)});
			}
			
			[rcView.swipeView hideSwipeAnimated:YES];
			
			return NO;
		}];
		
		[newButtons addObject:button];
	}];
	
	[view.swipeView setValue:newButtons forKey:keyPath];
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
