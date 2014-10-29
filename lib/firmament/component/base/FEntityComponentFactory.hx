package firmament.component.base;

import firmament.component.animation.FAnimationComponent;
import firmament.component.base.FEntityComponent;
import firmament.component.entity.FDecrementComponent;
import firmament.component.entity.FDestroyEntityComponent;
import firmament.component.event.FCollisionEventMapperComponent;
import firmament.component.event.FEntityEmitterComponent;
import firmament.component.event.FEventMapperComponent;
import firmament.component.event.FEventRelayComponent;
import firmament.component.event.FTimerComponent;
import firmament.component.physics.FBox2DComponent;
import firmament.component.physics.FNoPhysicsComponent;
import firmament.component.physics.FParticleComponent;
import firmament.component.render.FLineRenderComponent;
import firmament.component.render.FSpriteRenderComponent;
import firmament.component.render.FTextRenderComponent;
import firmament.component.render.FTilesheetRenderComponent;
import firmament.component.render.FWireframeRenderComponent;
import firmament.component.sound.FSoundComponent;
import firmament.component.spline.FSimpleFollowSplineComponent;
import firmament.component.system.FComponentFactoryComponent;
import firmament.component.system.FEntityScriptComponent;
import firmament.component.system.FSceneLoaderComponent;
import firmament.component.ui.FButtonComponent;
import firmament.component.ui.FEntityContainerComponent;


class FEntityComponentFactory{
	public static function createComponent(type:String,?componentKey:String=''):FEntityComponent {
		var className = getClassFromType(type);
		var c =Type.resolveClass(className);
		if(c==null){
			throw "class "+className+" could not be found.";
		}
		var component:FEntityComponent = Type.createInstance(c,[]);
		component.setComponentKey(componentKey);
		if(component == null){
			throw "Component of type "+type+" with class "+className+" could not be instantiated!";
		}
		return component;
	}

	public static function getClassFromType(type:String){
		var map = {
            "animation":"firmament.component.animation.FAnimationComponent"
            ,"box2d":"firmament.component.physics.FBox2DComponent"
            ,"button":"firmament.component.ui.FButtonComponent"
            ,"collisionEventMapper":"firmament.component.event.FCollisionEventMapperComponent"
            ,"componentFactory":"firmament.component.system.FComponentFactoryComponent"
            ,"decrement":"firmament.component.entity.FDecrementComponent"
            ,"destroy":"firmament.component.entity.FDestroyEntityComponent"
            ,"entityContainer":"firmament.component.ui.FEntityContainerComponent"
            ,"entityEmitter":"firmament.component.event.FEntityEmitterComponent"
            ,"eventMapper":"firmament.component.event.FEventMapperComponent"
            ,"eventRelay":"firmament.component.event.FEventRelayComponent"
            ,"followSpline":"firmament.component.spline.FSimpleFollowSplineComponent"
            ,"line":"firmament.component.render.FLineRenderComponent"
            ,"noPhysics":"firmament.component.physics.FNoPhysicsComponent"
            ,"particle":"firmament.component.physics.FParticleComponent"
            ,"sceneLoader":"firmament.component.system.FSceneLoaderComponent"
            ,"script":"firmament.component.system.FEntityScriptComponent"
            ,"sound":"firmament.component.sound.FSoundComponent"
            ,"sprite":"firmament.component.render.FSpriteRenderComponent"
            ,"state":"firmament.component.system.FStateComponent"
            ,"text":"firmament.component.render.FTextRenderComponent"
            ,"tilesheet":"firmament.component.render.FTilesheetRenderComponent"
            ,"timer":"firmament.component.event.FTimerComponent"
            ,"wireframe":"firmament.component.render.FWireframeRenderComponent"
		};

		var cls = Reflect.field(map,type);
		if(cls == null) return type;
		return cls;
	}

}



