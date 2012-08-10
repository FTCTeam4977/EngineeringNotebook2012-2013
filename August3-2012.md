### Meeting Goals:
* Work on code to allow the swerve drive prototype to count rollover
* Add braces to the C-channel holding the modules to provide support
* Provide assistance to MASH's new FRC team

### Coding
The code for the swerve modules has to be able to catch the rollover in the potentiometer, because one turn of the module equals two turns of the pot. The code must also be able to determine clockwise or counterclockwise turns are better for the given direction.

The code tracks the module rollover by looking at the difference between the last value read from the potentiometer and the current value. If the difference is too large, it adds an increment to the count. The absolute position is determined using a formula similar to current+(maxValue*counts)

### Braces
The braces that were designed to support the small C brackets we originally used to mount the modules (See July 7th, 2012) were repurposed to provide support for the C-channel that is now used. There was minor flex in the channel, leading to slip in the module's rotation. The braces provide a solid support to keep this from occuring.

### Assist
We provided coding help to the FRC team started by MASH.
