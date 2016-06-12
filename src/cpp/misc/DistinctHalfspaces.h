#pragma once

// templates to rule out tests against halfspace seperated regions where no geometric cuts can happen

template<unsigned width>
struct DistincthalfspacesBase {
  unsigned used; // mask
  
  DistincthalfspacesBase() {
    used = 0;
  }
  
  protected:
  unsigned countUsedBits() {
      unsigned counter = 0;
      
      for( unsigned i = 0; i < width; i++ ) {
        if( used & (1 << i) ) {
          counter++;
        }
      }
      
      return counter;
    }
};

template<unsigned states, unsigned width>
struct Distincthalfspaces : public DistincthalfspacesBase<width> {
  unsigned counters[width];
  
  
  Distincthalfspaces() {
    for( unsigned i = 0; i < width; i++ ) {
      counters[0] = 0;
    }
    
  }
  
  void setAndIncrement(unsigned index) {
    DistincthalfspacesBase<width>::used |= (1 << index);
    counters[index]++;
  }


    bool existsPotentialCrossing() {
      unsigned countOfUsed = DistincthalfspacesBase<width>::countUsedBits();
      // if all are in one area there can't exist any crossings
      if( countOfUsed == states ) {
        return false;
      }
      
      
      // if all points are at one side of the halfspaces there can't exist any crossings

      // TODO< refactor this into method called "existsCounterEqualToStates" >
      for( unsigned i = 0; i < width; i++ ) {
        if( isCounterEqualToStates(i) ) {
          return false;
        }
      }
      
      return true;
      
    }
    
    // should only be called if there exists a potential crossing
    unsigned getBitmaskForPotentialCrossings() {
      unsigned resultMask = 0;
      
      for( unsigned i = 0; i < width; i++ ) {
        bool isSideUsed = DistincthalfspacesBase<width>::used & (1 << i);
        if( isSideUsed && isCounterBiggerThanZero(i) ) {
          resultMask |= (1 << i);
        }
      }
      
      return resultMask;
    }
  
  protected:
    bool isCounterEqualToStates(unsigned index) {
      return counters[index] == states;
    }

    bool isCounterBiggerThanZero(unsigned index) {
      return counters[index] > 0;
    }
};

template<unsigned width>
struct Distincthalfspaces<2, width> : public DistincthalfspacesBase<width> {
  unsigned counterBits;
  
  Distincthalfspaces() {
    counterBits = 0;
  }
    
    void setAndIncrement(unsigned index) {
      DistincthalfspacesBase<width>::used |= (1 << index);
      counterBits = counterBits ^ (1 << index);
    }
  
    bool existsPotentialCrossing() {
      unsigned countOfUsed = DistincthalfspacesBase<width>::countUsedBits();
      // if all are in one area there can't exist any crossings
      if( countOfUsed == 1 ) {
        return false;
      }
      
      
      // if all points are at one side of the halfspaces there can't exist any crossings

      // TODO< refactor this into method called "existsCounterEqualToStates" >
      for( unsigned i = 0; i < width; i++ ) {
        if( isCounterEqualToStates(i) ) {
          return false;
        }
      }
      
      return true;
      
    }
    
    // should only be called if there exists a potential crossing
    unsigned getBitmaskForPotentialCrossings() {
      unsigned resultMask = 0;
      
      for( unsigned i = 0; i < width; i++ ) {
        bool isSideUsed = DistincthalfspacesBase<width>::used & (1 << i);
        if( isSideUsed && isCounterBiggerThanZero(i) ) {
          resultMask |= (1 << i);
        }
      }
      
      return resultMask;
    }
  
  protected:
    bool isCounterEqualToStates(unsigned index) {
      // we only enter this method if at least two sides are used,
      // because there are just two states,
      // the only way a bit can be xored twice is if it is false
      // (true ^ false) ^ true == false
      return !(counterBits & (1 << index));
    }
  
    bool isCounterBiggerThanZero(unsigned index) {
      // same principle as in isCounterEqualToStates()
      return counterBits & (1 << index);
    }
};





/*
compile test

extern bool isUsed(unsigned i);

void setAndIcrementTest1(Distincthalfspaces<2, 6> &halfspaces, bool &existsPotentialCrossings, unsigned bitmaskForPotentialCrossings) {
  for( unsigned i = 0; i < 6; i++ ) {
    if( isUsed(i) ) {
      halfspaces.setAndIncrement(i);
    }
  }
  
  existsPotentialCrossings = halfspaces.existsPotentialCrossing();

  bitmaskForPotentialCrossings = halfspaces.getBitmaskForPotentialCrossings();
}
*/