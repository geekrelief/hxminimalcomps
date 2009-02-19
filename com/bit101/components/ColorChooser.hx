/**
 * ColorChooser.as
 * Keith Peters
 * version 0.96
 * 
 * A bare bones Color Chooser component, allowing for textual input only.
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
	
	class ColorChooser extends Component {
		
		public var value(_getValue, _setValue) : UInt ;
		var _input:InputText;
		var _swatch:Sprite;
		var _value:UInt ;
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this ColorChooser.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param value The initial color value of this component.
		 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
		 */
		public function new(?parent:DisplayObjectContainer = null, ?xpos:Float = 0, ?ypos:Float =  0, ?value:UInt = 0xff0000, ?defaultHandler:Dynamic = null)
		{
			_value = value;
			super(parent, xpos, ypos);
			if(defaultHandler != null)
			{
				addEventListener(Event.CHANGE, defaultHandler);
			}
		}
		
		
		/**
		 * Initializes the component.
		 */
		override function init():Void
		{
			super.init();

			_width = 65;
			_height = 15;
			value = _value;
		}
		
		override function addChildren():Void
		{
			_input = new InputText();
			_input.width = 45;
			_input.restrict = "0123456789ABCDEFabcdef";
			_input.maxChars = 6;
			addChild(_input);
			_input.addEventListener(Event.CHANGE, onChange);
			
			_swatch = new Sprite();
			_swatch.x = 50;
			_swatch.filters = [getShadow(2, true)];
			addChild(_swatch);
			
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
			_swatch.graphics.clear();
			_swatch.graphics.beginFill(_value);
			_swatch.graphics.drawRect(0, 0, 16, 16);
			_swatch.graphics.endFill();
		}
		
		
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Internal change handler.
		 * @param event The Event passed by the system.
		 */
		function onChange(event:Event):Void
		{
			event.stopImmediatePropagation();
			_value = Std.parseInt("0x" + _input.text);
			_input.text = _input.text.toUpperCase();
			invalidate();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Gets / sets the color value of this ColorChooser.
		 */
		function _setValue(n:UInt):UInt
		{
			var str:String = StringTools.hex(n, 6);
			_input.text = str;
			_value = Std.parseInt("0x" + str);
			invalidate();
			return n;
		}
		function _getValue():UInt
		{
			return _value;
		}
	}
