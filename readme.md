##Dropcloth.ahk

This script will make all the other windows other than the currently active window fade behind a window of black.
This is useful for demos, screencasts, or just removing distractions of all the other applications you have running.

##MultiMonMan.ahk

This one is incredible. You have to have multiple monitors to get this to work. However, Skype didn't do well recording this.

Here's the deal...fire this up while you have more than one desktop. Now, you can close the one that is your current desktop monitor.
You still have your "extended" monitor on your main desktop. This is a great way to work with an extended monitor behind you in a demo,
but have the screen right in front of you as another "window". You have to see it to believe it.

##NewHostString.ahk

This is the script I talk about in the show for building my demo scripts.

Simply highlight the text you want AHK to type for you, then press Shift Window H (or modify it if you wish) to copy to the clipboard ready for a "keyphrase".

Next, modify the keyphrase. If you don't you AHK, it's the part "keyphrase" part between the colons:

```
:R:keyphrase::this is the code that gets typed
; for example
:R:ttyl::Talk to you later
```
> Note: you can use a semi-colon to make comments

##TestNamingMode.ahk

Finally, I use this one in combination with the testm/testc snippets in Visual Studio.
When I am typing long test names, I use the BDD style naming with underscores in the method name.
This can become cumbersome to constantly type the underscore character, so this quick AHK will 
automatically replace the "spacebar" with an "underscore" until you press enter or some other method
name ending character.