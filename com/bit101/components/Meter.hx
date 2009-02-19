/**
 * Meter.as
 * Keith Peters
 * version 0.96
 * 
 * A meter component similar to a voltage meter, with a dial and a needle that indicates a value.
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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	
	class Meter extends Component {
		
		public var label(_getLabel, _setLabel) : String ;
		public var maximum(_getMaximum, _setMaximum) : Float ;
		public var minimum(_getMinimum, _setMinimum) : Float ;
		public var showValues(_getShowValues, _setShowValues) : Bool ;
		public var value(_getValue, _setValue) : Float ;
		var _damp:Float ;
		var _dial:Sprite;
		var _label:Label;
		var _labelText:String;
		var _maximum:Float ;
		var _maxLabel:Label;
		var _minimum:Float ;
		var _minLabel:Label;
		var _needle:Sprite;
		var _needleMask:Sprite;
		var _showValues:Bool ;
		var _targetRotation:Float ;
		var _value:Float ;
		var _velocity:Float ;
		
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this Meter.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param text The string to use as the initial text in this component.
		 */
		public function new(?parent:DisplayObjectContainer = null, ?xpos:Float = 0, ?ypos:Float =  0, ?text:String = "")
		{
			
			_damp = .8;
			_maximum = 1.0;
			_minimum = 0.0;
			_showValues = true;
			_targetRotation = 0;
			_value = 0.0;
			_velocity = 0;
			_labelText = text;
			super(parent, xpos, ypos);
		}
		
		/**
		 * Initializes the component.
		 */
		override function init():Void
		{
			super.init();
			_width = 200;
			_height = 100;
		}
		
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override function addChildren():Void
		{ 
			_dial = new Sprite();
			addChild(_dial);

			_needle = new Sprite();
			_needle.rotation = -50;
			_dial.addChild(_needle);
			
			_needleMask = new Sprite();
			addChild(_needleMask);
			_dial.mask = _needleMask;
			
			_minLabel = new Label(this);
			_minLabel.text = Std.string(_minimum);
			
			_maxLabel = new Label(this);
			_maxLabel.autoSize = true;
			_maxLabel.text = Std.string(_maximum);
			
			_label = new Label(this);
			_label.text = _labelText;
		}
		
		 
		 
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Draws the visual ui of the component.
		 */
		public override function draw():Void
		{
			var startAngle:Float = -140 * Math.PI / 180;
			var endAngle:Float = -40 * Math.PI / 180;
			
			drawBackground();
			drawDial(startAngle, endAngle);
			drawTicks(startAngle, endAngle);
			drawNeedle();
			
			_minLabel.move(10, _height - _minLabel._height - 4);
			_maxLabel.move(_width - _maxLabel._width - 10, _height - _maxLabel._height - 4);
			_label.move((_width - _label._width) / 2, _height * .5);
			update();
		}
		
		/**
		 * Sets the size of the component. Adjusts height to be 1/2 width.
		 * @param w The width of the component.
		 * @param h The height of the component.
		 */
		public override function setSize(w:Float, h:Float):Void
		{
			super.setSize(w, w / 2);
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Draws the background of the component.
		 */
		function drawBackground():Void
		{
			graphics.clear();
			graphics.beginFill(Style.BACKGROUND);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
			
			graphics.beginFill(Style.PANEL);
			graphics.drawRect(1, 1, _width - 2, _height - 2);
			graphics.endFill();
		}
		
		/**
		 * Draws the dial.
		 */
		function drawDial(startAngle:Float, endAngle:Float):Void
		{
			_dial.x = _width / 2;
			_dial.y = _height * 1.25;
			_dial.graphics.clear();
			_dial.graphics.lineStyle(0, Style.BACKGROUND);
			_dial.graphics.beginFill(Style.BUTTON_FACE);
			var r1:Float = _height * 1.05;
			var r2:Float = _height * 0.96;
			
			_dial.graphics.moveTo(Math.cos(startAngle) * r1, Math.sin(startAngle) * r1);
			var i:Float = startAngle;
			while (i < endAngle)
			{
				_dial.graphics.lineTo(Math.cos(i) * r1, Math.sin(i) * r1);
				i += 0.1;
			}
			_dial.graphics.lineTo(Math.cos(endAngle) * r1, Math.sin(endAngle) * r1);
			
			_dial.graphics.lineTo(Math.cos(endAngle) * r2, Math.sin(endAngle) * r2);
			i = endAngle;
			while (i > startAngle)
			{
				_dial.graphics.lineTo(Math.cos(i) * r2, Math.sin(i) * r2);
				i -= 0.1;
			}
			_dial.graphics.lineTo(Math.cos(startAngle) * r2, Math.sin(startAngle) * r2);
			_dial.graphics.lineTo(Math.cos(startAngle) * r1, Math.sin(startAngle) * r1);
			
		}
		
		/**
		 * Draws the tick marks on the dial.
		 */
		function drawTicks(startAngle:Float, endAngle:Float):Void
		{
			var r1:Float = _height * 1.05;
			var r2:Float = _height * 0.96;
			var r3:Float = _height * 1.13;
			var tick:Float = 0;
			for(i in 0...9)
			{
				var angle:Float = startAngle + i * (endAngle - startAngle) / 8;
				_dial.graphics.moveTo(Math.cos(angle) * r2, Math.sin(angle) * r2);
				if(tick++ % 2 == 0)
				{
					_dial.graphics.lineTo(Math.cos(angle) * r3, Math.sin(angle) * r3);
				}
				else
				{
					_dial.graphics.lineTo(Math.cos(angle) * r1, Math.sin(angle) * r1);
				}
			}
		}
		
		/**
		 * Draws the needle.
		 */
		function drawNeedle():Void
		{
			_needle.graphics.clear();
			_needle.graphics.beginFill(0xff0000);
			_needle.graphics.drawRect(-0.5, -_height * 1.10, 1, _height * 1.10);
			_needle.filters = [new DropShadowFilter(4, 0, 0, 1, 3, 3, .2)];
			
			_needleMask.graphics.clear();
			_needleMask.graphics.beginFill(0);
			_needleMask.graphics.drawRect(0, 0, _width, _height);
			_needleMask.graphics.endFill();
		}
		
		/**
		 * Updates the target rotation of the needle and starts an enterframe handler to spring it to that point.
		 */
		function update():Void
		{
			_value = Math.min(Math.max(_value, _minimum), _maximum);
			_targetRotation = -50 + _value / (_maximum - _minimum) * 100;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Handles the enterFrame event to spring the needle to the target rotation.
		 */
		function onEnterFrame(event:Event):Void
		{
			var dist:Float = _targetRotation - _needle.rotation;
			_velocity += dist * .05;
			_velocity *= _damp;
			if(Math.abs(_velocity) < .1 && Math.abs(dist) < .1)
			{
				_needle.rotation = _targetRotation;
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			else
			{
				_needle.rotation += _velocity;
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Gets / sets the maximum value for the meter.
		 */
		function _setMaximum(value:Float):Float
		{
			_maximum = value;
			_maxLabel.text = Std.string(_maximum);
			update();
			return value;
		}
		function _getMaximum():Float
		{
			return _maximum;
		}
		
		/**
		 * Gets / sets the minimum value for the meter.
		 */
		function _setMinimum(value:Float):Float
		{
			_minimum = value;
			_minLabel.text = Std.string(_minimum);
			update();
			return value;
		}
		function _getMinimum():Float
		{
			return _minimum;
		}
		
		/**
		 * Gets / sets the current value for the meter.
		 */
		function _setValue(val:Float):Float
		{
			_value = val;
			update();
			return val;
		}
		function _getValue():Float
		{
			return _value;
		}
		
		/**
		 * Gets / _sets the label shown on the meter.
		 */
		function _setLabel(value:String):String
		{
			_labelText = value;
			_label.text = _labelText;
			return value;
		}
		function _getLabel():String
		{
			return _labelText;
		}
		
		/**
		 * Gets / _sets whether or not value labels will be shown for max and min values.
		 */
		function _setShowValues(value:Bool):Bool
		{
			_showValues = value;
			_minLabel._visible = _showValues;
			_maxLabel._visible = _showValues;
			return value;
		}
		function _getShowValues():Bool
		{
			return _showValues;
		}
	}
