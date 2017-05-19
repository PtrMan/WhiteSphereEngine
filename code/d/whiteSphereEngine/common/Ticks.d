module whiteSphereEngine.common.Ticks;

struct Ticks {
	static Ticks makeHoursMinutesSeconds(uint hours, uint minutes, uint seconds) {
		Ticks result;
		result.standardTicks = 0;
		result.standardTicks += (seconds * STANDARDTICKSPERSECOND);
		result.standardTicks += (minutes * 60 * STANDARDTICKSPERSECOND);
		result.standardTicks += (hours * 60 * 60 * STANDARDTICKSPERSECOND);
		return result;
	}

	static Ticks makeHoursMinutesSecondsStandardTicks(uint hours, uint minutes, uint seconds, uint standardTicks) {
		Ticks result;
		result.standardTicks = 0;
		result.standardTicks += standardTicks;
		result.standardTicks += (seconds * STANDARDTICKSPERSECOND);
		result.standardTicks += (minutes * 60 * STANDARDTICKSPERSECOND);
		result.standardTicks += (hours * 60 * 60 * STANDARDTICKSPERSECOND);
		return result;
	}

	protected uint standardTicks;

	static const uint STANDARDTICKSPERSECOND = 60;
}
