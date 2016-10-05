/*
 * MGSwipeTableCell is licensed under MIT license. See LICENSE.md file for more information.
 * Copyright (c) 2014 Imanol Fernandez @MortimerGoro
 */

#import <UIKit/UIKit.h>
#import "MGSwipeButton.h"


/** Transition types */
typedef NS_ENUM(NSInteger, MGSwipeTransition) {
    MGSwipeTransitionBorder = 0,
    MGSwipeTransitionStatic,
    MGSwipeTransitionDrag,
    MGSwipeTransitionClipCenter,
    MGSwipeTransitionRotate3D,
	MGSwipeTransitionGrow
};

/** Compatibility with older versions */
#define MGSwipeTransition3D MGSwipeTransitionRotate3D
#define MGSwipeStateSwippingLeftToRight MGSwipeStateSwipingLeftToRight
#define MGSwipeStateSwippingRightToLeft MGSwipeStateSwipingRightToLeft

/** Swipe directions */
typedef NS_ENUM(NSInteger, MGSwipeDirection) {
    MGSwipeDirectionLeftToRight = 0,
    MGSwipeDirectionRightToLeft
};

/** Swipe state */
typedef NS_ENUM(NSInteger, MGSwipeState) {
    MGSwipeStateNone = 0,
    MGSwipeStateSwipingLeftToRight,
    MGSwipeStateSwipingRightToLeft,
    MGSwipeStateExpandingLeftToRight,
    MGSwipeStateExpandingRightToLeft,
};

/** Swipe state */
typedef NS_ENUM(NSInteger, MGSwipeExpansionLayout) {
    MGSwipeExpansionLayoutBorder = 0,
    MGSwipeExpansionLayoutCenter
};

/** Swipe Easing Function */
typedef NS_ENUM(NSInteger, MGSwipeEasingFunction) {
    MGSwipeEasingFunctionLinear = 0,
    MGSwipeEasingFunctionQuadIn,
    MGSwipeEasingFunctionQuadOut,
    MGSwipeEasingFunctionQuadInOut,
    MGSwipeEasingFunctionCubicIn,
    MGSwipeEasingFunctionCubicOut,
    MGSwipeEasingFunctionCubicInOut,
    MGSwipeEasingFunctionBounceIn,
    MGSwipeEasingFunctionBounceOut,
    MGSwipeEasingFunctionBounceInOut
};

/**
 * Swipe animation settings
 **/
@interface MGSwipeAnimation : NSObject
/** Animation duration in seconds. Default value 0.3 */
@property (nonatomic, assign) CGFloat duration;
/** Animation easing function. Default value EaseOutBounce */
@property (nonatomic, assign) MGSwipeEasingFunction easingFunction;
/** Override this method to implement custom easing functions */
-(CGFloat) value:(CGFloat) elapsed duration:(CGFloat) duration from:(CGFloat) from to:(CGFloat) to;

@end

/**
 * Swipe settings
 **/
@interface MGSwipeSettings: NSObject
/** Transition used while swiping buttons */
@property (nonatomic, assign) MGSwipeTransition transition;
/** Size proportional threshold to hide/keep the buttons when the user ends swiping. Default value 0.5 */
@property (nonatomic, assign) CGFloat threshold;
/** Optional offset to change the swipe buttons position. Relative to the view border position. Default value: 0 **/
@property (nonatomic, assign) CGFloat offset;
/** Top margin of the buttons relative to the contentView */
@property (nonatomic, assign) CGFloat topMargin;
/** Bottom margin of the buttons relative to the contentView */
@property (nonatomic, assign) CGFloat bottomMargin;

/** Animation settings when the swipe buttons are shown */
@property (nonatomic, strong) MGSwipeAnimation * showAnimation;
/** Animation settings when the swipe buttons are hided */
@property (nonatomic, strong) MGSwipeAnimation * hideAnimation;
/** Animation settings when the view is stretched from the swipe buttons */
@property (nonatomic, strong) MGSwipeAnimation * stretchAnimation;

/** Property to read or change swipe animation durations. Default value 0.3 */
@property (nonatomic, assign) CGFloat animationDuration DEPRECATED_ATTRIBUTE;

/** If true the buttons are kept swiped when the threshold is reached and the user ends the gesture
 * If false, the buttons are always hidden when the user ends the swipe gesture
 */
@property (nonatomic, assign) BOOL keepButtonsSwiped;

/** If true the view is not swiped, just the buttons **/
@property (nonatomic, assign) BOOL onlySwipeButtons;

/** If NO the swipe bounces will be disabled, the swipe motion will stop right after the button */
@property (nonatomic, assign) BOOL enableSwipeBounces;

@end


/**
 * Expansion settings to make expandable buttons
 * Swipe button are not expandable by default
 **/
@interface MGSwipeExpansionSettings: NSObject
/** index of the expandable button (in the left or right buttons arrays) */
@property (nonatomic, assign) NSInteger buttonIndex;
/** if true the button fills the view on trigger, else it bounces back to its initial position */
@property (nonatomic, assign) BOOL fillOnTrigger;
/** Size proportional threshold to trigger the expansion button. Default value 1.5 */
@property (nonatomic, assign) CGFloat threshold;
/** Optional expansion color. Expanded button's background color is used by default **/
@property (nonatomic, strong) UIColor * expansionColor;
/** Defines the layout of the expanded button **/
@property (nonatomic, assign) MGSwipeExpansionLayout expansionLayout;
/** Animation settings when the expansion is triggered **/
@property (nonatomic, strong) MGSwipeAnimation * triggerAnimation;

/** Property to read or change expansion animation durations. Default value 0.2 
 * The target animation is the change of a button from normal state to expanded state
 */
@property (nonatomic, assign) CGFloat animationDuration;
@end


/** helper forward declaration */
@class MGSwipeView;

/** 
 * Optional delegate to configure swipe buttons or to receive triggered actions.
 * Buttons can be configured inline when the view is created instead of using this delegate,
 * but using the delegate improves memory usage because buttons are only created in demand
 */
@protocol MGSwipeViewDelegate <NSObject>

@optional
/**
 * Delegate method to enable/disable swipe gestures
 * @return YES if swipe is allowed
 **/
-(BOOL) swipeView:(MGSwipeView*) view canSwipe:(MGSwipeDirection) direction fromPoint:(CGPoint) point;
-(BOOL) swipeView:(MGSwipeView*) view canSwipe:(MGSwipeDirection) direction DEPRECATED_ATTRIBUTE; //backwards compatibility

/**
 * Delegate method invoked when the current swipe state changes
 @param state the current Swipe State
 @param gestureIsActive YES if the user swipe gesture is active. No if the uses has already ended the gesture
 **/
-(void) swipeView:(MGSwipeView*) view didChangeSwipeState:(MGSwipeState) state gestureIsActive:(BOOL) gestureIsActive;

/**
 * Called when the user clicks a swipe button or when a expandable button is automatically triggered
 * @return YES to autohide the current swipe buttons
 **/
-(BOOL) swipeView:(MGSwipeView*) view tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion;
/**
 * Delegate method to setup the swipe buttons and swipe/expansion settings
 * Buttons can be any kind of UIView but it's recommended to use the convenience MGSwipeButton class
 * Setting up buttons with this delegate instead of using view properties improves memory usage because buttons are only created in demand
 * @param view the MGSwipeView to configure.
 * @param direction The swipe direction (left to right or right to left)
 * @param swipeSettings instance to configure the swipe transition and setting (optional)
 * @param expansionSettings instance to configure button expansions (optional)
 * @return Buttons array
 **/
-(NSArray*) swipeView:(MGSwipeView*) view swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings;

/**
 * Called when the user taps on a swiped view
 * @return YES to autohide the current swipe buttons
 **/
-(BOOL) swipeView:(MGSwipeView *)view shouldHideSwipeOnTap:(CGPoint) point;

/**
 * Called when the view will begin swiping
 * Useful to make view changes that only are shown after the view is swiped open
 **/
-(void) swipeViewWillBeginSwiping:(MGSwipeView *) view;

/**
 * Called when the view will end swiping
 **/
-(void) swipeViewWillEndSwiping:(MGSwipeView *) view;

@end


/**
 * Swipe view class
 * To implement swipe views you have to override from this class
 * You can create the views programmatically, using xibs or storyboards
 */
@interface MGSwipeView : UIView

/** optional delegate (not retained) */
@property (nonatomic, weak) id<MGSwipeViewDelegate> delegate;

/** optional to use contentView alternative. Use this property instead of contentView to support animated views while swiping */
@property (nonatomic, strong, readonly) UIView * swipeContentView;

/** 
 * Left and right swipe buttons and its settings.
 * Buttons can be any kind of UIView but it's recommended to use the convenience MGSwipeButton class
 */
@property (nonatomic, copy) NSArray * leftButtons;
@property (nonatomic, copy) NSArray * rightButtons;
@property (nonatomic, strong) MGSwipeSettings * leftSwipeSettings;
@property (nonatomic, strong) MGSwipeSettings * rightSwipeSettings;

/** Optional settings to allow expandable buttons */
@property (nonatomic, strong) MGSwipeExpansionSettings * leftExpansion;
@property (nonatomic, strong) MGSwipeExpansionSettings * rightExpansion;

/** Readonly property to fetch the current swipe state */
@property (nonatomic, readonly) MGSwipeState swipeState;
/** Readonly property to check if the user swipe gesture is currently active */
@property (nonatomic, readonly) BOOL isSwipeGestureActive;

// default is NO. Controls whether multiple views can be swiped simultaneously
@property (nonatomic) BOOL allowsMultipleSwipe;
// default is NO. Controls whether buttons with different width are allowed. Buttons are resized to have the same size by default.
@property (nonatomic) BOOL allowsButtonsWithDifferentWidth;
//default is YES. Controls whether swipe gesture is allowed when the touch starts into the swiped buttons
@property (nonatomic) BOOL allowsSwipeWhenTappingButtons;
//default is YES. Controls whether swipe gesture is allowed in opposite directions. NO value disables swiping in opposite direction once started in one direction
@property (nonatomic) BOOL allowsOppositeSwipe;
/* default is NO. Controls whether dismissing a swiped view when tapping outside of the view generates a real touch event on the other view.
 Default behaviour is the same as the Mail app on iOS. Enable it if you want to allow to start a new swipe while a view is already in swiped in a single step.  */
@property (nonatomic) BOOL touchOnDismissSwipe;

/** Optional background color for swipe overlay. If not set, its inferred automatically from the view contentView */
@property (nonatomic, strong) UIColor * swipeBackgroundColor;
/** Property to read or change the current swipe offset programmatically */
@property (nonatomic, assign) CGFloat swipeOffset;

/** Utility methods to show or hide swipe buttons programmatically */
-(void) hideSwipeAnimated: (BOOL) animated;
-(void) hideSwipeAnimated: (BOOL) animated completion:(void(^)(BOOL finished)) completion;
-(void) showSwipe: (MGSwipeDirection) direction animated: (BOOL) animated;
-(void) showSwipe: (MGSwipeDirection) direction animated: (BOOL) animated completion:(void(^)(BOOL finished)) completion;
-(void) setSwipeOffset:(CGFloat)offset animated: (BOOL) animated completion:(void(^)(BOOL finished)) completion;
-(void) setSwipeOffset:(CGFloat)offset animation: (MGSwipeAnimation *) animation completion:(void(^)(BOOL finished)) completion;
-(void) expandSwipe: (MGSwipeDirection) direction animated: (BOOL) animated;

/** Refresh method to be used when you want to update the view contents while the user is swiping */
-(void) refreshContentView;
/** Refresh method to be used when you want to dynamically change the left or right buttons (add or remove)
 * If you only want to change the title or the backgroundColor of a button you can change it's properties (get the button instance from leftButtons or rightButtons arrays)
 * @param usingDelegate if YES new buttons will be fetched using the MGSwipeViewDelegate. Otherwise new buttons will be fetched from leftButtons/rightButtons properties.
 */
-(void) refreshButtons: (BOOL) usingDelegate;

@end

