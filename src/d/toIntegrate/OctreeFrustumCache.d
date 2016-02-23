/**
 * Abstraction for the cachelogic of an frustum which looks into an Octree
 * 
 * Checks if Ocree leaf objects are already in the cache, if not they get added to a array
 *
 *
 */
module OctreeFrustumCache;

import Octree : OctreeNode, Octree;
import Hashtable : Hashtable;
import ProjectionContext;

class OctreeFrustumCache(NumericType, ContentType) {
	// whats inside the cache isn't required to get cached
	public Hashtable!ContentType cacheTable;

	// which elements need to get loaded into the cache
	public Hashtable!ContentType toCacheTable;

	public final void doFrustumCullingAndLookupInCacheRecursive(ProjectionContext!NumericType projectionContext, OctreeNode!(NumericType,ContentType) node) {
		if( node is null ) {
			return;
		}

		bool testChildren = true;
		bool isNodeInView = Octree.isNodeInView(projectionContext, node, testChildren);
		if( isNodeInView ) {
			if( node.isLeaf ) {
				// check cache for leaf objects
				foreach( ContentType iterationContent; node.leafObjects ) {
					if( !cacheTable.contains(iterationContent) ) {
						insertIntoToCacheTableIfNotAlreadyPresent(iterationContent);
					}
				}
			}
		}

		if( testChildren ) {
			foreach( OctreeNode!(NumericType,ContentType) childrenNode; node.childrens ) {
				doFrustumCullingAndLookupInCacheRecursive(projectionContext, childrenNode);
			}
		}
	}

	protected final void insertIntoToCacheTableIfNotAlreadyPresent(ContentType element) {
		if( !toCacheTable.contains(element) ) {
			toCacheTable.insert(element);
		}
	}
}
