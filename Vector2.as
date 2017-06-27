package {

	public class Vector2 {
		var x: Number;
		var y: Number;
		public function Vector2(x_: Number = 0, y_: Number = 0) {
			// constructor code
			x = x_;
			y = y_;
		}
		public function add(other) {
			y = y + other.y;
			x = x + other.x;
		}
		public function sub(other) {
			y = y - other.y;
			x = x - other.x;
		}
		public function mag(): Number {
			return Math.sqrt(x*x + y*y);
		}
		public function normalize(): void {
			var e:Number = mag();
			if (mag() != 0) {
				divS(e);
			}
		}
		public function divS(s:Number) {
			x /= s;
			y /= s;
		}
		public function limit(max:Number) {
			if (mag() > max) {
				normalize();
				multS(max);
			}
		}
		public function multS(s: Number) {
			x *= s;
			y *= s;
		}
		public function copy() {
			var v: Vector2 = new Vector2(x, y);
			return v;
		}
		public function create(from:Vector2, to:Vector2) {
			x = from.x - to.x;
			y = from.y - to.y;
		}
		public function getAngle() {
			var radians: Number = Math.atan2(y, x);
			var degrees: Number = radians * 180 / Math.PI;
			return degrees;
		}
		public static function getAngle2(from:Vector2, to:Vector2):Number{
			var verticalDiffrence:Number = to.y - from.y;
			var horizontalDiffrence:Number = to.x - from.x;
			var radians:Number = Math.atan2(verticalDiffrence, horizontalDiffrence);
			return radians;
		}
	}
}