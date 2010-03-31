package net.wonderfl.score.basic 
{
	import com.adobe.serialization.json.JSON;
	import com.bit101.components.Label;
	import com.bit101.components.List;
	import com.bit101.components.Panel;
	import com.bit101.components.Style;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import net.wonderfl.score.viewer.ScoreRecordViewer;
	
	/**
	 * Simple implementation of ScoreRecordViewer<br/>
	 * The ui of this form consists chiefly of MinimalComps v.0.9.2
	 * 
	 * @author kobayashi-taro
	 * @see http://code.google.com/p/minimalcomps/
	 */
	public class BasicScoreRecordViewer extends ScoreRecordViewer
	{
		/**
		 * The default width of this component
		 */
		public static const WIDTH:int = 220;
		/**
		 * The default height of this component
		 */
		public static const HEIGHT:int = 240;
		/**
		 * The window UI
		 */
		protected var _window:Window;
		
		/**
		 * The title of the window
		 */
		protected var _title:String;
		
		/**
		 * The TextField for displaying error messages.
		 */
		protected var _tfMessage:TextField;
		
		/**
		 * Reference to the List component.
		 */
		protected var _list:List;
		
		/**
		 * Constructor
		 * 
		 * @param $parent The parent DisplayObjectContainer on which to add this BasicScoreRecordViewer.
		 * @param $xpos The x position to place this component.
		 * @param $ypos The y position to place this component.
		 * @param $title The string to display in the title bar.
		 * @param	$limit The max count of the score records.
		 * @param	$descend If this flag is set true, the record is sorted by 
		 * descending order, otherwise, the record is sorted by ascending order.
		 * @param $onCloseClick The callback called when close button is clicked
		 * @param	$app_id If you want to access the api outside from wonderfl.net, set this parameter.
		 * @param	$api_key If you want to access the api outside from wonderfl.net, set this parameter.
		 * 
		 * @see http://wonderfl.net/apis/methods#method_scoreget
		 * @see http://wonderfl.net/apis/methods#method_scorepost
		 */
		public function BasicScoreRecordViewer($parent:DisplayObjectContainer = null, $xpos:Number = 0, $ypos:Number = 0, $title:String = 'SCORE RANKING', $limit:int = 20, $descend:Boolean = true, $onCloseClick:Function = null, $app_id:String = '', $api_key:String = '') 
		{
			_title = $title;
			_window = new Window(this, 0, 0, _title, $onCloseClick);
			_window.setSize(WIDTH, HEIGHT);
			super($limit, $descend, $app_id, $api_key);
			
			move($xpos, $ypos);
			
			if($parent != null)
			{
				$parent.addChild(this);
			}
		}
		
		/**
		 * Moves the component to the specified position.
		 * @param $xpos the x position to move the component
		 * @param $ypos the y position to move the component
		 */
		public function move($xpos:Number, $ypos:Number):void
		{
			x = $xpos >> 0;
			y = $ypos >> 0;
		}
		
		/**
		 * Method called when getting score record is
		 * failed. You can change the behavior of this method
		 * by overriding it.
		 */
		override protected function onIOError():void 
		{
		}
		
		/**
		 * Method called when getting score record is completed successfully.
		 * 
		 * @param	$data The score record described as follows.
		 * @example
<listing version="3.0">
[
    {
      "name":"mash4", "score":"84", "rank" : 1
    },
    {
      "name":"mash3", "score":"84", "rank" : 1
    },
    {
      "name":"mash2", "score":"82", "rank" : 2
    },
	...
]
</listing>
		 */
		override protected function onComplete($data:Array):void 
		{
			if ($data.length) {
				_list ||= new List(null, 11, 30, $data);
				_list.listItemHeight = 20;
				_list.listItemClass = BasicRecordTableColumn;
				_list.width = _list.height = 200;
				_list.items = $data.slice();
				_window.addChild(_list);
				
				removeFromParent(_tfMessage);
			} else {
				_window.addChild(
					getMessageField('NO ENTRIES YET', new TextFormat("PF Ronda Seven", 8, Style.LABEL_TEXT))
				);
			}
		}
		
		/**
		 * Removes the display object from its parent, if possible.
		 * @param	$displayObject
		 */
		protected function removeFromParent($displayObject:DisplayObject):void {
			if ($displayObject && $displayObject.parent) $displayObject.parent.removeChild($displayObject);
		}
		
		/**
		 * @private
		 */
		protected function getMessageField($message:String, $textFormat:TextFormat):TextField {
			_tfMessage ||= new TextField;
			
			_tfMessage.embedFonts = true;
			_tfMessage.selectable = false;
			_tfMessage.mouseEnabled = false;
			_tfMessage.text = $message;
			_tfMessage.setTextFormat($textFormat);
			_tfMessage.width = _tfMessage.textWidth + 4;
			_tfMessage.height = _tfMessage.textHeight + 4;
			_tfMessage.x = (WIDTH - _tfMessage.width) >> 1;
			_tfMessage.y = ((WIDTH - _tfMessage.height) >> 1) + 20;
			
			return _tfMessage;
		}
		
		/**
		 * Method called when the response of the api contains error messages.
		 * 
		 * @param	$errorMessage The error message returned from the api.
		 */
		override protected function onError($errorMessage:String):void 
		{
			_window.addChild(
				getMessageField($errorMessage, new TextFormat("PF Ronda Seven", 8, 0xff0000))
			);
		}
		
		/**
		 * The title of the window
		 */
		public function get title():String { return _title; }
		
		/**
		 * The title of the window
		 */
		public function set title(value:String):void 
		{
			_window.title = value;
		}
		
	}
}
