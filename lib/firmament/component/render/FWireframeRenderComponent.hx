package firmament.component.render;


import nme.display.MovieClip;
import nme.display.Bitmap;
import nme.display.Shape;
import nme.display.Sprite;
import firmament.core.FShape;
import firmament.core.FPolygonShape;
import firmament.core.FCircleShape;
import firmament.core.FVector;
//import these two classes
import nme.display.BitmapData;
import nme.geom.Rectangle;
import firmament.component.base.FEntityComponent;
import firmament.core.FEntity;
import firmament.core.FCamera;
import firmament.component.physics.FPhysicsComponentInterface;
import nme.geom.Matrix;
import nme.geom.Point;

/**
 * ...
 * @author Jordan Wambaugh
 */

class FWireframeRenderComponent extends FEntityComponent, implements FRenderComponentInterface
{

	public function new() 
	{
		super();
		
	}

	override public function init(config:Dynamic){

	}
	
	public function render(camera:FCamera):Void {
		var physicsComponent:FPhysicsComponentInterface= cast(this._entity.getComponent("physics"));
		if(physicsComponent==null)return;
		var pos = physicsComponent.getPosition();
		
		camera.graphics.lineStyle(1,0xFF00FF);
		var cameraPos = camera.getTopLeftPosition();
		
		//trace(cameraPos.y);
		
		//draw entity location
		camera.graphics.drawCircle((pos.x-cameraPos.x)*camera.getZoom(),(pos.y-cameraPos.y)*camera.getZoom(),5);
		
		var shapes:Array<FShape> = physicsComponent.getShapes();
		//trace(shapes.length);
		for (shape in shapes) {
			//trace(shape.getType());
			if (Std.is(shape,FPolygonShape)) {
				//trace('poly!');
				var pshape:FPolygonShape = cast(shape);
				var counter:Int = 0;
				var pvec:FVector;
				var matrix:flash.geom.Matrix = new Matrix();
				matrix.rotate(physicsComponent.getAngle());

				for (vec in pshape.getVectors()) {
					//trace(vec.x+'   '+vec.y);
					var p:Point = new Point(vec.x,vec.y);
					p=matrix.transformPoint(p);
					vec.x=p.x;
					vec.y=p.y;
					if (counter++ > 0) {
						camera.graphics.lineTo((pos.x+vec.x-cameraPos.x)*camera.getZoom(), (pos.y+vec.y-cameraPos.y)*camera.getZoom());
					}
					pvec = vec;
					camera.graphics.moveTo(( pos.x+pvec.x - cameraPos.x)*camera.getZoom(), (pos.y+pvec.y - cameraPos.y)*camera.getZoom());
					//trace('draw');
				}
				
				if (counter > 0) {
					var vec = pshape.getVectors()[0];
					camera.graphics.lineTo((pos.x+vec.x-cameraPos.x)*camera.getZoom(), (pos.y+vec.y-cameraPos.y)*camera.getZoom());
				}
			}else if (Std.is(shape,FCircleShape)) {
				var pshape:FCircleShape = cast(shape);
				camera.graphics.drawCircle((pos.x+pshape.getLocalPosition().x-cameraPos.x)*camera.getZoom(),(pos.y+pshape.getLocalPosition().y-cameraPos.y)*camera.getZoom(),pshape.getRadius()*camera.getZoom());
		
			}
		}
	
		
	}
	public function getBitmapData():BitmapData{
		return new BitmapData(0,0);
	}
	
	override public function getType():String {
		return "render";
	}
	public function getParallaxMultiplier():Float{
		return 1;
	}
}