//made by Ruben Nijmeijer
package {
	import flash.display.MovieClip;

	public class Player extends MovieClip {
		// properties
		
		var position: Vector2 = new Vector2(100, 100);
		var velocity: Vector2 = new Vector2(0, 0);
		var left: Vector2 = new Vector2(-5, 0);
		var right: Vector2 = new Vector2(5, 0);
		var jump: Vector2 = new Vector2(0, 0);
		var grav: Vector2 = new Vector2(0, 1);
		var topspeed: Number = 5;
		var mouse: Vector2;
		var dir: Vector2;
		var isGrounded : Boolean = false;
		var wantsJump:Boolean = false;
		var jumping: Boolean = false;


		// constructor
		public function Player() {
			
		}

		// methods
		public function update(msX, msY): void {
			mouse = new Vector2();
			mouse.x = msX;
			mouse.y = msY;
			dir = new Vector2();
			dir.create(position, mouse);
			this.rotation = dir.getAngle();

			x = position.x;
			y = position.y;
			gravity();
			
			if (isGrounded) {
				velocity.y = 0; 
				jumping = false;
			}
			if(wantsJump && isGrounded) {
				velocity.y = -20;
				
			}
			wantsJump = false;
			velocity.limit(40);
			position.add(velocity);
		}

		public function moveLeft(): void {
			// TODO implement
			position.add(left);
		}

		public function moveRight(): void {
			// TODO implement
			position.add(right);
		}
		public function moveJump(): void {
			// TODO implement
			wantsJump = true;
		}
		public function gravity() {
			velocity.add(grav);
		}
		public function Ground(isGround:Boolean) {

			this.isGrounded = isGround;
		}
	}

}