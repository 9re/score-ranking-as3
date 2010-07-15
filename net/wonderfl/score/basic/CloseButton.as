package net.wonderfl.score.basic 
{
	import com.bit101.components.Component;
	import com.bit101.components.Style;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	/**
	 * Close button used by net.wonderfl.score.basic.CheckBox.<br/>
	 * This component is based on com.bit101.components.Component of
	 * MinimalComps v.0.9.2
	 * 
	 * @author kobayashi-taro
	 * @see http://code.google.com/p/minimalcomps/
	 */
	public class CloseButton extends Component
	{
		/**
		 * @param	$parent The parent DisplayObjectContainer on which to add this component.
		 * @param	$xpos The x position to place this component.
		 * @param	$ypos The y position to place this component.
		 * @param	$defaultHandler The event handling function to handle the default event for this component (click in this case).
		 */
		public function CloseButton($parent:DisplayObjectContainer = null, $xpos:Number = 0, $ypos:Number = 0, $defaultHandler:Function = null) 
		{
			super($parent, $xpos, $ypos);
			
			if ($defaultHandler != null) {
				addEventListener(MouseEvent.CLICK, $defaultHandler);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function init():void 
		{
			super.init();
			buttonMode = true;
			useHandCursor = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function draw():void 
		{
			filters = [getShadow(2, true)];
			super.draw();
			graphics.clear();
			graphics.beginFill(Style.BACKGROUND);
			graphics.drawRect(0, 0, 10, 10);
			graphics.endFill();
			
			graphics.lineStyle(0, Style.INPUT_TEXT);
			graphics.moveTo(3, 3);
			graphics.lineTo(8, 8);
			graphics.moveTo(3, 8);
			graphics.lineTo(8, 3);
		}
		
	}

}