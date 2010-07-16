package net.wonderfl.score.basic 
{
	import com.bit101.components.Window;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * dispatched when the window is closed by pressing push button
	 * 
	 * @eventType flash.events.Event.CLOSE
	 */
	
	[Event(name = 'close', type = 'flash.events.Event')]
	/**
	 * The Window UI with a close button.<br/>
	 * This component is based on com.bit101.components.Window of
	 * MinimalComps v.0.9.5
	 * 
	 * @author kobayashi-taro
	 * @see http://code.google.com/p/minimalcomps/
	 */
	public class Window extends com.bit101.components.Window
	{
		/**
		 * The method called when the user closes the window. You can get/set this method
		 * by getter/setter method 'onCloseClick'
		 * 
		 * @see #onCloseClick
		 * @see #_onCloseClick()
		 * @default _onCloseClick
		 */
		protected var _m_onCloseClick:Function;
		
		/**
		 * @inheritDoc
		 */
		public function Window($parent:DisplayObjectContainer = null, $xpos:Number = 0, $ypos:Number = 0, $title:String = 'Window', $onCloseClick:Function = null) 
		{
			_m_onCloseClick = $onCloseClick || _onCloseClick;
			super($parent, $xpos, $ypos, $title);
			hasCloseButton = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function addChildren():void
		{
			super.addChildren();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function draw():void 
		{
			super.draw();
			_closeButton.x = _width - 15;
		}

		override protected function onClose(e:MouseEvent):void {
			if (_m_onCloseClick != null) {
				_m_onCloseClick();
			}
			
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		/**
		 * This method is a default value for _m_onCloseClick.
		 * The callback called when the close button clicked.
		 * The default behavior of this method is as follows.
		 * You can change this by overriding this method or
		 * setting onCloseClick property.
		 * 
		 * @example
<listing version="3.0">
if (stage) parent.removeChild(this);
</listing>
		 * @see #_m_onCloseClick
		 */
		protected function _onCloseClick():void {
			if (stage) parent.removeChild(this);
		}
		
		/**
		 * The public getter/settter for the _m_onCloseClick property.
		 */
		public function set onCloseClick($value:Function):void {
			_m_onCloseClick = $value;
		}
		
		/**
		 * The public getter/settter for the _m_onCloseClick property.
		 */
		public function get onCloseClick():Function { return _m_onCloseClick; }
	}
}