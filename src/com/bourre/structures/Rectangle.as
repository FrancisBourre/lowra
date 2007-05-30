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
	/**
	 * <code>Rectangle</code> data structure.
	 * 
	 * <p><code>Rectangle</code> structure manage many informations like : 
	 * <ul>
	 *   <li>Center point</li>
	 *   <li>Top left corner</li>
	 *   <li>Top Right corner</li>
	 *   <li>Bottom left corner</li>
	 *   <li>Bottom Right corner</li>
	 *   <li>Left border</li>
	 *   <li>Right border</li>
	 *   <li>Top border</li>
	 *   <li>Bottom border</li>
	 *   <li>and position</li>
	 * </ul>
	 * 
	 * @author Francis Bourre
	 * @author Cédric Néhémie
	 * @version 1.0
	 */
	 
	import com.bourre.log.PixlibStringifier;
	import com.bourre.structures.Point;
	
	import flash.geom.Rectangle;
	
	public class Rectangle
	{
		//-------------------------------------------------------------------------
		// Public Properties
		//-------------------------------------------------------------------------
		
		/** width of <code>Rectangle</code>. **/
		public var width : Number;
		
		/** height of <code>Rectangle</code>. **/
		public var height : Number;
		
		/** x coordinate of <code>Rectangle</code>. **/
		public var x : Number;
		
		/** y coordinate of <code>Rectangle</code>. **/
		public var y : Number;
		
		//-------------------------------------------------------------------------
		// Public API
		//-------------------------------------------------------------------------
		
		/**
		 * Constructs a new <code>Rectangle</code> instance.
		 * 
		 * @param w width
		 * @param h height
		 * @param x x position
		 * @param y position
		 */
		public function Rectangle(w:Number = 0, h:Number = 0, x:Number = 0, y:Number = 0) 
		{
			width = w;
			height = h;
			this.x = x ? x : 0;
			this.y = y ? y : 0;
		}
		
		/**
		 * Creates and returns a clone of the current <code>Rectangle</code> object. 
		 * 
		 * @return <code>Rectangle</code> copy of the current object.
		 */
		public function clone () : Rectangle
		{
			return new Rectangle ( width, height, x, y );
		}
		
		/**
		 * Returns top left corner.
		 * 
		 * @return <code>Point</code> instance with top left position
		 */
		public function getTopLeft() : Point
		{
			return new Point( x , y );
		}
		
		/**
		 * Sets the top left corner.
		 * 
		 * <p>Modifying a corner change the size of the rectangle, 
		 * use <code>x</code> and <code>y</code> properties to align a rectangle
		 * to a position.
		 * 
		 * @return <code>Point</code> instance with new top left position
		 */
		public function setTopLeft( p : Point ) : void
		{
			setLeft ( p.x );
			setTop ( p.y );
		}
		
		/**
		 * Returns top right corner.
		 * 
		 * @return <code>Point</code> instance with top right position
		 */
		public function getTopRight() : Point
		{
			return new Point( getRight() , y );
		}
		
		/**
		 * Sets the top right corner.
		 * 
		 * <p>Modifying a corner change the size of the rectangle, 
		 * use <code>x</code> and <code>y</code> properties to align a rectangle
		 * to a position.
		 * 
		 * @return <code>Point</code> instance with new top right position
		 */
		public function setTopRight( p : Point ) : void
		{
			setRight ( p.x );
			setTop ( p.y );
		}
		
		/**
		 * Returns bottom left corner.
		 * 
		 * @return <code>Point</code> instance with bottom left position
		 */
		public function getBottomLeft() : Point
		{
			return new Point( x , getBottom() );
		}
		
		/**
		 * Sets the bottom left corner.
		 * 
		 * <p>Modifying a corner change the size of the rectangle, 
		 * use <code>x</code> and <code>y</code> properties to align a rectangle
		 * to a position.
		 * 
		 * @return <code>Point</code> instance with new bottom left position
		 */
		public function setBottomLeft( p : Point ) : void
		{
			setLeft ( p.x );
			setBottom ( p.y );
		}
		
		/**
		 * Returns bottom right corner.
		 * 
		 * @return <code>Point</code> instance with bottom right position
		 */
		public function getBottomRight() : Point
		{
			return new Point( getRight() , getBottom() );
		}
		
		/**
		 * Sets the bottom right corner.
		 * 
		 * <p>Modifying a corner change the size of the rectangle, 
		 * use <code>x</code> and <code>y</code> properties to align a rectangle
		 * to a position.
		 * 
		 * @return <code>Point</code> instance with new bottom right position
		 */
		public function setBottomRight( p : Point ) : void
		{
			setRight ( p.x );
			setBottom ( p.y );
		}
		
		/**
		 * Returns center point
		 * 
		 * @return <code>Point</code> instance with center position
		 */
		public function getCenter() : Point
		{
			return new Point(x + width/2, y + height/2);
		}
		
		/**
		 * Returns left border
		 * 
		 * @return <code>Number</code>
		 */
		public function getLeft () : Number
		{
			return x;
		}
		
		/**
		 * Sets the rectangle left border
		 * 
		 * @param	n The new left border
		 */
		public function setLeft ( n : Number ) : void
		{
			var d : Number = n - x;
			x = n;
			width -= d;
		}
		
		/**
		 * Returns right border
		 * 
		 * @return <code>Number</code>
		 */
		public function getRight () : Number
		{
			return x + width;
		}
		
		/**
		 * Sets the rectangle right border
		 * 
		 * @param	n The new right border
		 */
		public function setRight ( n : Number ) : void
		{
			width = n - x;
		}
		
		/**
		 * Returns top border
		 * 
		 * @return <code>Number</code>
		 */
		public function getTop () : Number
		{
			return y;
		}
		
		/**
		 * Sets the rectangle top border
		 * 
		 * @param	n The new top border
		 */
		public function setTop ( n : Number ) : void
		{
			var d : Number = n - y;
			y = n;
			height -= d;
		}
		
		/**
		 * Returns bottom border
		 * 
		 * @return <code>Number</code>
		 */
		public function getBottom () : Number
		{
			return y + height;
		}
		
		/**
		 * Sets the rectangle bottom border
		 * 
		 * @param	n The new bottom border
		 */
		public function setBottom ( n : Number ) : void
		{
			height = n - y;
		}
		
		/**
	     * Compares 2 rectangles each other.
	     * 
	     * <p>Rectangles are equals when size <b>and</b> position are
	     * equals.
	     *   
	     * @param   r     The <code>Rectangle</code> object to compare with the current one.
	     * @return  <code>true</code> if Rectangles are equals, <code>false</code> otherwise.
	     */    
		public function equals ( r : Rectangle ) : Boolean
		{
			return ( (x == r.x) && (y == r.y) && (width == r.width) && (height == r.height) );
		}
		
		/**
		 * Returns the area of the current <code>Rectangle</code> object.
		 * 
		 * @return <code>Number</code> of the <code>Rectangle</code> area.
		 */
		public function getArea () : Number
		{
			return Math.abs ( width * height );
		}
		
		/**
		 * Returns a <code>Point</code> object witch contain the size of the
		 * current <code>Rectangle</code>.
		 * 
		 * @return A <code>Point</code> object
		 */
		public function getSize () : Point
		{
			return new Point ( width, height );
		}
		
		/**
		 * Returns <code>true</code> when and only when the current
		 * rectangle and the passed-in rectangle intersect them-self.
		 * 
		 * <p>Rectangles intersects if they have at least one coordinates
		 * in common.</p>
		 * 
		 * @param rect <code>Rectangle</code> to compare to the current one.
		 * @return <code>true</code> if the two rectangles are intersected, 
		 * 		   <code>false</code> otherwise.
		 * 
		 */
		public function intersects ( rect : Rectangle ) : Boolean
		{
			return( x <= rect.x + rect.width &&
					x + width >= rect.x &&
					y <= rect.y + rect.height &&
					y + height >= rect.y );
		}
		
		/**
		 * Returns <code>true</code> if the passed-in point coordinates are contained
		 * in the current rectangle.
		 * 
		 * @param p	<code>Point</code> to check.
		 * @return <code>true</code> if the point is contained in the current rectangle,
		 * 		   <code>false</code> otherwise.
		 */
		public function contains ( p : Point ) : Boolean
		{
			return ( 	p.x >= getLeft() &&
						p.x <= getRight() &&
						p.y >= getTop() &&
						p.y <= getBottom() );
		}
		
		/**
		 * Fills the current <code>Rectangle</code> with values of the passed-in
		 * <code>flash.geom.Rectangle</code>.
		 * 
		 * @param rect <code>flash.geom.Rectangle</code> to use as source for the
		 * 			   current rectangle.
		 */
		public function fromFlashRectangle ( rect : flash.geom.Rectangle ) : void
		{
			x = rect.x;
			y = rect.y;
			width = rect.width;
			height = rect.height;
		}
		
		/**
		 * Converts the current rectangle in a <code>flash.geom.Rectangle</code>
		 * object.
		 * 
		 * @return <code>flash.geom.Rectangle</code> result of the conversion.
		 * 
		 */
		public function toFlashRectangle () : flash.geom.Rectangle
		{
			return new flash.geom.Rectangle( x, y, width, height );
		}
		
		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return <code>String</code> representation of this instance
		 */
		public function toString() : String
		{
			return PixlibStringifier.stringify( this ) + " : [" + width + ", " + height + ", " + x + ", " + y + "]";
		}
	}
}