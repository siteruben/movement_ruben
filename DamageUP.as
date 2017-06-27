//made by Ruben Nijmeijer
package {

	import flash.display.MovieClip;
	import flash.events.*;

	public class DamageUP extends MovieClip {
		public var isClicked: Boolean;

		public function DamageUP() {
			this.addEventListener(MouseEvent.CLICK, onClicked);
			this.addEventListener(Event.ENTER_FRAME, update);
			this.isClicked = false;
		}
		public function update(e: Event): void {
			this.isClicked = false;
		}

		public function onClicked(e: Event): void {
			this.isClicked = true;
		}
	}
}
