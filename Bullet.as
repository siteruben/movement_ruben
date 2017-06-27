//made by Ruben Nijmeijer
package {

	import flash.display.MovieClip;


	public class Bullet extends MovieClip {
		var position: Vector2
		var mouse: Vector2;
		var dir: Vector2;
		var speed: int = 20;

		public function Bullet(posX: Number, posY: Number, msX: Number, msY: Number) {
			// constructor code
			position = new Vector2(posX, posY);
			mouse = new Vector2();
			mouse.x = msX;
			mouse.y = msY;
			dir = new Vector2();
			dir.create(position, mouse);
			this.rotation = dir.getAngle();
		}
		public function Movement() {
			position.x += Math.cos((180 + rotation) * 0.0174532925) * speed;
			position.y += Math.sin((180 + rotation) * 0.0174532925) * speed;

		}
		public function Update() {
			x = position.x;
			y = position.y;
			Movement(); 
		}


	}

}