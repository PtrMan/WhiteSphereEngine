module physics.ITemporalChange;

/**
 *  Used to capture changing attributes of a DynamicObject
 *
 */
interface ITemporalChange {
	// calculate the maximal inverted mass after a time in seconds
	// for example a spaceship can burn fuel and thus loose weight
	double calcuateMinimalInvMassAfterTime(float sumOfTime);
}
