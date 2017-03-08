#React Native Action View

`react-native-action-view` is an easy to use component that allows to display swipeable buttons with a variety of transitions.

<p align="center"><img src="https://raw.githubusercontent.com/MortimerGoro/MGSwipeTableCell/master/readme-assets/static.gif" /></p>

###Using

Import the component:

```js
import { SwipeActionView } from 'react-native-action-view';
```

And then use the component:

```js
<SwipeActionView rightExpansionSettings={{buttonIndex: 0}}
                 leftExpansionSettings={{buttonIndex: 0}} 
                 rightButtons={[{title: 'Red', color: 'rgb(255, 0, 0)', callback: () => {alert('Red button tapped.');}}, 
                                {title: 'Green', color: 'rgb(0, 255, 0)', callback: () => {alert('Green button tapped.');}},
                                {title: 'Blue', color: 'rgb(0, 0, 255)', callback: () => {alert('Blue button tapped.');}}]}
                 leftButtons={[{title: 'Red', color: 'rgb(255, 0, 0)', callback: () => {alert('Red button tapped.');}}, 
                                {title: 'Green', color: 'rgb(0, 255, 0)', callback: () => {alert('Green button tapped.');}},
                                {title: 'Blue', color: 'rgb(0, 0, 255)', callback: () => {alert('Blue button tapped.');}}]}
                >
  <Text style={styles.welcome}>
    Welcome to React Native!
  </Text>
  <Text style={styles.instructions}>
    To get started, swipe this view.
  </Text>
  <Text style={styles.instructions}>
    Tap on a button or swipe fully.
  </Text>
</SwipeActionView>
```

###Configuration

Possible props are:

- `leftButtons`, `rightButtons`
  - `title` or `image`, `color`, `callback`
- `leftExpansionSettings`, `rightExpansionSettings` - Control the button expansion settings
  - `buttonIndex` - The button to expand (Number)
  - `fillOnTrigger` - Whether to fill the button upon expansion (Boolean)
  - `threshold` - The treshold, in points, before expansion begins (Number)
- `leftSwipeSettings`, `rightSwipeSettings` - Control swipe settings
  - `transition` - The transition type (String)
    - Available types: `"static"` (default), `"border"`, `"drag"`, `"clipCenter"`, `"rotate3d"`, `"grow"`
  - enableSwipeBounces - Controls if the swipe motion bounces or not (Boolean)
  
##Transitions Types

###Border

<p align="center"><img src="https://raw.githubusercontent.com/MortimerGoro/MGSwipeTableCell/master/readme-assets/border.gif" /></p>

###Clip

<p align="center"><img src="https://raw.githubusercontent.com/MortimerGoro/MGSwipeTableCell/master/readme-assets/clip.gif" /></p>

###Rotate3D

<p align="center"><img src="https://raw.githubusercontent.com/MortimerGoro/MGSwipeTableCell/master/readme-assets/3d.gif" /></p>

###Static

<p align="center"><img src="https://raw.githubusercontent.com/MortimerGoro/MGSwipeTableCell/master/readme-assets/static.gif" /></p>

###Drag

<p align="center"><img src="https://raw.githubusercontent.com/MortimerGoro/MGSwipeTableCell/master/readme-assets/drag.gif" /></p>
