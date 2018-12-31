# Samples.CustomErrorHandler

> --------------------- ------------------------------------------------------------------------------------------
> __Revision__          [REVISION_LABEL](REVISION_URL)
> __Keywords__          iOS, Android
> __See also__          
> --------------------- ------------------------------------------------------------------------------------------

## Overview

This project demonstrates how to capture Lua errors and uncaught Lua exceptions that are thrown from native code on the Corona runtime thread. 

In the case of Android, uncaught Java exceptions are also caught.

## Code Walkthrough

### iOS

* The `AppCoronaDelegate` implements the `CoronaDelegate` protocol. In particular it implements the method `willLoadMain:` which is your opportunity to modify the Lua state prior to execution of `main.lua`. 
* This method does two things:
    + Registers the `MyTraceback` with the helper function `Corona::Lua::SetErrorHandler()` offered in the Corona Enterprise API
    + Exposes a new function to Lua `myTests.throwException()` to throw an exception.

### Android

* The Android "Application" class is overridden in this application to set the custom Lua error handler and to set the default uncaught exception handler.  See the "CoronaApplication.java" file.
* Note that you can only set an uncaught exception handler to one particular thread at a time.  To catch uncaught exceptions from the Corona runtime's thread, which is the same thread that Lua runs in, then you should set it in the CoronaRuntimeListener's onLoaded() method which is called on the Corona runtime's thread.
* See the "LuaErrorHandlerFunction.java" file on how to code a custom Lua error handler and how to retrieve a Lua stack trace.
* See the "UncaughtExceptionHandler.java" file on how to code an uncaught exception handler.
