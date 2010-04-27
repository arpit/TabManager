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
	
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.core.mx_internal;
	import mx.core.ClassFactory;
	import mx.core.IFlexDisplayObject;
	
	import mx.controls.TabBar;
	import mx.controls.Button;
	
	import mx.collections.IList;
	import mx.containers.ViewStack;
	
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	import mx.core.DragSource;
	import mx.core.IUIComponent;
	
	import aurora.controls.viewContainer.ViewTab;
	
	public class ViewBar extends TabBar{
		
		use namespace mx_internal;
		
		public function ViewBar(){
			super();
			navItemFactory = new ClassFactory(ViewTab);
			this.addEventListener(DragEvent.DRAG_ENTER, onDragEnter);
			this.addEventListener(DragEvent.DRAG_DROP, onDragDrop);
		}
		
		override protected function createNavItem(
										label:String,
										icon:Class = null):IFlexDisplayObject{
											
			var ifdo:IFlexDisplayObject = super.createNavItem(label,icon);
			ifdo.addEventListener(ViewTab.CLOSE_TAB, onCloseTabClicked);
			ifdo.addEventListener(MouseEvent.MOUSE_DOWN, tryDrag);
			ifdo.addEventListener(MouseEvent.MOUSE_UP, removeDrag);
			return ifdo;
		}
		
		private function tryDrag(e:MouseEvent):void{
			e.target.addEventListener(MouseEvent.MOUSE_MOVE, doDrag);
		}
		
		private function removeDrag(e:MouseEvent):void{
			e.target.removeEventListener(MouseEvent.MOUSE_MOVE,doDrag);
		}
		public function onCloseTabClicked(event:Event):void{
			var index:int = getChildIndex(DisplayObject(event.currentTarget));
			if(dataProvider is IList){
				dataProvider.removeItemAt(index);
			}
			else if(dataProvider is ViewStack){
				dataProvider.removeChildAt(index);
			}
		}
		
		private function doDrag(event:MouseEvent):void{
				var ds:DragSource = new DragSource();
				ds.addData(event.currentTarget,'tabDrag');
				DragManager.doDrag(IUIComponent(event.target),ds,event);						
		}
		
		private function onDragEnter(event:DragEvent):void{
			if(event.dragSource.hasFormat('tabDrag')){
				DragManager.acceptDragDrop(IUIComponent(event.target));
			}
		}
		
		private function onDragDrop(event:DragEvent):void{
			var d:ViewTab = ViewTab(event.dragSource.dataForFormat('tabDrag'));
			var childrenArr:Array = new Array();
			d.x = mouseX;
			//d.x = DragManager.dragProxy.x;
			for(var i:Number=0; i<numChildren; i++){
				var childRef:DisplayObject = getChildAt(i);
				childrenArr.push(childRef);	
			}
			childrenArr.sortOn("x",Array.NUMERIC);
			childrenArr[0].x=0;
			for(var c:Number = 1; c<childrenArr.length; c++){
				childrenArr[c].x = childrenArr[c-1].x+childrenArr[c-1].width;
			}
		}	
	}
}