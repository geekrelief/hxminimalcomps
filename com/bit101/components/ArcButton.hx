/**
 * ArcButton.as
 * Keith Peters
 * version 0.96
 * 
 * A radial menu button.
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


/**
 * ArcButton class used by WheelMenu.
 */
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.display.Shape;
import com.bit101.components.Label;

class ArcButton extends Sprite {
	
	public var borderColor(_getBorderColor, _setBorderColor) : UInt ;
	public var color(_getColor, _setColor) : UInt ;
	public var highlightColor(_getHighlightColor, _setHighlightColor) : UInt ;
	public var _rotation(_getRotation, _setRotation) : Float ;
	public var id:Int;
	
	var _arc:Float;
	var _bg:Shape;
	var _borderColor:UInt ;
	var _color:UInt ;
	var _highlightColor:UInt ;
	var _icon:DisplayObject;
	var _iconHolder:Sprite;
	var _iconRadius:Float;
	var _innerRadius:Float;
	var _outerRadius:Float;
	
	/**
	 * Constructor.
	 * @param arc The radians of the arc to draw.
	 * @param outerRadius The outer radius of the arc. 
	 * @param innerRadius The inner radius of the arc.
	 */
	public function new(arc:Float, outerRadius:Float, iconRadius:Float, innerRadius:Float)
	{
	    super();	
		_borderColor = 0xcccccc;
		_color = 0xffffff;
		_highlightColor = 0xeeeeee;
		_arc = arc;
		_outerRadius = outerRadius;
		_iconRadius = iconRadius;
		_innerRadius = innerRadius;
		
		_bg = new Shape();
		addChild(_bg);
		
		_iconHolder = new Sprite();
		addChild(_iconHolder);
		
		drawArc(0xffffff);
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}
	
	///////////////////////////////////
	// private methods
	///////////////////////////////////
	
	/**
	 * Draws an arc of the specified color.
	 * @param color The color to draw the arc.
	 */
	function drawArc(color:UInt):Void
	{
		_bg.graphics.clear();
		_bg.graphics.lineStyle(2, _borderColor);
		_bg.graphics.beginFill(color);
		_bg.graphics.moveTo(_innerRadius, 0);
		_bg.graphics.lineTo(_outerRadius, 0);
		var i:Float = 0;
		while (i < _arc)
		{
			_bg.graphics.lineTo(Math.cos(i) * _outerRadius, Math.sin(i) * _outerRadius);
			i += .05;
		}
		_bg.graphics.lineTo(Math.cos(_arc) * _outerRadius, Math.sin(_arc) * _outerRadius);
		_bg.graphics.lineTo(Math.cos(_arc) * _innerRadius, Math.sin(_arc) * _innerRadius);
		i = _arc;
		while (i > 0)
		{
			_bg.graphics.lineTo(Math.cos(i) * _innerRadius, Math.sin(i) * _innerRadius);
			i -= .05;
		}
		_bg.graphics.lineTo(_innerRadius, 0);
		
		graphics.endFill();
	}
	
	///////////////////////////////////
	// public methods
	///////////////////////////////////
	
	/**
	 * Sets the icon or label of this button.
	 * @param iconOrLabel Either a display object instance, a class that extends DisplayObject, or text to show in a label.
	 */
	public function setIcon(iconOrLabel:Dynamic):Void
	{
		if(iconOrLabel == null) return;
		while(_iconHolder.numChildren > 0) _iconHolder.removeChildAt(0);
		if(Std.is( iconOrLabel, Class))
		{
			_icon = cast( Type.createInstance(iconOrLabel, []), DisplayObject);
		}
		else if(Std.is( iconOrLabel, DisplayObject))
		{
			_icon = cast( iconOrLabel, DisplayObject);
		}
		else if(Std.is( iconOrLabel, String))
		{
			_icon = new Label(null, 0, 0, cast( iconOrLabel, String));
			(cast( _icon, Label)).draw();
		}
		if(_icon != null)
		{
			var angle:Float = _bg.rotation * Math.PI / 180;
			_icon.x = Math.round(-_icon.width / 2);
			_icon.y = Math.round(-_icon.height / 2);
			_iconHolder.addChild(_icon);
			_iconHolder.x = Math.round(Math.cos(angle + _arc / 2) * _iconRadius);
			_iconHolder.y = Math.round(Math.sin(angle + _arc / 2) * _iconRadius);
		}
	}
	
	
	///////////////////////////////////
	// event handlers
	///////////////////////////////////
	
	/**
	 * Called when mouse moves over this button. Draws highlight.
	 */
	function onMouseOver(event:MouseEvent):Void
	{
		drawArc(_highlightColor);
	}
	
	/**
	 * Called when mouse moves out of this button. Draw base color.
	 */
	function onMouseOut(event:MouseEvent):Void
	{
		drawArc(_color);
	}
	
	/**
	 * Called when mouse is released over this button. Dispatches select event.
	 */
	function onMouseUp(event:MouseEvent):Void
	{
		dispatchEvent(new Event(Event.SELECT));
	}

	
	///////////////////////////////////
	// getter / setters
	///////////////////////////////////
	
	/**
	 * Sets / gets border color.
	 */
	function _setBorderColor(value:UInt):UInt
	{
		_borderColor = value;
		drawArc(_color);
		return value;
	}
	function _getBorderColor():UInt
	{
		return _borderColor;
	}
	
	/**
	 * Sets / gets base color.
	 */
	function _setColor(value:UInt):UInt
	{
		_color = value;
		drawArc(_color);
		return value;
	}
	function _getColor():UInt
	{
		return _color;
	}
	
	/**
	 * Sets / gets highlight color.
	 */
	function _setHighlightColor(value:UInt):UInt
	{
		_highlightColor = value;
		return value;
	}
	function _getHighlightColor():UInt
	{
		return _highlightColor;
	}
	
	/**
	 * Overrides rotation by rotating arc only, allowing label / icon to be unrotated.
	 */
	function _setRotation(value:Float):Float
	{
		_bg.rotation = value;
		return value;
	}
	public function _getRotation():Float
	{
		return _bg.rotation;
	}
	
}
