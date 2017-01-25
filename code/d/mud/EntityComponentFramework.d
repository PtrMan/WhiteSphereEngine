
import std.algorithm.mutation : remove;
// 24.01.2017
// draft of new entity component system

// agregents components of the same type
// see http://gameprogrammingpatterns.com/data-locality.html
struct ComponentArray {
	DynamicComponent[] components;

	final void removeComponent(DynamicComponent component) {
		foreach( i, iComponent; components ) {
			if( iComponent is component ) {
				components = components.remove(i);
				break;
			}
		}
	}
}



struct MessageForC {

}

mixin template C() {
	final void dispatchFixed(MessageForC message) {
	}
}

import std.variant : Variant;

struct DynamicMessage {
   // todo  
   string type;

   Variant[string] arguments;

   static DynamicMessage make(string type, Variant[string] arguments) {
   	DynamicMessage result;
   	result.type = type;
   	result.arguments = arguments;
   	return result;
   }
}

abstract class DynamicComponent {
  @property string name();
  
  //void receive(DynamicMessage message);
}

struct EntityDynamicInner {
	/*
	final void dispatchGeneric(string name, DynamicMessage message) {
      foreach( iterationComponent; components ) {
        if( iterationComponent.name == name ) {
          iterationComponent.receive(message);
          return;
        }
      }
	}
	*/

	final void removeComponent(DynamicComponent removingComponent, ComponentArray componentArray) {
		foreach( i, iComponent; components ) {
			if( iComponent is removingComponent ) {
				components = components.remove(i);
				break;
			}
		}

		componentArray.removeComponent(removingComponent);
	}

    DynamicComponent[] components;
}

class EntityBase {
	EntityDynamicInner dynamicInner;
}

interface IEventHandler {
	void dispatch(DynamicMessage message);
}


class EventManager {
	final void dispatch(DynamicMessage message) {
		writeln("dispatch ", message.type);

		assert(message.type in handlersByType);

		foreach( iHandler; handlersByType[message.type] ) {
			iHandler.dispatch(message);
		}
	}

	final void subscribe(string type, IEventHandler handler) {
		writeln("subsribe ", type);

		if( type in handlersByType ) {
			handlersByType[type] ~= handler;
		}
		else {
			handlersByType[type] = [handler];
		}
	}

	final void unsubscribe(string type, IEventHandler handler) {
		if( !(type in handlersByType) ) {
			// should not happen, we ignore it
			return;
		}

		assert(type in handlersByType);

		foreach( i, iHandler; handlersByType[type] ) {
			if( iHandler is handler ) {
				handlersByType[type] = handlersByType[type].remove(i);
				return;
			}
		}

		assert(false); // should be unreachable
	}

	private IEventHandler[][string] handlersByType;
}

// indirection to record the events to an database or replay
class EventManagerFacade {
	final this(EventManager eventManager) {
		this.eventManager = eventManager;
	}

	EventManager eventManager;

	final void dispatch(DynamicMessage message) {
		eventManager.dispatch(message);
	}

	final void subscribe(string type, IEventHandler handler) {
		eventManager.subscribe(type, handler);
	}

	final void unsubscribe(string type, IEventHandler handler) {
		eventManager.unsubscribe(type, handler);
	}
}

interface IResetable {
	void reset();
}

// inherits from resetable to be able to call reset without knowledge of the specific class
class TickTimerComponent : DynamicComponent, IResetable {
	int remainingTicks;
	int resetTicks;

	final this(EventManagerFacade eventManager) {
		this.eventManager = eventManager;
	}

	override final @property string name() {
		return "TickTimerComponent";
	}

	override void reset() { // from IResetable
		remainingTicks = resetTicks;
	}

	final void tickDown() {
		remainingTicks--;
	}

	final bool wasTriggered() {
		return remainingTicks <= 0;
	}

	final void trigger() {
		eventManager.dispatch(messageToSendWhenTriggered);
	}

	DynamicMessage messageToSendWhenTriggered;
	EventManagerFacade eventManager;
}

class TickTimerEventHandler : IEventHandler {
	final this(TickTimerComponent component) {
		this.component = component;
	}

	void dispatch(DynamicMessage message) {
		if( message.type == "tick" ) {
			// tick the timer down and check if it was triggered
			component.tickDown();

			bool wasTriggered = component.wasTriggered;
			if( wasTriggered ) {
				component.trigger();
			}
		}
	}

	private TickTimerComponent component;
}

import std.stdio;

// debugs text directly to console
class DebugToConsoleEventHandler : IEventHandler {
	final this() {
	}

	void dispatch(DynamicMessage message) {
		assert(message.type == "debugToConsole");
		writeln(message.arguments["text"]);
	}
}





/*
class Entity1 : BaseEntity {
	mixin C;
}
*/

void main() {
	EventManager eventManager = new EventManager;
	EventManagerFacade eventManagerFacade = new EventManagerFacade(eventManager);

	// install serverwide hardwired debugToConsole "sink"
	eventManagerFacade.subscribe("debugToConsole", new DebugToConsoleEventHandler);


	EntityBase testEntity = new EntityBase;

	TickTimerComponent tickTimerComponent = new TickTimerComponent(eventManagerFacade);
	tickTimerComponent.remainingTicks = 6;
	tickTimerComponent.resetTicks = 6;

	tickTimerComponent.messageToSendWhenTriggered = DynamicMessage.make("debugToConsole", ["text":Variant("timerWasTriggered")]);


	
	eventManagerFacade.subscribe("tick", new TickTimerEventHandler(tickTimerComponent));

	testEntity.dynamicInner.components ~= tickTimerComponent;

	foreach( clockI; 0..6 ) {
		writeln("->world tick");
		eventManagerFacade.dispatch(DynamicMessage.make("tick", ["origin":Variant("world")]));
	}
}