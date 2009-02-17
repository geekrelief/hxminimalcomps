/**
 * Component.as
 * Keith Peters
 * version 0.96
 * 
 * Base class for all components
 * 
 * Copyright (c) 2008 Keith Peters
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 * 
 * 
 * Components with text make use of the font PF Ronda Seven by Yuusuke Kamiyamane
 * This is a free font obtained from http://www.dafont.com/pf-ronda-seven.font
 */
 
package com.bit101.components;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;

	class Component extends Sprite {
		
		public var _height(getHeight, setHeight) : Float ;
		public var _width(getWidth, setWidth) : Float ;
		public var _x(getX, setX) : Float;
		public var _y(getY, setY) : Float;
		/*[Embed(source="/assets/pf_ronda_seven.ttf", fontName="PF Ronda Seven", mimeType="application/x-font")]*/
		var Ronda:Class<Dynamic>;
		
        /*
		var _width:Float ;
		var _height:Float ;
        */
		
		public static var DRAW:String = "draw";

		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this component.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		public function new(?parent:DisplayObjectContainer = null, ?xpos:Int = 0, ?ypos:Int =  0){
			
			_width = 0;
			_height = 0;
			move(xpos, ypos);
			if(parent != null)
			{
				parent.addChild(this);
			}
			init();
		}
		
		/**
		 * Initializes the component.
		 */
		function init():Void
		{
			addChildren();
			invalidate();
		}
		
		/**
		 * Overriden in subclasses to create child display objects.
		 */
		function addChildren():Void
		{
			
		}
		
		/**
		 * DropShadowFilter factory method, used in many of the components.
		 * @param dist The distance of the shadow.
		 * @param knockout Whether or not to create a knocked out shadow.
		 */
		function getShadow(dist:Float, ?knockout:Bool = false):DropShadowFilter
		{
			return new DropShadowFilter(dist, 45, Style.DROPSHADOW, 1, dist, dist, .3, 1, knockout);
		}
		
		/**
		 * Marks the component to be redrawn on the next frame.
		 */
		function invalidate():Void
		{
//			draw();
			addEventListener(Event.ENTER_FRAME, onInvalidate);
		}
		
		
		
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Utility method to set up usual stage align and scaling.
		 */
		public static function initStage(stage:Stage):Void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		/**
		 * Moves the component to the specified position.
		 * @param xpos the x position to move the component
		 * @param ypos the y position to move the component
		 */
		public function move(xpos:Float, ypos:Float):Void
		{
			_x = xpos;
			_y = ypos;
		}
		
		/**
		 * Sets the size of the component.
		 * @param w The width of the component.
		 * @param h The height of the component.
		 */
		public function setSize(w:Float, h:Float):Void
		{
			_width = w;
			_height = h;
			invalidate();
		}
		
		/**
		 * Abstract draw function.
		 */
		public function draw():Void
		{
			dispatchEvent(new Event(Component.DRAW));
		}
		
		
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Called one frame after invalidate is called.
		 */
		function onInvalidate(event:Event):Void
		{
			removeEventListener(Event.ENTER_FRAME, onInvalidate);
			draw();
		}
		
		
		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets/gets the width of the component.
		 */
		function setWidth(w:Float):Float
		{
			_width = w;
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
			return w;
		}

		function getWidth():Float
		{
			return _width;
		}
		
		/**
		 * Sets/gets the height of the component.
		 */
		function setHeight(h:Float):Float
		{
			_height = h;
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
			return h;
		}
		function getHeight():Float
		{
			return _height;
		}

        function getX():Float {
            return x;
        }
		
		/**
		 * Overrides the setter for x to always place the component on a whole pixel.
		 */
		inline function setX(value:Float):Float{
			x = Math.round(value);
			return x;
		}

	    function getY():Float {
            return y;
        }
		
		/**
		 * Overrides the setter for y to always place the component on a whole pixel.
		 */
		inline function setY(value:Float):Float{
			y = Math.round(value);
			return y;
		}
	}
