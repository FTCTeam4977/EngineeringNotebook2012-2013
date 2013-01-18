### Meeting Goals:
* Improve Swerve Driving

Previously, the swerve drive was using positions obtained from the continous rotation potentiometers for the "current" position fed to the PID loops. We noticed that the deadband ( unresponsive region ) in these potentiometers was rather small, and our hope was that it would not affect driving.
This is not the case. When either side's target position is close to the rollover point, the modules swing wildly from about 1020 to 10. The result is the drivetrain becomes completely uncontrollable.

One solution is to have the steering code avoid moving the modules to the rollover point. We decided against this option because we were afraid it would hurt the fluidity of the swerve and further degrade driving performance.

After some brainstorming, we found the ideal solution to our issue. Our idea involves the use of both the potentiometers and incremental TETRIX encoders on the rotation motors. Essentially, the potentiometer position is converted to the scale of the TETRIX encoders using a linear relation, then the TETRIX encoders increment the value to obtain an absolute and gapless position.
We also added a zeroing stage where the robot will rotate the modules as close to the modpoint of the potentiometers as possible to ensure accuracy before calculating the encoder offset.

Below is the revised initModuleSet function, which is implemented in LordSwerve.c 

<pre>
void initModuleSet(SwerveSide side, tMotor turnMotor, int potOffset, float P, float I, float D, tMotor driveMotor)
{
	driveModules[side].turnMotor = turnMotor;

	initPID(driveModules[side].turnPID, P, I, D);
	driveModules[side].turnPID.continous = true;
	driveModules[side].turnPID.maxInput = 2880;
	driveModules[side].driveReversed = false;
	driveModules[side].driveMotor = driveMotor;
	driveModules[side].potOffset = potOffset;

	PID zeroPID;
	initPID(zeroPID, 0.7, 0.001);
	zeroPID.target = 512;
	bool zeroed = false;
	int loopsStable = 0;
	while ( !zeroed )
	{
		int rate = calcPID(zeroPID, (1024-(HTSPBreadADC(proto, (int)side, 10)+potOffset)));
		motor[turnMotor] = rate;
		motor[driveMotor] = -(rate/2);
		if ( abs(zeroPID.error) < 10 )
			loopsStable++;
		zeroed = (loopsStable>20);
	}
	motor[turnMotor] = 0;
	motor[driveMotor] = 0;

	driveModules[side].positionOffset = (1024-(HTSPBreadADC(proto, (int)side, 10)+potOffset))*2.8125;

	nMotorEncoder[driveMotor] = 0;
	nMotorEncoder[turnMotor] = 0;
}
</pre>
