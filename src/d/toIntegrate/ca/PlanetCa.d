template GeneralizedCellularAutomataWithFixedNeighborCountStruct(CellType, int NumberOfNeighbors) {
	alias void delegate(CellType* cell, CellType[] cells, size_t[NumberOfNeightbors] neighborIndices) RecalcDelegateType;
	alias size_t[NumberOfNeighbors] delegate(size_t cellIndex) CalcNeighborIndicesDelegateType;

	void recalc(CellType[] cells, RecalcDelegateType recalcCellstate, CalcNeighborIndicesDelegateType calcNeighborIndices) {
		foreach( cellIndex, iterationCell; cells ) {
			recalcCellstate(iterationCell, cells, calcNeighborIndices(cellIndex));
		}
	}
}

struct AtmosphericCell {
	float heatDelta;

	float heat;
	Vector2f wind; // direction and magnitude

	Vector2f windDelta;

	/*
	final @property float windMagnitude() const {
		return wind.magnitude;
	}*/

	final @property Vector2f windDirection() const {
		return wind.normalized;
	}
	
}

enum NumberOfNeightbors = 4;

float maximalWindMagnitude = 50.0f;

float windTransferHeatSpeedFactor = 0.1f;

recalcAtmosphericCell(AtmosphericCell* cell, AtmosphericCell[] cells, size_t[NumberOfNeightbors] neighborIndices) {
	
	Vector2f[NumberOfNeightbors] directionToNeighborCells;

	float[NumberOfNeightbors] cellTransferStrength;

	foreach( cellI; 0..NumberOfNeightbors ) {
		cellTransferStrength[cellI] = cell.windDirection.dot(directionToNeighborCells[cellI]);
	}

	// transfer heat with wind outside
	foreach( cellI; 0..NumberOfNeightbors ) {
		float heatDelta = cellTransferStrength[cellI] * windTransferHeatSpeedFactor * (cell.heat - cells[neighborIndices[cellI]].heat);

		cells[neighborIndices[cellI]].heatDelta -= heatDelta;
		cell.heatDelta += heatDelta;
	}

	// blur wind
	foreach( cellI; 0..NumberOfNeightbors ) {
		// TODO
	}

	// slow down wind (by friction)
	foreach( cellI; 0..NumberOfNeightbors ) {
		// TODO
	}
}