package com.bourre.transitions
{
	public class MockMultiTweenFPS extends MultiTweenFPS
	{
		public function MockMultiTweenFPS ( oT : Object, 
											sP : Array, 
											nE : Array, 
											nRate : Number, 
											nS : Array = null, 
											fE : Function = null,
											gP : Array = null)
		{
			super (	oT, sP, nE, nRate, nS, fE, gP );
			_oBeacon = MockBeacon.getInstance();
		}
	}
}