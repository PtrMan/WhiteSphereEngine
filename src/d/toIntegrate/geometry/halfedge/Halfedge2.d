module geometry.HalfEdge;

// implementation of the half edge datastructure without explicit need for GC
// see http://www.flipcode.com/archives/The_Half-Edge_Data_Structure.shtml
// difference to flipcode: orgin instead of destination vertex is stored
struct Edge(VertexAttributeType, FaceAttributeType) {
	public alias Edge!(VertexAttributeType, FaceAttributeType) EdgeType;
	public alias Face!(VertexAttributeType, FaceAttributeType) FaceType;
	public alias Vertex!(VertexAttributeType, FaceAttributeType) VertexType;

	VertexType* origin;
	EdgeType* invert; // oppositly oriented adjacent halfedge
	FaceType* face; // face of the half edge
	EdgeType* next, previous; // nextand previous half-edge of the face

	public final @property bool isBoundary()  {
		return invert is null;
	}

	public static void checkPair(EdgeType*[2] edges) {
		assert(edges[0] !is edges[1]); // must not be the same
		
		if( !edges[0].isBoundary && !edges[1].isBoundary ) {
			assert(edges[0].invert is edges[1] && edges[1].invert is edges[0]); // pair pointers must match up
		}
	}

	// checks if an edge appears if the next pointers are followed, must be the case
	public static void checkLoop(EdgeType* entry, size_t maxloopDetectionCycle = 64) {
		EdgeType* current = entry.next;

		foreach( i; 0..maxloopDetectionCycle ) {
			assert(current !is null);

			bool currentWasEntry = current is entry;
			EdgeType* oldCurrent = current;

			current = current.next;
			assert(current !is null);
			assert(current.previous is oldCurrent);

			// we do this test delayed because we have to check the previous of the entry
			if( currentWasEntry ) {
				return; // everything is fine
			}

		}

		assert(false, "No loop detected!");
	}

	public static void checkSameFace(EdgeType* entry, size_t maxloopDetectionCycle = 64) {
		checkLoop(entry, maxloopDetectionCycle);

		FaceType* compareFace = entry.face;
		assert(compareFace != null);

		EdgeType* current = entry.next;

		foreach( i; 0..maxloopDetectionCycle ) {
			assert(current !is null);
			assert(current.face is compareFace); // check if the face is the same
			if( current is entry ) {
				break; // everything is fine
			}
			current = current.next;
		}
	}
}

struct Vertex(VertexAttributeType, FaceAttributeType) {
	VertexAttributeType attribute;
	Edge!(VertexAttributeType, FaceAttributeType)* edge; // we just need one, because we can enumerate all others later
}

struct Face(VertexAttributeType, FaceAttributeType) {
	Edge!(VertexAttributeType, FaceAttributeType)* edge; // one of the half edges bordering the face
	FaceAttributeType attribute;
}

// TODO< iteration >

// iterates over all adjacent (neightbor) vertices
// algorithm:
// - get vertex of halfedge
// - save invert
// - save origin
// repeat
//    (1) use neighbor
//    (2) get next, store as neightbor
//    (3) invert, to get to halfedge back to the vertex
//    (4) go back to origin

// untested!
void enumerateAdjacentVertices(VertexAttributeType, FaceAttributeType)(Edge!(VertexAttributeType, FaceAttributeType)* entryEdge,  void delegate(VertexAttributeType vertexAttribute) adjacentVertexCallback) {
	alias Edge!(VertexAttributeType, FaceAttributeType) EdgeType;
	alias Vertex!(VertexAttributeType, FaceAttributeType) VertexType;

	EdgeType* iterationEdge = entryEdge;

	for(;;) {
		EdgeType* edgeWayBack = iterationEdge.invert;
		VertexType* vertex = edgeWayBack.origin;

		iterationEdge = edgeWayBack.next;
		if( iterationEdge is entryEdge ) {
			return;
		}
		adjacentVertexCallback(vertex.attribute);
	}
}

void x(Edge!(int, int)* entryEdge, void delegate(int vertexAttribute) adjacentVertexCallback) {
	enumerateAdjacentVertices(entryEdge, adjacentVertexCallback)
}

unittest {
	alias VertexAttributeType int;
	alias FaceAttributeType int; // dummy

	/////
	// build 3 halfedges which have one vertex in common

	alias Edge!(VertexAttributeType, FaceAttributeType) EdgeType;
	alias Vertex!(VertexAttributeType, FaceAttributeType) VertexType;
	
	EdgeType*[3] edges, backedges;
	edges[0] = new EdgeType();
	edges[1] = new EdgeType();
	edges[2] = new EdgeType();
	backedges[0] = new EdgeType();
	backedges[1] = new EdgeType();
	backedges[2] = new EdgeType();

	VertexType*[3] vertices;
	vertices[0] = new VertexType();
	vertices[1] = new VertexType();
	vertices[2] = new VertexType();

	foreach(i;0..3) {
		vertices[i].attribute = i+1; // we leave 0 out because 0 is the default, testing for this is then stupid
	}


	// wire up vertices
	foreach(i;0..3) {
		edges[i].origin = vertices[i];
	}

	// wire up neightbors of edges
	foreach(i;0..3) {
		edges[i].invert = backedges[i];
		backedges[i].invert = edges[i];
	}

	/////
	// now we apply the enumerateAdjacentVertices() algorithm on it and we should have exactly the 3 neightbors

	// TODO
}
