/**
 * IndicatorLight.as
 * Keith Peters
 * version 0.96
 * 
 * An indicator light that can be turned on, off, or set to flash.
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
 */

package com.bit101.components;

	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	
	class IndicatorLight extends Component {
		
		public var color(getColor, setColor) : UInt
		;
		public var isFlashing(getIsFlashing, null) : Bool
		;
		public var isLit(getIsLit, setIsLit) : Bool
		;
		var _color:UInt;
		var _lit:Bool ;
		var _label:Label;
		var _labelText:String ;
		var _lite:Shape;
		var _timer:Timer;
		
		
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this CheckBox.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param color The color of this light.
		 * @param label String containing the label for this component.
		 */
		public function new(?parent:DisplayObjectContainer = null, ?xpos:Int = 0, ?ypos:Int =  0, ?color:UInt = 0xff0000, ?label:String = "")
		{
			
			_lit = false;
			_labelText = "";
			_color = color;
			_labelText = label;
			super(parent, xpos, ypos);
		}

		/**
		 * Initializes the component.
		 */
		override function init():Void
		{
			super.init();
			setSize(10, 10);
			_timer = new Timer(500);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		/**
		 * Creates the children for this component
		 */
		override function addChildren():Void
		{
			_lite = new Shape();
			addChild(_lite);
			
			_label = new Label();
			addChild(_label);
		}
		
		/**
		 * Draw the light.
		 */
		function drawLite():Void
		{
			var colors:Array<Dynamic>;
			if(_lit)
			{
				colors = [0xffffff, _color];
			}
			else
			{
				colors = [0xffffff, 0];
			}
			
			_lite.graphics.clear();
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(10, 10, 0, -2.5, -2.5);
			_lite.graphics.beginGradientFill(GradientType.RADIAL, colors, [1, 1], [0, 255], matrix);
			_lite.graphics.drawCircle(5, 5, 5);
			_lite.graphics.endFill();
		}
		
		
		
		///////////////////////////////////
		// event handler
		///////////////////////////////////
		
		/**
		 * Internal timer handler.
		 * @param event The TimerEvent passed by the system.
		 */
		function onTimer(event:TimerEvent):Void
		{
			_lit = !_lit;
			draw();
		}
		
		
		
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Draws the visual ui of the component.
		 */
		public override function draw():Void
		{
			super.draw();
			drawLite();
			
			_label.text = _labelText;
			_label.x = _width + 2;
			_label.y = _height / 2 - _label.height / 2;
		}
		
		/**
		 * Causes the light to flash on and off at the specified interval (milliseconds). A value less than 1 stops the flashing.
		 */
		public function flash(?interval:Int = 500):Void
		{
			if(interval < 1)
			{
				_timer.stop();
				isLit = false;
				return;
			}
			_timer.delay = interval;
			_timer.start();
		}
		
		
		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets or gets whether or not the light is lit.
		 */
		public function setIsLit(value:Bool):Bool
		{
			_timer.stop();
			_lit = value;
			drawLite();
			return value;
		}
		public function getIsLit():Bool
		{
			return _lit;
		}
		
		/**
		 * Sets / gets the color of this light (when lit).
		 */
		public function setColor(value:UInt):UInt
		{
			_color = value;
			draw();
			return value;
		}
		public function getColor():UInt
		{
			return _color;
		}
		
		/**
		 * Returns whether or not the light is currently flashing.
		 */
		public function getIsFlashing():Bool
		{
			return _timer.running;
		}
	}
