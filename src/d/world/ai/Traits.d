module world.ai.Traits;

const string[] basicNeedsReadable = ["expansion", "mineral/material freak", "selfprotection", "offensive", "discoverer"];



class Trait {
	final this(float needFactor[basicNeedsReadable.length]) {
		this.needFactor = needFactor;
	}

	immutable float needFactor[basicNeedsReadable.length]; // factors of basic needs which compse this trait
}

Trait offensiveRamblingDiscoverer = new Trait([0.0f, 0.0f, 0.1f, 1.0f, 0.2f]);
Trait expansiveFreak = new Trait([1.0f, 0.8f, 0.0f, 0.0f, 1.0f]);
Trait autisticGenius = new Trait([0.0f, 2.0f, 1.5f, -0.8f, 0.1f]);
Trait minerFreak = new Trait([0.1f, 2.0f, 0.0f, 0.0f, 0.5f]);


// for buffs
Trait buffPanic = new Trait([-2.0f, -0.5f, 2.0f, 0.1f, 0.0f]);
Trait buffDiscoverer = new Trait([0.5f, 0.0f, 0.0f, 0.0f, 1.5f]);

