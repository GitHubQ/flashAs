
package 
{
		/**
	 * ...
	 * @author qiulu
	 */ 
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.Timer; 
	
	public class Main extends Sprite 
	{
		var frame:Sprite, randombrick:Sprite; 
		var txt_level:TextField = new TextField(), txt_score:TextField = new TextField(), txt_explain:TextField = new TextField(), txt_winlose:TextField = new TextField(), txt_author:TextField = new TextField(); 
		var tf1:TextFormat = new TextFormat(), tf2:TextFormat = new TextFormat(); 
		var xx:int, yy:int; 
		var rank:uint = 1; 
		var time:Timer; 
		var p_eat:Boolean = true, p_start:Boolean = true, bBlocked:Boolean = true, bHited:Boolean = true; 
		var body:uint = 5, changedbody:uint = 5; 
		var arr:Array = new Array(); 
		var arr_RB:Array = new Array();
		
		public function Main()
		{
			BASIC(); 
			TFEVENT(); 
			stage.addEventListener(Event.ENTER_FRAME, Check);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, START); 
			stage.addEventListener(KeyboardEvent.KEY_DOWN, diction); 
			function START(e:KeyboardEvent):void 
			{
				if (e.keyCode == 13 && p_start == true)
				{
					p_start = false; 
					bHited = false;
					bBlocked = false;
					xx = -20; 
					yy = 0; 
					body = 5; 
					initarr(); 
					txt_winlose.text = ""; 
					time = new Timer(((rank < 5) ? (300 - rank * 50) : (200 - rank * 10))); 
					time.start(); 
					time.addEventListener(TimerEvent.TIMER, MOVE); 
					stage.addEventListener(Event.ENTER_FRAME, RANDOMBRICK); 
					stage.addEventListener(Event.ENTER_FRAME, WINLOSE); 
					stage.addEventListener(Event.ENTER_FRAME, AddRandomBlocks); 
				}
			}
		}
		
		private function AddRandomBlocks(e:Event):void
		{
			if(bBlocked == false)
			{
				bBlocked = true;
				var dx:Number,dy:Number;
				for(var i:uint=0; i<3; i++)
				{
					arr_RB.push(BRICK()); 
					dx = Math.random() * 400; 
					dy = Math.random() * 400; 
					for (var n:uint = 0;  n < 20;  n++)
					{
						if (dx >= 20 * n && dx <= 20 * (n + 1))
						{
							arr_RB[i].x = n * 20 + 3; 
						}
						if (dy >= 20 * n && dy <= 20 * (n + 1))
						{
							arr_RB[i].y = n * 20 + 3; 
						}
					}
					addChild(arr_RB[i]); 
					arr_RB[i].alpha=1; 
				}
			}
					
			if(bHited == false)
			{
				if (arr.length <= 0 || arr_RB.length <= 0)
				{
					EndGame();
				}
				else
				{				
					for(var j:uint=0; j<3; j++)
					{
						if(arr[0].hitTestObject(arr_RB[j]))
						{
							bHited = true;	
							break;		
						}
					}
				}
				if(bHited == true)
					EndGame();
			}				
		}
		
		private function Check(e:Event):void
		{
			if(body != changedbody)
			{
				changedbody = body;
				txt_score.text = "SCORE:\n" + (body - 5)*10;
				txt_score.setTextFormat(tf1, 0, 6); 
				txt_score.setTextFormat(tf2, 7, txt_score.length);  
			}
		}
		
		private function BASIC():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;  //屏幕不缩放
			//加载方格
			frame = FRAME(); 
			addChild(frame); 
			frame.x = frame.y = 2; 
			//说明
			txt_explain.text = "ENTER键:\n开始\n\n方向键:\n移动"; 
			txt_winlose.text = ""; 
			txt_level.text = "LEVEL:\n" + rank; 
			txt_score.text = "SCORE:\n" + (body - 5); 
			txt_author.text = "author:\n 邱鹭(改编版)"
			txt_explain.selectable = txt_winlose.selectable = txt_level.selectable = txt_score.selectable = txt_author.selectable = false; 
			txt_explain.x = txt_winlose.x = txt_level.x = txt_score.x = txt_author.x = 405; 
			txt_level.y = 20; 
			txt_score.y = 90; 
			txt_winlose.y = 160; 
			txt_explain.y = 210; 
			txt_author.y = 340; 
			txt_explain.background = txt_winlose.background = txt_level.background = txt_score.background = txt_author.background = true; 
			txt_explain.backgroundColor = txt_winlose.backgroundColor = txt_level.backgroundColor = txt_score.backgroundColor = txt_author.backgroundColor = 0x400080; 
			txt_explain.width = txt_winlose.width = txt_level.width = txt_score.width = txt_author.width = 90; 
			txt_explain.height = 105; 
			txt_winlose.height = 30; 
			txt_level.height = txt_score.height = txt_author.height = 50; 
			addChild(txt_explain); 
			addChild(txt_winlose); 
			addChild(txt_level); 
			addChild(txt_score); 
			addChild(txt_author); 
		}
				
		private function TFEVENT():void 
		{
			TF(); 
			txt_explain.setTextFormat(tf1, 0, 7); 
			txt_explain.setTextFormat(tf1, 12, 17); 
			txt_explain.setTextFormat(tf2, 8, 10); 
			txt_explain.setTextFormat(tf2, 17, 19); 
			txt_level.text = "LEVEL:\n" + rank; 
			txt_level.setTextFormat(tf1, 0, 6); 
			txt_level.setTextFormat(tf2, 7, txt_level.length); 
			txt_score.text = "SCORE:\n" + (body - 5)*10; 
			txt_score.setTextFormat(tf1, 0, 6); 
			txt_score.setTextFormat(tf2, 7, txt_score.length); 
			txt_winlose.setTextFormat(tf2); 
			txt_author.setTextFormat(tf1); 
		}
		
		private function TF()
		{
			tf1.size = 14; 
			tf1.color = 0xffffff; 
			tf1.bold = true; 
			tf2.size = 22; 
			tf2.color = 0xffff00; 
			tf2.bold = true; 
			tf2.align = TextFormatAlign.CENTER; 
		}
		
		private function diction(event:KeyboardEvent):void 
		{ //控制蛇头移动方向
			switch (event.keyCode)
			{
				case 37: 
					xx = -20; 
					yy = 0; 
					break; 
				case 38: 
					xx = 0; 
					yy = -20; 
					break; 
				case 39: 
					xx = 20; 
					yy = 0; 
					break; 
				case 40: 
					xx = 0; 
					yy = 20; 
					break; 
				default: 
					break; 
			}
		}
		private function FRAME():Sprite
		{ //绘制方格
			frame = new Sprite(); 
			for (var m:uint = 0;  m <= 20;  m++)
			{
				frame.graphics.moveTo(0, m * 20); 
				frame.graphics.lineStyle(1, 0x0000ff); 
				frame.graphics.lineTo(400, m * 20); 
			}
			for (var n:uint = 0;  n <= 20;  n++)
			{
				frame.graphics.moveTo(n * 20, 0); 
				frame.graphics.lineStyle(1, 0x0000ff); 
				frame.graphics.lineTo(n * 20, 400); 
			}
			return frame; 
		}
		
		private function EndGame()
		{
			TFEVENT();
			if(bHited == true)
			{
				WINANDLOSE();
				txt_winlose.text = "LOSE"; 
			}
			else
			{
				if (arr.length == ((rank < 10) ? (20) : (15)))
				{
					rank += 1; 
					WINANDLOSE(); 
					txt_winlose.text = "WIN"; 
				}
				if (arr.length != 0)
				{
					if (arr[0].x < 0 || arr[0].x > 390 || arr[0].y < 0 || arr[0].y > 390)
					{
						WINANDLOSE(); 
						txt_winlose.text = "LOSE"; 
					}
					if (arr.length != 0)
					{
						for (var a:uint = 2;  a < arr.length;  a++)
						{
							if (arr[0].hitTestObject(arr[a]))
							{
								WINANDLOSE(); 
								txt_winlose.text = "LOSE"; 
							}
						}
					}
				}	
			}
			function WINANDLOSE()
			{
				p_start = true; 
				bHited = false;
				for (var m:uint = 0;  m < arr.length;  m++)
				{
					removeChild(arr[m]); 
				}
				for (var K:uint = 0;  K < arr_RB.length;  K++)
				{
					removeChild(arr_RB[K]); 
				}
				if (randombrick.alpha != 0.5)
					removeChild(randombrick);
				randombrick = null;
				arr.splice(0, arr.length - 1); 
				arr.shift(); 
				arr_RB.splice(0, arr_RB.length - 1); 
				arr_RB.shift(); 
				time.removeEventListener(TimerEvent.TIMER, MOVE); 
				stage.removeEventListener(Event.ENTER_FRAME, RANDOMBRICK); 
				stage.removeEventListener(Event.ENTER_FRAME, WINLOSE); 
				stage.removeEventListener(Event.ENTER_FRAME, AddRandomBlocks);
			}		
		}
		
		private function WINLOSE(et:Event):void 
		{
			EndGame();		
		}
		private function initarr():void
		{ //初始化数组
			for (var i:uint = 0;  i < body;  i++){
			var brick:Sprite = BRICK(); 
			arr.push(brick); 
			addChild(arr[i]); 
			arr[i].x = i * 20 + 200 + 3; 
			arr[i].y = 200 + 3; 
			}
		}
		private function MOVE(evt:TimerEvent):void
		 {
			var temp:Array = arr.splice(arr.length - 1, 1); 
			temp[0].x = arr[0].x + xx; 
			temp[0].y = arr[0].y + yy; 
			arr.unshift(temp[0]); 
		}
		private function RANDOMBRICK(evt:Event):void
		{	
			if((randombrick == null && p_start == false)|| p_eat == true)
			{
				randombrick = BRICK(); 
				var dx:Number = Math.random() * 400; 
				var dy:Number = Math.random() * 400; 
				for (var e:uint = 0;  e < 20;  e++)
				{
					if (dx >= 20 * e && dx <= 20 * (e + 1))
					{
						randombrick.x = e * 20 + 3; 
					}
					if (dy >= 20 * e && dy <= 20 * (e + 1))
					{
						randombrick.y = e * 20 + 3; 
					}
				}
				addChild(randombrick); 
				randombrick.alpha=0.2 
				if( p_eat == true )
				{p_eat = false; }
			}	
			
			if (arr[0].hitTestObject(randombrick))
			{
				p_eat = true; 
				body += 1; 
				arr.unshift(randombrick); 
				randombrick.alpha = 0.5; 
				arr[0].x = arr[1].x + xx; 
				arr[0].y = arr[1].y + yy; 
			}			
		}

		private function BRICK():Sprite 
		{ //画蛇身体
			var panel:Sprite = new Sprite(); 
			panel.graphics.lineStyle(1, 0xffff00); 
			panel.graphics.beginFill(0xff0000); 
			panel.graphics.drawRect(0, 0, 18, 18); 
			panel.graphics.endFill(); 
			panel.alpha = 0.5; 
			return panel; 
		}

	}
}