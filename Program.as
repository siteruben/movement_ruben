//made by Ruben Nijmeijer
package {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.utils.*;
	import flash.text.*;
	public class Program extends MovieClip {
		private var myPlayer: Player;
		var left: Boolean;
		var right: Boolean;
		var up: Boolean;
		var down: Boolean;
		var shoot: Boolean;
		var bullets: Array;
		var fireTimer: Timer;
		var canFire: Boolean;
		var spawnTimer: Timer;
		var canSpawn: Boolean;
		var damageTimer: Timer;
		var canDamage: Boolean;
		var myTextField: TextField;
		var waveTextField: TextField;
		var myFormat: TextFormat;
		var myFormat2: TextFormat;
		var ground: Ground = new Ground;
		var wave: int = 30;
		var waveCurrent: int = 1;
		var waveIncrement: int = Math.floor(score / 100 * 20) + 1;
		var waveFieldSpawned: Boolean = true;
		var WaveTextTimer: Timer = new Timer(900, 1);
		var WaveStart = true;
		var IsDead: Boolean = false;


		var enemies: Array;
		var damage: Number = 10;
		private var healthbar: Healthbar;
		private var healthbarOutline: HealthbarOutline;
		public var score: int = 0;
		public var toNextUpgrade: int = 5;
		public var enemyKilled: int = 5;
		public var healthUP: HealthUP;
		public var damageUP: DamageUP;
		public var canSpawnUpgrade: Boolean = false;
		public var UpgradesSpawned: Boolean = false;
		var upgrade: int = 10;
		var upgrade1: int = 0;

		public function Program() {
			enemies = new Array();
			bullets = new Array();
			fireTimer = new Timer(300, 1);
			fireTimer.addEventListener(TimerEvent.TIMER, fireTimerHandler, false, 0, true);

			spawnTimer = new Timer(2500, 1);
			spawnTimer.addEventListener(TimerEvent.TIMER, spawnTimerHandler, false, 0, true);

			damageTimer = new Timer(1750, 1);
			damageTimer.addEventListener(TimerEvent.TIMER, damageTimerHandler, false, 0, true);


			myPlayer = new Player();
			stage.addChild(myPlayer);
			stage.addChild(ground);
			ground.y = 980;
			left = false;
			right = false;
			up = false;
			down = false;
			canFire = true;
			canSpawn = true;
			canDamage = true;
			addEventListener(Event.ENTER_FRAME, Update);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			healthbar = new Healthbar(20);
			healthbarOutline = new HealthbarOutline;

			stage.addChild(healthbarOutline);
			stage.addChild(healthbar);
			healthbarOutline.x = 100;
			healthbarOutline.y = 100;
			healthbar.x = 100;
			healthbar.y = 100;

			//score textfield
			myFormat = new TextFormat();
			myFormat.size = 30;
			myFormat.align = TextFormatAlign.LEFT;
			myTextField = new TextField;
			myTextField.textColor = 0x000000;
			myTextField.defaultTextFormat = myFormat;
			myTextField.y = healthbar.y / 2;
			myTextField.x = healthbar.x;
			myTextField.width = 150;
			myTextField.text = "Score: " + score;
			addChild(myTextField);


			myFormat2 = new TextFormat();
			myFormat2.size = 30;
			//wave textfield
			waveTextField = new TextField();
			waveTextField.textColor = 0x000000;
			waveTextField.defaultTextFormat = myFormat2;
			waveTextField.width = 200;
			waveTextField.y = stage.height / 2 - 100;
			waveTextField.x = stage.width / 2 - waveTextField.width;
			waveTextField.text = "Wave " + waveCurrent;


		}

		private function PopUpWaveTextStart(): void {
			waveTextField.text = "Wave " + waveCurrent;
			addChild(waveTextField);
			WaveTextTimer.addEventListener(TimerEvent.TIMER_COMPLETE, PopUpWaveTextStop);
			WaveTextTimer.start();
		}

		private function PopUpWaveTextStop(e: TimerEvent): void {
			removeChild(waveTextField);
		}

		private function Update(e: Event): void {
			healthbar.UpdateHealth();
			for (var j: int = 0; j < enemies.length; j++) {
				if (stage.contains(enemies[j])) {
					enemies[j].damage = upgrade1 + 10;
				}
			}
			if (myPlayer.y > ground.y - 40) {
				myPlayer.Ground(true);
				myPlayer.position.y = ground.y - 40;
			} else {
				myPlayer.Ground(false);
			}
			myPlayer.update(mouseX, mouseY);
			bulletMovement();

			if (left) {
				myPlayer.moveLeft()
			}
			if (right) {
				myPlayer.moveRight();
			}
			if (up) {
				myPlayer.moveJump();
			}
			if (down) {

			}
			if (shoot) {
				if (canFire) {
					canFire = false;
					fireTimer.start();
					var bullet: Bullet = new Bullet(myPlayer.x, myPlayer.y, mouseX, mouseY);
					stage.addChild(bullet);
					bullets.push(bullet);
				}

			}
			if (enemyKilled <= score) {
				canSpawnUpgrade = true;
				if (canSpawnUpgrade && !UpgradesSpawned) {
					spawnUpgrade();
					canSpawnUpgrade = false;
					UpgradesSpawned = true;

				}
				if (healthUP.isClicked) {
					trace("clicked");
					stage.removeChild(healthUP);
					stage.removeChild(damageUP);
					healthbar.maxHealth += upgrade;
					trace(healthbar.maxHealth);
					enemyKilled += toNextUpgrade;
					UpgradesSpawned = false;
				}
				if (damageUP.isClicked) {
					stage.removeChild(healthUP);
					stage.removeChild(damageUP);
					upgrade1 += 10;
					enemyKilled += toNextUpgrade;
					UpgradesSpawned = false;
				}
			}
			if (healthbar.health <= 0 && !IsDead) {
				//trace("D E D");
				canSpawn = false;
				IsDead = true;
				WaveStart = false;
				waveTextField.text = "You're dead";
				stage.removeChild(myPlayer);
				healthbar.maxHealth = 0;
				removeEnemies();
				canFire = false;

			}
			if (wave > 0) {
				if (canSpawn) {
					if (WaveStart) {
						WaveStart = false;
						PopUpWaveTextStart();
					}
					canSpawn = false;
					spawnTimer.start();
					var myEnemy: Enemy = new Enemy();
					stage.addChild(myEnemy);
					wave--;
					enemies.push(myEnemy);
				}
			}
			if (wave == 0) {
				WaveStart = true;
				wave += waveIncrement;
				waveCurrent++;
			}

			enemyMovement();
			bulletDamage();
		}

		private function fireTimerHandler(e: TimerEvent): void {
			canFire = true;
		}
		private function spawnTimerHandler(e: TimerEvent): void {
			canSpawn = true;
		}
		private function damageTimerHandler(e: TimerEvent): void {
			canDamage = true;
		}
		private function bulletMovement() {
			for (var i: int = 0; i < bullets.length; i++) {
				if (stage.contains(bullets[i])) {
					bullets[i].Update();
				}
				if (bullets[i].x < 0 || bullets[i].x > 1200 || bullets[i].y < 0 || bullets[i].hitTestObject(ground)) {
					if (stage.contains(bullets[i])) {
						stage.removeChild(bullets[i]);

					}
				}

			}
		}
		private function enemyMovement() {
			for (var j: int = 0; j < enemies.length; j++) {
				if (stage.contains(enemies[j])) {
					enemies[j].healthbar.UpdateHealth();
					if (enemies[j].y > ground.y) {
						enemies[j].Ground(true);
						enemies[j].position.y = ground.y;
					} else {
						enemies[j].Ground(false);
					}
					if (myPlayer.hitTestObject(enemies[j])) {
						if (canDamage) {
							Damage();
							canDamage = false;
							damageTimer.start();
						}

					}
					if (myPlayer.position.x > enemies[j].position.x) {
						enemies[j].Update(0);
					}
					if (myPlayer.position.x < enemies[j].position.x) {
						enemies[j].Update(1);
					}

				}

			}

		}
		public function removeEnemies() {
			for (var j: int = 0; j < enemies.length; j++) {
				if (stage.contains(enemies[j])) {
					stage.removeChild(enemies[j]);
				}
			}
		}
		public function removeBullets() {
			for (var i: int = 0; i < bullets.length; i++) {
				if (stage.contains(bullets[i])) {
					stage.removeChild(bullets[i]);
				}
			}
		}
		public function bulletDamage() {
			for (var j: int = 0; j < enemies.length; j++) {
				for (var i: int = 0; i < bullets.length; i++) {
					if (stage.contains(enemies[j]) && stage.contains(bullets[i])) {
						if (bullets[i].hitTestObject(enemies[j])) {
							enemies[j].Damage();
							stage.removeChild(bullets[i]);
							if (enemies[j].healthbar.health <= 0) {
								stage.removeChild(enemies[j]);
								score++;
								CalculateScore();
							}
						}
					}
				}
			}
		}
		public function spawnUpgrade() {
			damageUP = new DamageUP();
			healthUP = new HealthUP();
			stage.addChild(healthUP);
			stage.addChild(damageUP);
			damageUP.y = 100;
		}
		public function CalculateScore() {
			myTextField.text = "Score: " + score;
		}
		public function Damage() {
			healthbar.health -= damage;
		}
		public function keyDownHandler(event: KeyboardEvent): void {
			switch (event.keyCode) {
				case Keyboard.A:
					left = true;
					break;

				case Keyboard.D:
					right = true;
					break;

				case Keyboard.W:
					up = true;
					break;

				case Keyboard.S:
					down = true;
					break;
				case Keyboard.SPACE:
					shoot = true;
					break;
				default:
					break;
			}
		}

		public function keyUpHandler(event: KeyboardEvent): void {
			switch (event.keyCode) {
				case Keyboard.A:
					left = false;
					break;

				case Keyboard.D:
					right = false;
					break;

				case Keyboard.W:
					up = false;
					break;

				case Keyboard.S:
					down = false;
					break;;
				case Keyboard.SPACE:
					shoot = false;
					break;
				default:
					break;
			}
		}

	}

}