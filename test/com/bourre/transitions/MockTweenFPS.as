package com.bourre.transitions
{
	public class MockTweenFPS extends TweenFPS
	{
		public function MockTweenFPS ( oT : Object, 
									   sP : String, 
									   nE : Number, 
									   nRate : Number, 
									   nS : Number = undefined, 
									   fE : Function = null,
									   gP : String = null)
		{
			super (	oT, sP, nE, nRate, nS, fE, gP );
			_oBeacon = MockBeacon.getInstance();
		}
	}
}