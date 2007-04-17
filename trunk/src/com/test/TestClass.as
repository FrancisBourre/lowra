package com.test
{
	import com.bourre.log.PixlibDebug ;
	
	public class TestClass
	{
		public var x:int ; 
		public var y:uint ; 
		public var name:String ;
		public var tab:Array ;
		
		public function TestClass()
		{
			x = 0 ;
			y = 0 ; 
			name = "" ;
			
		}
		
		public function setPosition(x:int, y:uint):void
		{
			this.x = x ;
			this.y = y ;
		}
		
		public function setName(str:String) : void
		{
			name = str ;
		}
		
		public function getArgs():void
		{
			tab = new Array () ;
			tab.push(x) ; 
			tab.push(y) ; 
			tab.push(name) ; 
		}
	}
}