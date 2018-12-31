# Samples.ExtendingUI

> --------------------- ------------------------------------------------------------------------------------------
> __Revision__          [REVISION_LABEL](REVISION_URL)
> __Keywords__          Android
> __See also__          
> --------------------- ------------------------------------------------------------------------------------------

## Overview

This is an Android-specific sample.

This project demonstrates how to access the Corona activity's overlay view so that you can add your own UI content on top of the main Corona view.

## Code Walkthrough

### Android

* The Android "Application" class is overridden in this application to listen for when the Corona runtime starts up, which is your opportunity to access the Corona activity and access its overlay view.  See the "CoronaApplication.java" file.
* Once the Corona runtime has been loaded started, the CoronaEnvironment.getCoronaActivity() method will then provide a reference to the currently running Corona activity.
* The CoronaActivity.getOverlayView() returns an Android FrameLayout view which is displayed on top of the main OpenGL view that the Corona project normally renders to.  You should add your own views to this overlay view.  Views will be rendered in the order that you added them to this overlay view.  That is, the first view added will be at the back of the z-order.
* Note that the first view object contained in Corona's overlay view is used to contain native UI objects that were created in Corona's Lua scripts.  You should never remove this view.  That said, if you want your own views to be drawn behind the native UI objects created by Corona, then you will need to add them to the front of Corona's overlay view list.


