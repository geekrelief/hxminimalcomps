/**
 * VUISlider.as
 * Keith Peters
 * version 0.96
 * 
 * A vertical Slider with a label and value label.
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
	import flash.events.Event;

	class VUISlider extends UISlider {
		
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this VUISlider.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param label The string to use as the label for this component.
		 * @param defaultHandler The event handling function to handle the default event for this component.
		 */
		public function new(?parent:DisplayObjectContainer = null, ?x:Float = 0, ?y:Float = 0, ?label:String = "", ?defaultEventHandler:Dynamic = null)
		{
			_sliderClass = VSlider;
			super(parent, x, y, label, defaultEventHandler);
		}
		
		/**
		 * Initializes this component.
		 */
		override function init():Void
		{
			super.init();
			setSize(20, 146);
		}
		
		
		
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		public override function draw():Void
		{
			super.draw();
			_label._x = _width / 2 - _label._width / 2;
			
			_slider._x = _width / 2 - _slider._width / 2;
			_slider._y = _label._height + 5;
			_slider._height = _height - _label._height - _valueLabel._height - 10;
			
			_valueLabel._x = _width / 2 - _valueLabel._width / 2;
			_valueLabel._y = _slider._y + _slider._height + 5;
		}
		
		override function positionLabel():Void
		{
			_valueLabel._x = _width / 2 - _valueLabel._width / 2;
		}
		
		
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		override function _getWidth():Float
		{
			if(_label == null) return _width;
			return Math.max(_width, _label.width);
		}
		
	}
