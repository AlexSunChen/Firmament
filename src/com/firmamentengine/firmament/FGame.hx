package com.firmamentengine.firmament;

/**
 * ...
 * @author Jordan Wambaugh
 */


import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.events.TimerEvent;
import nme.Lib;
import nme.events.Event;
import nme.display.Bitmap;
import nme.Assets;
import nme.text.TextField;
import nme.utils.Timer;

import com.firmamentengine.firmament.FPhysicsEntity;
import com.firmamentengine.firmament.FPhysicsWorld;
import com.firmamentengine.firmament.FCamera;
class FGame 
{
	var cameras:Array<FCamera>;
	var world:FPhysicsWorld;
	var worldArray:Array<FWorld>;
	public function new() 
	{
		
		
		
		worldArray = new Array<FWorld>();
		cameras = new Array<FCamera>();
		var stage = Lib.current.stage;
		stage.addEventListener(Event.ENTER_FRAME, this_onEnterFrame);
		
		var timer = new Timer(33);
		timer.addEventListener(TimerEvent.TIMER, this_step);
		timer.start();
		
		
		
	}
	
	public function addWorld(w:FWorld) {
		this.worldArray.push(w);
	}
	
	public function addCamera(c:FCamera) {
		this.cameras.push(c);
	}
	private function this_step(timer):Void {
		//trace('step');
		for (world in this.worldArray) {
			world.step();
			
		}
	}
	private function this_onEnterFrame (event:Event):Void {
		//trace('this is called.');

		for(camera in cameras){
			camera.render(worldArray);
		}
		
	}
}