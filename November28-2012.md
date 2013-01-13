### Meeting Goals:
* Programming for lift
* Programming for arm/roller claw

For both the lift and arm we implemented a PID control loop. This allowed us to have one button "tap" pre-sets that take the mechanisms to the position we want. This also makes moving eather mechanism in autonomous extreamly easy.

For the PID math, we used an improved version of our custom 2011 PID library.

We used incremental TETRIX encoders on both mechanisms. The fact that they are "incremental" means that they will reset their position to zero when the robot looses power. This means that we need to return both mechanisms to a point where all positions will be realitive to at the beginning of each match.
Idealy, we would use an absolute measurement source like a potentiometer, however the difficulty to mount them in this specific situation was very high compared to the benefits they offered over an encoder.

From a code structure standpoint, we took the same library approach we did when designing the swerve drive. Each mechanism has an init function that gets called when the program starts, a update function that handles setting the motor values and interacting with the PID library, and a function to set the mechanism's target position.

### Lift PID constants
Rather than spending the remaineder of the day getting the lift D constand perfect, we decided to modifiy the P constant based on the directon of the lift. This allowed us to get some of the effects of the oscillation cancellation that the differential offers, while not detracting too much time from drive practice.


Below is the lift library. It's operator interface implementation can be found in the back of the notebook in Teleop.c

<pre>
#ifndef Lift_h
#define Lift_h

PID lift;

void initLift()
{
	initPID(lift);
	lift.target = nMotorEncoder[elevatorLeft];
}

void updateLift()
{
	if ( lift.target < lift.current ) // going up
		lift.Kp = 0.6;
	else if ( lift.target > lift.current )
		lift.Kp = 0.3;
	int liftRate = calcPID(lift, nMotorEncoder[elevatorLeft]);
	if ( abs(liftRate) < 50 )
		liftRate = 0;
	motor[elevatorRight] = -liftRate;
	motor[elevatorLeft] = liftRate;
}

void setLiftPosition(int position)
{
	lift.target = position;
}
#endif
</pre>