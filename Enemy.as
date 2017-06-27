//made by Ruben Nijmeijer
package  {
	import flash.display.MovieClip;
	
	public class Enemy extends MovieClip {
		var position:Vector2 = new Vector2(Math.random() * 1920, 300);
		var grav: Vector2 = new Vector2(0, 1);
		var velocity: Vector2 = new Vector2(0, 0);
		var left: Vector2 = new Vector2(-5, 0);
		var right: Vector2 = new Vector2(5, 0);
		var isGrounded:Boolean = false; 
		var damage: int = 10;
		var speed: Number= (Math.random() * 5) + 3.5;
		public var healthbarBackground: HealthbarBackground;
		public var healthbar: Healthbar;
		public var healthbarOutline: HealthbarOutline;
		
		public function Enemy() {
			// constructor code
			healthbarBackground = new HealthbarBackground;
			healthbar = new Healthbar(0);
			healthbarOutline = new HealthbarOutline;

			healthbarBackground.addChild(healthbarOutline);
			
			healthbarBackground.addChild(healthbar);
			this.addChild(healthbarBackground);
			healthbarBackground.x = -50;
			healthbarBackground.y = -200;
		}
		public function Update(positionPlayer:int) {
			Gravity();
			if (isGrounded) {
				velocity.y = 0;
				if (positionPlayer == 0) {
					position.x += speed;
					this.gotoAndStop(2);
				} 
				if (positionPlayer == 1) {
					position.x -= speed;
					this.gotoAndStop(1);
				} 
				
			}
			
			
			velocity.limit(40);
			position.add(velocity); 
			this.x = position.x;
			this.y = position.y;  
		}
		public function Damage() {
			healthbar.health -= damage;
		}
		public function Gravity() {
			velocity.add(grav);
		}
		public function Ground(isGround:Boolean) {
			this.isGrounded = isGround;
		}

	}
	
}
