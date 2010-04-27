The MIT License

Copyright (c) 2010 Arpit Mathur 
http://arpitonline.com/

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

package aurora.controls.viewContainer{
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.events.Event;
	
	import mx.core.mx_internal;
	import mx.controls.tabBarClasses.Tab;
	import mx.controls.Button;
	
	public class ViewTab extends Tab{
		
		public static const CLOSE_TAB:String = "closeTab";
		
		[Embed("/assets/cancel.png")]
		public var cancel:Class;
		
		private var closeIcon:DisplayObject;
		private var showClose:Boolean = false;
		
		
		use namespace mx_internal;
		
		public function ViewTab(){
			super();
		}
		
		override protected function createChildren():void{
			super.createChildren();
		}
		override protected function measure():void{
			super.measure();
			measuredMinWidth+=20
			measuredWidth+=20;
		}
		
		/*
		Probably inefficient but fine for quick fix. 
		When the button is rolled over to change the skin,
		the new skin gets added to the next highest depth.
		If the closeIcon is already added, it needs to be
		added to the topmost depth.
		*/
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			try{
				removeChild(this.closeIcon);
			}
			catch(e:Error){}
			closeIcon = addChild(new cancel());
			if(!showClose){
				closeIcon.visible = false;
			}
			this.textField.x-=10;
			closeIcon.x = unscaledWidth-20;
			closeIcon.y = (unscaledHeight-16)/2;
		}
		
		override protected function clickHandler(event:MouseEvent):void{
			try{
				var rect:Rectangle = new Rectangle(closeIcon.x, closeIcon.y, closeIcon.width,closeIcon.height);
				if(rect.contains(event.localX,event.localY)){
					dispatchEvent(new Event(CLOSE_TAB));
					event.stopImmediatePropagation();
				}
				else{
					super.clickHandler(event);
				}
			}catch(e:Error){
				super.clickHandler(event);
			}
			
		}
		
		override protected function rollOverHandler(event:MouseEvent):void{
			showClose = true;
			super.rollOverHandler(event);	
		}
		
		override protected function rollOutHandler(event:MouseEvent):void{
			showClose=false;
			super.rollOutHandler(event);	
		}
	}
}