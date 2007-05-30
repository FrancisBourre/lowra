/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.bourre.structures
{ 
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;
	
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	import flash.geom.Matrix;
	
	/**
	 * <code>Point</code> data structure.
	 * 
	 * <p>Can use this data structure in many case : 
	 * <ul>
	 *   <li>Geometrical operation on vector entities</li>
	 *   <li>Object's position representation</li>
	 *   <li>2D array dimension</li>
	 *   <li>...</li>
	 * </ul>
	 * 
	 * <p>Take a look  at <code>Rectangle</code> class to see a concrete <code>Point</code> 
	 * example.
	 * 
	 * @author Francis Bourre
	 * @author Cédric Néhémie
	 * @version 1.0
	 */
	public class Point
	{
		//-------------------------------------------------------------------------
		// Public Properties
		//-------------------------------------------------------------------------
		
		/** x property. **/
		public var x : Number;
		
		/** y property. **/
		public var y : Number;
	
	
		//-------------------------------------------------------------------------
		// Public API
		//-------------------------------------------------------------------------
		
		/**
		 * Constructs a new <code>Point</code> instance.
		 * 
		 * @example
		 * <listing>
		 *   var p:Point = new Point(4, 2);
		 * </listing>
		 * 
		 * @param nX <code>Number</code> x property value.
		 * @param nY <code>Number</code> y property value.
		 */
		public function Point ( nX : Number = 0, nY : Number = 0 ) 
		{
			init( nX, nY );
		}
	
	
		/**
		 * Defines <code>x</code> and <code>y</code> properties using
		 * passed-in <code>Number, Number</code> parameters.
		 * 
		 * @example
		 * <listing>
		 *   p.init(10,4);
		 * </listing>
		 * 
		 * @param nX <code>Number</code> x property value.
		 * @param nY <code>Number</code> y property value.
		 */
		public function init ( nX : Number = 0, nY : Number = 0 ) : void 
		{ 
			if( isNaN ( nX ) || isNaN ( nY ) )
			{
				PixlibDebug.WARN( this + ".init() was called with invalid arguments : ("+nX+", "+nY+")." );
				throw new ArgumentError ( this + ".init() was called with invalid arguments : ("+nX+", "+nY+")." );
			}
			x = nX;
			y = nY;
		}
	
		/**
		 * Defines <code>x</code> and <code>y</code> properties using
		 * passed-in <code>Point</code> instance.
		 * 
		 * @example
		 * <listing>
		 *   var p1 : Point = new Point(5,5);
		 *   var p2 : Point = new Point(10,2);
		 *   
		 *   p1.reset( p2 );
		 * </listing>
		 * 
		 * @param v a <code>Point</code> instance
		 */
		public function reset( p : Point ) : void
		{
			init( p.x, p.y );
		}
	
		/**
		 * Indicates if passed-in <code>Point</code> parameter and instance have equal
		 * properties.
		 * 
		 * @example
		 * <listing>
		 * 	 var p1 : Point = new Point(5,5);
		 *   var p2 : Point = new Point(10,2);
		 *   
		 *   var b : Boolean = p1.equals(p2); //return false
		 * </listing>
		 * 
		 * @param p <code>Point</code> instance to test
		 * 
		 * @return <code>true</code> if <code>x</code> and <code>y</code> from instance are equal to
		 * passed-in <code>Point</code> instance.
		 */
		public function equals( p : Point ) : Boolean 
		{ 
			return ( x == p.x && y == p.y ); 
		}
		
		/**
		 * Indicates if passed-in <code>nX</code> and <code>nY</code> parameters and instance properties 
		 * are equal.
		 * 
		 * @example
		 * <listing>
		 * 	 var p1 : Point = new Point(5,5);
		 *   
		 *   var b : Boolean = p1.equals(5,5); //return true
		 * </listing>
		 * 
		 * @param nX <code>Number</code> x property value.
		 * @param nY <code>Number</code> y property value.
		 * 
		 * @return <code>true</code if <code>x</code> and <code>y</code> from instance are equal to
		 * passed-in <code>nX</code> and <code>nY</code> parameters
		 */
		public function compare( nX : Number, nY : Number ) : Boolean 
		{ 
			return ( x == nX && y == nY ); 
		}
		
		/**
		 * Builds and returns a copy of instance.
		 * 
		 * <p>New returned instance have same properties as current instance.
		 * 
		 * @example
		 * <listing>
		 *   var p1 : Point = new Point(10,2);
		 *   var p2 : Point = p1.clone();
		 * </listing>
		 * 
		 * 
		 * @return a new <code>Point</code> instance
		 */
		public function clone() : Point 
		{ 
			return new Point( x, y ); 
		}
	
		/*
		 * Arithmetical operations
		 */
		
		/**
		 * Substracts passed-in <code>Point</code> properties to instance
		 * properties.
		 * 
		 * <p>Warning : Instance is directly modified.
		 * 
		 * @example
		 * <listing>
		 *   var p1 : Point = new Point(10,2);
		 *   var p2 : Point = new Point(5,1);
		 *   p1.minus(p2);
		 * </listing>
		 * 
		 * @param p a <code>Point</code> instance
		 */
		public function minus( p : Point ) : void 
		{ 
			init( x - p.x, y - p.y ); 
		}
		
		/**
		 * Adds passed-in <code>Point</code> properties to instance
		 * properties.
		 * 
		 * <p>Warning : Instance is directly modified.
		 * 
		 * @example
		 * <listing>
		 *   var p1 : Point = new Point(10,2);
		 *   var p2 : Point = new Point(5,1);
		 *   p1.plus(p2);
		 * </listing>
		 * 
		 * @param p a <code>Point</code> instance
		 */
		public function plus( p : Point ) : void 
		{ 
			init(x + p.x, y + p.y); 
		}
		
		/**
		 * Sets to negative all instance properties.
		 * 
		 * <p>Warning : Instance is directly modified.
		 * 
		 * @example
		 * <listing>
		 *   var p1 : Point = new Point(10,2);
		 *   p1.neg();
		 * </listing>
		 * 
		 * @param p a <code>Point</code> instance
		 */
		public function neg() : void 
		{ 
			init(-x, -y); 
		}
		
		/**
		 * Sets to absolute all instance properties.
		 * 
		 * <p>Warning : Instance is directly modified.
		 * 
		 * @example
		 * <listing>
		 *   var p1 : Point = new Point(10,2);
		 *   p1.abs();
		 * </listing>
		 * 
		 * @param p a <code>Point</code> instance
		 */
		public function abs() : void 
		{ 
			init( Math.abs( x ), Math.abs( y ) ); 
		}
		
		/**
		 * Get length of the vector defined by instance properties.
		 * 
		 * @example
		 * <listing>
		 *   var p : Point = new Point(10,2);
		 *   var l : Number = p.getLength();
		 * </listing>
		 * 
		 * @return <code>Number</code> vector length
		 */
		public function getLength() : Number
		{
			return Math.sqrt( ( x * x ) + ( y * y ) );
		}
		
		/**
		 * Transforms vector in  direction.
		 * 
		 * <p>Warning : Instance is directly modified.
		 * 
		 * @example
		 * <listing>
		 *   var p : Point = new Point(10,2);
		 *   p.normalize();
		 * </listing>
		 * @throw	IllegalOperationError	Point.normalize called on a zero length vector.
		 */
		public function normalize() : void
		{
			var l:Number = getLength();
			if ( l / 0 )
			{
				x /= l;
				y /= l;
			} 
			else
			{
				PixlibDebug.WARN( this + ".normalize() was called on a zero-length vector!" );
				throw new IllegalOperationError ( this + ".normalize() was called on a zero-length vector!" )
			}
		}
		
		/**
		 * Returns Vector direction defined by instance propreties.
		 * 
		 * @example
		 * <listing>
		 *   var p1 : Point = new Point(10,2);
		 *   var p2 : Point = p1.getDirection();
		 * </listing>
		 * 
		 * @return a new <code>Point</code> instance.
		 */
		public function getDirection() : Point
		{
			var p:Point = clone();
			p.normalize();
			return p;
		}
		
		/**
		 * Calculates and returns dot product between this instance
		 * and passed-in <code>Point</code> instance.
		 * 
		 * @example
		 * <listing>
		 *   var p0 : Point = new Point(10,2);
		 *   var p1 : Point = new Point(5,6);
		 *   
		 *   var nDotP : Number = p0.getDotProduct( p1 );
		 * </listing>
		 * 
		 * @param 	a <code>Point</code> instance
		 * @return 	dot product result <code>Number</code>
		 */
		public function getDotProduct( p:Point ) : Number
		{
			return (x * p.x) + (y * p.y);
		}
		
		/**
		 * Calculates and returns cross product between this instance
		 * and passed-in <code>Point</code> instance.
		 * 
		 * @example
		 * <listing>
		 *   var p0 : Point = new Point(10,2);
		 *   var p1 : Point = new Point(5,6);
		 *   
		 *   var nDotP : Number = p0.getCrossProduct( p1 );
		 * </listing>
		 * 
		 * @param 	a <code>Point</code> instance
		 * @return 	cross product result </code>Number<code>
		 */
		public function getCrossProduct( p:Point ) : Number
		{
			return (x * p.y) - (y * p.x);
		}
		
		/**
		 * Multiplies each instance property by passed-in <code>scalar</code> value.
		 * 
		 * <p>Warning : Instance is directly modified.
		 * 
		 * @example
		 * <listing>
		 *   var p : Point = new Point(10,2);
		 *   p.scalarMultiply(5);
		 * </listing>
		 * 
		 * @param a <code>Number</code> value
		 * @throw	IllegalOperationError	Point.normalize called on a zero length vector.
		 */
		public function scalarMultiply( n:Number ) : void
		{
			if( isNaN ( n ) )
			{
				PixlibDebug.WARN( this + ".scalarMultiply() was called with an invalid number!" );
				throw new ArgumentError ( this + ".scalarMultiply() was called with an invalid number!" );
			}

			x *= n;
			y *= n;
		}
		
		/**
		 * Returns a new <code>Point</code> instance, result of projection of this instance 
		 * on passed-in <code>Point</code> instance.
		 * 
		 * @example
		 * <listing>
		 *   var p1 : Point = new Point(10,2);
		 *   var p2 : Point = new Point(5,5);
		 *   
		 *   var p3 : Point = p1.project( p2 ); //Projection Point result
		 * </listing>  
		 * @param p1 a <code>Point</code> instance
		 * 
		 * @return new <code>Point</code> instance (instance projected on passed-in p1 Point).
		 */
		public function project( p1:Point ) : Point
		{
			var n:Number = p1.getDotProduct(p1);
			if( n == 0)
			{
				//zero-length
				PixlibDebug.WARN( this + ".project() was given a zero-length projection vector!" );
				return clone();
			}
			else
			{
				var p0:Point = p1.clone();
				p0.scalarMultiply( getDotProduct(p1) / n );
				return p0;
			}
		}
		
		/**
		 * Return the scale of the projection in comparison of the original vector.
		 * 
		 * @example
		 * <listing>
		 * 		var p1 : Point = new Point(10,2);
		 *   	var p2 : Point = new Point(5,5);
		 *   
		 *   	var p3 : Point = p1.project( p2 ); // Projection Point result
		 * 		var l : Number = p1.getProjectionLength ( p2 ); // Projection Length result
		 * 		p3.equals ( p2.scalarMultiply ( l ) ) // return true;	
		 * </listing>
		 * @param p1 A <code>Point</code> instance.
		 */
		public function getProjectionLength( p1:Point ) : Number
		{
			var n:Number = p1.getDotProduct(p1);
			if( n == 0)
			{
				//zero-length
				PixlibDebug.WARN( this + ".getProjectionLength() was given a zero-length projection vector!" );
				return 0;
			}
			else
			{
				var p0:Point = p1.clone();
				return Math.abs( getDotProduct(p1) / n );
			}
		}
		
		/**
		 * Rotates a vector around its origin as with the use of the
		 * <code>flash.geom.Matrix</code> object.
		 * 
		 * <p>The current vector is modified, if you attempt to get a 
		 * new vector use the <code>Point.rotateNew</code> method.</p>
		 * 
		 * @param a	<code>Number</code> of radians to rotate the vector.
		 */
		public function rotate ( a : Number ) : void
		{
			var m : Matrix = new Matrix();
			m.rotate( a );
			
			fromFlashPoint( m.transformPoint( toFlashPoint() ) );
		}
		
		/**
		 * Fills the current point with value from a <code>flash.geom.Point</code>.
		 * 
		 * @param p	<code>flash.geom.Point</code> to copy in the current point.
		 */
		public function fromFlashPoint( p : flash.geom.Point ) : void
		{
			init( p.x, p.y );
		}
		
		/**
		 * Returns a new <code>flash.geom.Point</code> with values values
		 * from the current object.
		 * 
		 * @return <code>flash.geom.Point</code> conversion of this point.
		 */
		public function toFlashPoint () : flash.geom.Point
		{
			return new flash.geom.Point( x, y );
		}
		
		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return <code>String</code> representation of this instance
		 */
		public function toString(): String
		{
			return PixlibStringifier.stringify( this ) + ' : [' + String(x) + ', ' + String(y) + ']';
		}
		
		/*
		 * Static methods
		 */
		 
		 /**
		 * Returns distance between 2 passed-in <code>Point</code> instance.
		 * 
		 * @param p1 <code>Point</code> instance
		 * @param p2 <code>Point</code> instance
		 * 
		 * @return <code>Number</code> distance value
		 */
		public static function getDistance(p1:Point, p2:Point) : Number
		{
			return Point.minusNew(p1, p2).getLength();
		}
		 
		/**
		 * Calculates and returns new <code>Point</code> instance, resulting of 
		 * substraction between 2 passed-in <code>Point</code> instances.
		 * 
		 * @example
		 * <listing>
		 *   var p1 : Point = new Point(10,2);
		 *   var p2 : Point = new Point(5,1);
		 *   
		 *   var p3 : Point = Point.minusNew(p1, p2);
		 * </code>
		 * 
		 * @param p a <code>Point</code> instance
		 */
		public static function minusNew(p1:Point, p2:Point) : Point
		{ 
			return new Point(p1.x - p2.x, p1.y - p2.y); 
		}
		
		/**
		 * Calculates and returns new <code>Point</code> instance, resulting of 
		 * addition between 2 passed-in <code>Point</code> instances.
		 * 
		 * @example
		 * <listing>
		 *   var p1 : Point = new Point(10,2);
		 *   var p2 : Point = new Point(5,1);
		 *   
		 *   var p3 : Point = Point.plusNew(p1, p2);
		 * </code>
		 * 
		 * @param p a <code>Point</code> instance
		 */
		public static function plusNew(p1:Point, p2:Point) : Point 
		{ 
			return new Point(p1.x + p2.x, p1.y + p2.y); 
		}
	
		/**
		 * Returns a new <code>Point</code> with passed-in <code>Point</code>
		 * negative properties.
		 * 
		 * @example
		 * <listing>
		 *   var p1 : Point = new Point(10,2);
		 *   var p2 : Point = Point.negNew( p1 ); //equal to new Point(-10, -2);
		 * </code>
		 * 
		 * @param p a <code>Point</code> instance
		 */
		public static function negNew(p:Point) : Point 
		{ 
			return new Point( -p.x, -p.y); 
		}
		
		/**
		 * Returns a new <code>Point</code> with passed-in <code>Point</code> 
		 * absolute properties.
		 * 
		 * @example
		 * <listing>
		 *   var p1 : Point = new Point(10, -2);
		 *   var p2 : Point = Point.absNew( p1 ); //equal to new Point(10, 2);
		 * </listing>
		 * 
		 * @param p a <code>Point</code> instance
		 */
		public static function absNew(p:Point) : Point 
		{ 
			return new Point( Math.abs(p.x), Math.abs(p.y) ); 
		}
		
		/**
		 * Returns a new <code>Point</code> object witch is the passed-in
		 * <code>Point</code> multiply with the passed-in multiplier.
		 * 
		 * @param p		<code>Point</code> to multiply
		 * @param mult	<code>Number</code> multiplier for the point.
		 * @return 		<code>Point</code> results of the scalar multiplication.
		 */
		public static function scalarMultiplyNew ( p : Point, mult : Number ) : Point
		{
			return new Point ( p.x * mult, p.y * mult );
		}
		
		/**
		 * Returns a new <code>Point</code> object witch is the passed-in
		 * <code>Point</code> rotated with the passed-in angle.
		 * 
		 * @param p		<code>Point</code> to multiply
		 * @param mult	<code>Number</code> radians to rotate the vector.
		 * @return 		<code>Point</code> results of the rotation.
		 */
		public static function rotateNew ( p : Point, a : Number ) : Point
		{
			var p2 : Point = p.clone();
			p2.rotate( a );
			return p2;
		}
		
		/**
		 * Returns a new <code>Point</code> with values contained in the
		 * passed-in <code>flash.geom.Point</code>.
		 * 
		 * @param p	<code>flash.geom.Point</code> to convert.
		 * @return  <code>Point</code> result of the conversion.
		 */
		public static function fromFlashPointNew ( p : flash.geom.Point ) : Point
		{
			var p1 : Point = new Point();
			p1.fromFlashPoint( p );
			return p1;
		}
		
		/**
		 * Returns a new <code>flash.geom.Point</code> with values contained in the
		 * passed-in <code>Point</code>.
		 * 
		 * @param p	<code>Point</code> to convert.
		 * @return  <code>flash.geom.Point</code> result of the conversion.
		 */
		public static function toFlashPointNew ( p : Point ) : flash.geom.Point
		{
			return p.toFlashPoint();
		}
	}
}