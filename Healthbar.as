//made by Ruben Nijmeijer
package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.Timer;
	
	public class Healthbar extends MovieClip{
		public var maxHealth: int;
		public var health: int;
		public var healthRegen: int;
		public var timeinseconds = 400*60;
		public var healthTimer: Timer = new Timer(timeinseconds, 0);

		public function Healthbar(regen:int) {
			// constructor code
			maxHealth = 100;
			health = 100;
			healthRegen = regen;
			healthTimer.start();
			healthTimer.addEventListener(TimerEvent.TIMER, HealthRegenMethod);

		}
		
		public function UpdateHealth(): void {
			this.width = health;
		}
		public function HealthRegenMethod(e:TimerEvent) : void{
			if (health < maxHealth) {
				health += healthRegen;
			}
		}

	}
	
}
