/**
 * WheelMenu.as
 * Keith Peters
 * version 0.96
 * 
 * A radial menu that pops up around the mouse.
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
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;

	class WheelMenu extends Component {
		
		public var borderColor(getBorderColor, setBorderColor) : UInt
		;
		public var color(getColor, setColor) : UInt
		;
		public var highlightColor(getHighlightColor, setHighlightColor) : UInt
		;
		public var selectedIndex(getSelectedIndex, null) : Int
		;
		public var selectedItem(getSelectedItem, null) : Dynamic
		;
		var _borderColor:UInt ;
		var _buttons:Array<Dynamic>;
		var _color:UInt ;
		var _highlightColor:UInt ;
		var _iconRadius:Float;
		var _innerRadius:Float;
		var _items:Array<Dynamic>;
		var _numButtons:Int;
		var _outerRadius:Float;
		var _selectedIndex:Int ;
		var _startingAngle:Int ;
		
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this component.
		 * @param numButtons The number of segments in the menu
		 * @param outerRadius The radius of the menu as a whole.
		 * @parem innerRadius The radius of the inner circle at the center of the menu.
		 * @param defaultHandler The event handling function to handle the default event for this component (select in this case).
		 */
		public function new(parent:DisplayObjectContainer, numButtons:Int, ?outerRadius:Int = 80, ?iconRadius:Int = 60, ?innerRadius:Int = 10, ?defaultHandler:Dynamic = null)
		{
			
			_borderColor = 0xcccccc;
			_color = 0xffffff;
			_highlightColor = 0xeeeeee;
			_selectedIndex = -1;
			_startingAngle = -90;
			_numButtons = numButtons;
			_outerRadius = outerRadius;
			_iconRadius = iconRadius;
			_innerRadius = innerRadius;
			super(parent);
			
			if(defaultHandler != null)
			{
				addEventListener(Event.SELECT, defaultHandler);
			}
		}
			
		///////////////////////////////////
		// protected methods
		///////////////////////////////////
		
		/**
		 * Initializes the component.
		 */
		override function init():Void
		{
			super.init();
			_items = new Array();
			makeButtons();

			filters = [new DropShadowFilter(4, 45, 0, 1, 4, 4, .2, 4)];
			hide();
		}
		
		/**
		 * Creates the buttons that make up the wheel menu.
		 */
		function makeButtons():Void
		{
			_buttons = new Array();
			for(i in 0..._numButtons)
			{
				var btn:ArcButton = new ArcButton(Math.PI * 2 / _numButtons, _outerRadius, _iconRadius, _innerRadius);
				btn.id = i;
				btn.rotation = _startingAngle + 360 / _numButtons * i;
				btn.addEventListener(Event.SELECT, onSelect);
				addChild(btn);
				_buttons.push(btn);
			}
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Hides the menu.
		 */
		public function hide():Void
		{
			visible = false;
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}
		
		/**
		 * Sets the icon / text and data for a specific menu item.
		 * @param index The index of the item to set icon/text and data for.
		 * @iconOrLabel Either a display object instance, a class that extends DisplayObject, or text to show in a label.
		 * @data Any data to associate with the item.
		 */
		public function setItem(index:Int, iconOrLabel:Dynamic, ?data:Dynamic = null):Void
		{
			_buttons[index].setIcon(iconOrLabel);
			_items[index] = data;
		}
		
		/**
		 * Shows the menu - placing it on top level of parent and centering around mouse.
		 */
		public function show():Void
		{
			parent.addChild(this);
			x = Math.round(parent.mouseX)
			y = Math.round(parent.mouseY);
			_selectedIndex = -1;
			visible = true;
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Called when one of the buttons is selected. Sets selected index and dispatches select event.
		 */
		function onSelect(event:Event):Void
		{
			_selectedIndex = event.target.id;
			dispatchEvent(new Event(Event.SELECT));
		}
		
		/**
		 * Called when mouse is released. Hides menu.
		 */
		function onStageMouseUp(event:MouseEvent):Void
		{
			hide();
		}
		
		///////////////////////////////////
		// getter / setters
		///////////////////////////////////
		
		/**
		 * Gets / sets the color of the border around buttons.
		 */
		public function setBorderColor(value:UInt):UInt
		{
			_borderColor = value;
			for(i in 0..._numButtons)
			{
				_buttons[i].borderColor = _borderColor;
			}
			return value;
		}
		public function getBorderColor():UInt
		{
			return _borderColor;
		}
		
		/**
		 * Gets / sets the base color of buttons.
		 */
		public function setColor(value:UInt):UInt
		{
			_color = value;
			for(i in 0..._numButtons)
			{
				_buttons[i].color = _color;
			}
			return value;
		}
		public function getColor():UInt
		{
			return _color;
		}
		
		/**
		 * Gets / sets the highlighted color of buttons.
		 */
		public function setHighlightColor(value:UInt):UInt
		{
			_highlightColor = value;
			for(i in 0..._numButtons)
			{
				_buttons[i].selectedColor = _highlightColor;
			}
			return value;
		}
		public function getHighlightColor():UInt
		{
			return _highlightColor;
		}
		
		/**
		 * Gets the selected index.
		 */
		public function getSelectedIndex():Int
		{
			return _selectedIndex;
		}
		
		/**
		 * Gets the selected item.
		 */
		public function getSelectedItem():Dynamic
		{
			return _items[_selectedIndex];
		}
		
	
		
	}
