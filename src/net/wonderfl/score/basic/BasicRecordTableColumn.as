package net.wonderfl.score.basic 
{
	import com.bit101.components.Label;
	import com.bit101.components.ListItem;
	import com.bit101.components.Style;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * The column for net.wonderfl.score.basic.BasicRecordTable.<br/>
	 * This component depends on com.bit101.components.List and 
	 * com.bit101.components.ListItem of MinimalComps v.0.9.2
	 * 
	 * @author kobayashi-taro
	 * @see http://code.google.com/p/minimalcomps/
	 * @see net.wonderfl.score.basic.BasicRecordTable
	 */
	public class BasicRecordTableColumn extends ListItem
	{
		private var _back:Sprite;
		private var _tfRow0:TextField;
		private var _tfRow1:TextField;
		private var _tfRow2:TextField;
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this BasicRecordTableColumn.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param label The text to show in this item.
		 */
		public function BasicRecordTableColumn($parent:DisplayObjectContainer, $xpos:Number, $ypos:Number) 
		{
			super($parent, $xpos, $ypos);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function init():void 
		{
			super.init();
			mouseChildren = mouseEnabled = false;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function addChildren():void 
		{
			_label = new Label;
			_back = new Sprite;
			_back.filters = [getShadow(2, true)];
			addChild(_back);
			
			_height = 19;
			_width = 200;
			addToDisplayList(_tfRow0 = getTextField(), { x:2, y:1, width:20, height:_height} );
			addToDisplayList(_tfRow1 = getTextField(), { x:18, y:1, width:100, height:_height } );
			addToDisplayList(_tfRow2 = getTextField(), { x:162, y:1, width:40, height:_height } );
			
		}
		
		private function addToDisplayList($displayObject:*, $initObject:Object = null):void
		{
			$initObject ||= { };
			for (var propName:String in $initObject)
				$displayObject[propName] = $initObject[propName];
				
			addChild($displayObject as DisplayObject);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function draw():void 
		{
			_back.graphics.clear();
			_back.graphics.beginFill(Style.BUTTON_FACE);
			_back.graphics.drawRect(0, 0, _width, _height);
			_back.graphics.endFill();
			
			_tfRow0.height = _height;
			_tfRow1.height = _height;
			_tfRow2.height = _height;
			
			if (_data) {
				_tfRow0.text = _data.rank;
				_tfRow1.text = _data.name;
				_tfRow2.text = _data.score;
				_tfRow2.width = _tfRow2.textWidth + 4;
				_tfRow2.x = _width - _tfRow2.width - 12;
			}
			
			super.draw();
		}
		
		protected function getTextField():TextField {
			var tf:TextField = new TextField();
			tf.height = _height;
			tf.embedFonts = true;
			tf.selectable = false;
			tf.mouseEnabled = false;
			tf.defaultTextFormat = new TextFormat("PF Ronda Seven", 8, Style.LABEL_TEXT);
			
			return tf;
		}
	}

}